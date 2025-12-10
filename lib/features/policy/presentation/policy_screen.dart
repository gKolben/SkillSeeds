// Comentário: Importa os pacotes necessários do Flutter, Riverpod e Markdown.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/core/config/app_routes.dart';
import 'package:skillseeds/core/providers/providers.dart';

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
    if (!mounted) return;
    
    await showDialog(
      context: context,
      builder: (dialogContext) => _PolicyDialog(
        title: title,
        content: content,
        onRead: () {
          // Comentário: Atualiza o estado da política lida.
          if (assetPath.contains('privacy')) {
            setState(() => _privacyPolicyRead = true);
          } else {
            setState(() => _termsOfUseRead = true);
          }
          _checkCanProceed();
        },
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
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar consentimento: ${e.toString()}'),
          ),
        );
      }
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
                onPressed: _isLoading || !_consentChecked
                    ? null
                    : _onSaveAndContinue,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// Comentário: Widget de diálogo com detecção de rolagem até o final
class _PolicyDialog extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onRead;

  const _PolicyDialog({
    required this.title,
    required this.content,
    required this.onRead,
  });

  @override
  State<_PolicyDialog> createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<_PolicyDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Comentário: Verifica se o conteúdo é pequeno o suficiente para não precisar de scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll == 0) {
          // Conteúdo cabe na tela sem scroll
          setState(() => _hasScrolledToBottom = true);
        }
      }
    });
  }

  void _onScroll() {
    if (!_hasScrolledToBottom && _scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      // Comentário: Considera "final" quando está a menos de 20 pixels do fim
      if (currentScroll >= maxScroll - 20) {
        setState(() => _hasScrolledToBottom = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: MarkdownBody(data: widget.content),
                  ),
                ),
              ),
            ),
            if (!_hasScrolledToBottom)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Role até o final para aceitar',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _hasScrolledToBottom
              ? () {
                  widget.onRead();
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Marcar como Lido'),
        ),
      ],
    );
  }
}
