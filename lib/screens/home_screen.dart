import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/config/app_routes.dart';
import 'package:skillseeds/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showRevokeConsentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revogar Consentimento'),
        content: const Text(
            'Você tem certeza? Isso limpará seus dados de consentimento e o levará de volta ao início.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final prefs = ref.read(prefsServiceProvider);
              prefs.clearConsent();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.onboarding, (route) => false);
            },
            child: const Text('Revogar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillSeeds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showRevokeConsentDialog(context, ref),
          ),
        ],
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
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}