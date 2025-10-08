import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/config/app_routes.dart';
import 'package:skillseeds/providers/providers.dart';

class PolicyScreen extends ConsumerStatefulWidget {
  const PolicyScreen({super.key});

  @override
  ConsumerState<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends ConsumerState<PolicyScreen> {
  bool _privacyPolicyRead = false;
  bool _termsOfUseRead = false;
  bool _consentChecked = false;

  void _checkCanProceed() {
    setState(() {
      _consentChecked = _privacyPolicyRead && _termsOfUseRead;
    });
  }

  Future<void> _showPolicyDialog(String title, String assetPath) async {
    final content = await rootBundle.loadString(assetPath);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: MarkdownBody(data: content),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (assetPath.contains('privacy')) {
                setState(() => _privacyPolicyRead = true);
              } else {
                setState(() => _termsOfUseRead = true);
              }
              _checkCanProceed();
            },
            child: const Text('Marcar como Lido'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Políticas e Termos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Para continuar, por favor, leia e aceite nossos documentos.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              _PolicyButton(
                title: 'Política de Privacidade',
                isRead: _privacyPolicyRead,
                onPressed: () => _showPolicyDialog('Política de Privacidade', 'assets/policies/privacy_policy.md'),
              ),
              const SizedBox(height: 16),
              _PolicyButton(
                title: 'Termos de Uso',
                isRead: _termsOfUseRead,
                onPressed: () => _showPolicyDialog('Termos de Uso', 'assets/policies/terms_of_use.md'),
              ),
              
              const Spacer(),

              CheckboxListTile(
                title: const Text('Li e concordo com os documentos acima.'),
                value: _consentChecked,
                onChanged: _privacyPolicyRead && _termsOfUseRead
                    ? (bool? value) {
                        setState(() {
                          _consentChecked = value ?? false;
                        });
                      }
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _consentChecked
                    ? () {
                        final prefs = ref.read(prefsServiceProvider);
                        prefs.saveConsent();
                        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                      }
                    : null,
                child: const Text('Salvar e Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyButton extends StatelessWidget {
  final String title;
  final bool isRead;
  final VoidCallback onPressed;

  const _PolicyButton({
    required this.title,
    required this.isRead,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(isRead ? Icons.check_circle : Icons.picture_as_pdf_outlined),
      label: Text(title),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isRead ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor,
        side: BorderSide(
          color: isRead ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}