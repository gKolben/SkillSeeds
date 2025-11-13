// Comentário: Importa os pacotes necessários do Flutter, Riverpod e Markdown.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/config/app_routes.dart';
import 'package:skillseeds/providers/providers.dart';

// Comentário: Mudamos para ConsumerStatefulWidget para gerenciar o estado local
//             (como _isLoading) e ainda ter acesso ao 'ref' do Riverpod.
class PolicyScreen extends ConsumerStatefulWidget {
  const PolicyScreen({super.key});

  @override
  ConsumerState<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends ConsumerState<PolicyScreen> {
  // Comentário: Estado local para controlar o que já foi lido.
  bool _privacyPolicyRead = false;
  bool _termsOfUseRead = false;
  bool _consentChecked = false;

  // --- CORREÇÃO DO BUG ---
  // Comentário: Adiciona um estado de 'loading' para o botão de salvar.
  bool _isLoading = false;

  // Comentário: Função de controle para habilitar o checkbox final.
  void _checkCanProceed() {
    setState(() {
      _consentChecked = _privacyPolicyRead && _termsOfUseRead;
    });
  }

  // Comentário: Função que abre o diálogo de visualização da política (Markdown).
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
              // Comentário: Atualiza o estado da política lida.
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

  // --- CORREÇÃO DO BUG ---
  // Comentário: Esta é a função principal que corrige o bug.
  //             Ela agora é 'async' para 'esperar' os dados serem salvos.
  Future<void> _onSaveAndContinue() async {
    // Comentário: 1. Mostra o 'loading' e desabilita o botão para evitar cliques duplos.
    setState(() => _isLoading = true);

    // Comentário: 2. Pega o serviço de preferências.
    final prefs = ref.read(prefsServiceProvider);

    // Comentário: 3. Salva AMBOS os status (o consentimento E o 'onboarding concluído').
    //             Usamos 'await' para garantir que sejam salvos antes de navegar.
    try {
      await prefs.saveConsent();
      await prefs.setOnboardingCompleted(); // <-- A LINHA QUE CORRIGE O BUG

      // Se salvou com sucesso, paramos o loading e navegamos.
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (e, st) {
      // Se houve erro ao salvar (ex.: plugin inacessível no web),
      // mostramos uma mensagem e reabilitamos o botão.
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar consentimento: ${e.toString()}'),
          ),
        );
      }
      // Opcional: log do stacktrace para facilitar debug durante desenvolvimento
      // ignore: avoid_print
      print('Failed to save consent: $e\n$st');
      return;
    }
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
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
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
                onPressed: () => _showPolicyDialog(
                    'Política de Privacidade', 'assets/policies/privacy_policy.md'),
              ),
              const SizedBox(height: 16),
              _PolicyButton(
                title: 'Termos de Uso',
                isRead: _termsOfUseRead,
                onPressed: () => _showPolicyDialog(
                    'Termos de Uso', 'assets/policies/terms_of_use.md'),
              ),
              const Spacer(),
              CheckboxListTile(
                title: const Text('Li e concordo com os documentos acima.'),
                value: _consentChecked,
                // Comentário: O checkbox só é habilitado após ler os dois documentos.
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
                // Comentário: O botão é desabilitado se estiver carregando (loading)
                //             OU se o consentimento não tiver sido marcado.
                onPressed: _isLoading || !_consentChecked
                    ? null
                    : _onSaveAndContinue, // <-- Chama a nova função async
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        // Comentário: Mostra um indicador de progresso
                        //             enquanto salva.
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('Salvar e Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Comentário: Widget auxiliar para o botão de política.
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
        foregroundColor: isRead
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).primaryColor,
        side: BorderSide(
          color: isRead
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}