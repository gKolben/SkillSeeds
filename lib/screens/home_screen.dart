import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/config/app_routes.dart';
import 'package:skillseeds/config/app_theme.dart';
import 'package:skillseeds/providers/providers.dart';
import 'package:skillseeds/widgets/privacy_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PrivacyDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final userEmail = ref.watch(userEmailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillSeeds'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userName.isEmpty ? 'Usuário SkillSeeds' : userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(
                userEmail.isEmpty ? 'Complete seu perfil' : userEmail,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/images/app_icon.png',
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Editar Perfil'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text('Privacidade & Consentimentos'),
              onTap: () {
                Navigator.of(context).pop();
                _showPrivacyDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bem-vindo(a)!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Text('Escolha sua trilha de aprendizado:',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  _TrackCard(
                    title: 'Design',
                    description: 'Atalhos de ferramentas e conceitos de UI/UX.',
                  ),
                  SizedBox(height: 16),
                  _TrackCard(
                    title: 'Desenvolvimento',
                    description: 'Domine atalhos do VS Code, Git e terminal.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackCard extends StatelessWidget {
  final String title;
  final String description;

  const _TrackCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trilha de $title selecionada!')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}