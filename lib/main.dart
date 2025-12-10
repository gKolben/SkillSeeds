// Comentário: Importa o pacote principal do Flutter (Material Design).
import 'package:flutter/material.dart';
// Comentário: Importa o Riverpod para gerenciamento de estado.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Comentário: Importa os pacotes para carregar o .env e conectar ao Supabase.
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/core/providers/providers_state.dart';
import 'package:skillseeds/core/providers/theme_mode_provider.dart';
import 'package:skillseeds/core/services/prefs_services.dart';

// Comentário: Importa as configurações de rotas e tema do nosso app.
import 'package:skillseeds/core/config/app_routes.dart';
import 'package:skillseeds/core/config/app_theme.dart';

// Comentário: Importa todas as telas (screens) que o app vai usar.
import 'package:skillseeds/features/home/presentation/home_screen.dart';
import 'package:skillseeds/features/onboarding/presentation/onboarding_screen.dart';
import 'package:skillseeds/features/policy/presentation/policy_screen.dart';
import 'package:skillseeds/features/profile/presentation/index.dart';
import 'package:skillseeds/features/splash/presentation/splash_screen.dart';

// --- FEATURE 1: TELA DE LIÇÕES ---
import 'package:skillseeds/features/lessons/presentation/index.dart';

// --- FEATURE 2: TELA DE CONQUISTAS ---
// Comentário: Importa a nova tela de conquistas via barrel da feature.
import 'package:skillseeds/features/achievements/index.dart';

// Comentário: A função main() é o ponto de entrada de todo aplicativo Dart.
// Comentário: Ela é 'async' para podermos esperar serviços (como Supabase) inicializarem.
void main() async {
  // Comentário: Garante que os "bindings" do Flutter estejam prontos antes de
  //             qualquer outra coisa (necessário para o async no main).
  WidgetsFlutterBinding.ensureInitialized();

  // Comentário: Carrega as variáveis de ambiente (nossas chaves) do arquivo .env.
  await dotenv.load(fileName: ".env");

  // Comentário: Lê as chaves do .env para uma variável.
  // Lê as variáveis cruas do .env (pode conter <> se o usuário copiou/colou)
  final rawSupabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final rawSupabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    // Sanitiza valores removendo: sinais <>, aspas e espaços acidentais.
    // Usamos chamadas simples para evitar erros de escape em regex.
    final supabaseUrl = rawSupabaseUrl
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('"', '')
      .replaceAll('\'', '')
      .trim();
    final supabaseAnonKey = rawSupabaseAnonKey
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('"', '')
      .replaceAll('\'', '')
      .trim();

  // Validação de segurança: garante que os valores existam após sanitização.
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception('Faltam SUPABASE_URL ou SUPABASE_ANON_KEY no arquivo .env');
  }

  // Comentário: Inicializa a conexão com o Supabase usando as chaves carregadas.
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Inicializa o SharedPreferences antes de criar o ProviderScope para
  // garantir que providers sincronos que dependem dele (ex: PrefsService)
  // tenham acesso imediato aos valores persistidos.
  final sharedPrefs = await SharedPreferences.getInstance();

  // Roda o nosso aplicativo, sobrescrevendo os providers que dependem
  // de SharedPreferences para já estarem prontos no momento da criação.
  runApp(
    ProviderScope(
      overrides: [
        prefsServiceProvider.overrideWithValue(PrefsService(sharedPrefs)),
      ],
      child: const SkillSeeds(),
    ),
  );
}

// Comentário: Esta é a classe raiz do nosso aplicativo (o Widget principal).
class SkillSeeds extends ConsumerWidget {
  // Comentário: Construtor padrão para o widget.
  const SkillSeeds({super.key});

  // Comentário: O método build() desenha a UI na tela.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Comentário: MaterialApp é o widget que configura todo o app
    //             (tema, rotas, título, etc.).
    return MaterialApp(
      // Comentário: O título que aparece no gerenciador de tarefas do S.O.
      title: 'SkillSeeds',

      // Comentário: Define o tema (cores, fontes) que criamos em app_theme.dart.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Comentário: Remove a faixa "DEBUG" do canto da tela.
      debugShowCheckedModeBanner: false,

      // Comentário: Define qual rota deve ser aberta quando o app inicia.
      initialRoute: AppRoutes.splash,

      // Comentário: O mapa de rotas. Ele diz ao Flutter qual tela (Widget)
      //             abrir para cada "apelido" (String) do AppRoutes.
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.policy: (context) => const PolicyScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),

        // --- FEATURE 1: TELA DE LIÇÕES ---
        AppRoutes.lessons: (context) => const LessonListScreen(),

        // --- FEATURE 2: TELA DE CONQUISTAS ---
        // Comentário: Registra a nova rota de conquistas.
        AppRoutes.achievements: (context) => const AchievementListScreen(), // <-- NOVO
      },
    );
  }
}