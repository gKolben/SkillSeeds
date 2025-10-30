import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/config/app_theme.dart';
import 'package:skillseeds/providers/providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ref.read(userNameProvider));
    _emailController = TextEditingController(text: ref.read(userEmailProvider));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newName = _nameController.text.trim();
      final newEmail = _emailController.text.trim();

      final prefs = ref.read(prefsServiceProvider);
      prefs.saveUserProfile(newName, newEmail);

      ref.read(userNameProvider.notifier).state = newName;
      ref.read(userEmailProvider.notifier).state = newEmail;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                final trimmedValue = value?.trim() ?? '';
                if (trimmedValue.isEmpty) {
                  return 'Por favor, digite seu nome.';
                }
                if (trimmedValue.length < 2) {
                  return 'O nome deve ter pelo menos 2 caracteres.';
                }
                if (!RegExp(r'[a-zA-ZÀ-ú]').hasMatch(trimmedValue)) {
                  return 'Por favor, digite um nome válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final trimmedValue = value?.trim() ?? '';
                if (trimmedValue.isEmpty) {
                  return 'Por favor, digite seu e-mail.';
                }
                final emailRegex = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
                if (!emailRegex.hasMatch(trimmedValue)) {
                  return 'Por favor, digite um e-mail válido (ex: nome@dominio.com).';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Aviso de Privacidade: Seu nome e e-mail são usados apenas para personalizar sua experiência no app e não são compartilhados.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onSave,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}