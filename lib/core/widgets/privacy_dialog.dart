// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/core/config/app_routes.dart';
import 'package:skillseeds/core/config/app_theme.dart';
import 'package:skillseeds/core/providers/providers.dart';

class PrivacyDialog extends ConsumerStatefulWidget {
  const PrivacyDialog({super.key});

  @override
  ConsumerState<PrivacyDialog> createState() => _PrivacyDialogState();
}

class _PrivacyDialogState extends ConsumerState<PrivacyDialog> {
  late bool _marketingConsent;
  bool _deletePersonalData = false;

  @override
  void initState() {
    super.initState();
    _marketingConsent = ref.read(prefsServiceProvider).getMarketingConsent();
  }

  void _onSaveChanges() {
    final prefs = ref.read(prefsServiceProvider);

    prefs.setMarketingConsent(_marketingConsent);

    if (_deletePersonalData) {
      prefs.clearUserProfile();

      prefs.clearConsent();

      ref.read(userNameProvider.notifier).state = '';
      ref.read(userEmailProvider.notifier).state = '';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consentimentos revogados e dados pessoais apagados.'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.onboarding,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferências de privacidade salvas.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Privacidade & Consentimentos'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Consentimento de Marketing'),
              subtitle: const Text(
                'Permitir o envio de novidades e promoções relevantes.',
                style: TextStyle(fontSize: 12),
              ),
              value: _marketingConsent,
              onChanged: (value) {
                setState(() {
                  _marketingConsent = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            SwitchListTile(
              title: const Text('Apagar Dados Pessoais'),
              subtitle: const Text(
                'Isso irá remover seu nome e e-mail do app e revogar todos os consentimentos.',
                style: TextStyle(fontSize: 12),
              ),
              value: _deletePersonalData,
              onChanged: (value) {
                setState(() {
                  _deletePersonalData = value;
                });
              },
              contentPadding: EdgeInsets.zero,
              activeThumbColor: Colors.red,
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            side: BorderSide(color: AppTheme.primaryColor),
          ),
          child: const Text('Cancelar'),
        ),
        OutlinedButton(
          onPressed: _onSaveChanges,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            side: BorderSide(color: AppTheme.primaryColor),
          ),
          child: Text(_deletePersonalData ? 'Apagar e Sair' : 'Salvar Alterações'),
        ),
      ],
    );
  }
}
