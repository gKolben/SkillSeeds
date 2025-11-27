import 'package:flutter/material.dart';
import 'package:skillseeds/core/config/app_routes.dart';
import 'package:skillseeds/core/config/app_theme.dart';
import 'package:skillseeds/core/widgets/dots_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Bem-vindo ao SkillSeeds!",
      "description": "Aprenda algo novo e útil em apenas 5 minutos por dia.",
    },
    {
      "title": "Como Funciona",
      "description":
          "Escolha uma trilha de aprendizado e complete um micro-exercício diariamente para criar um novo hábito.",
    },
    {
      "title": "Pronto para Começar?",
      "description":
          "Antes de iniciar, precisamos que você leia e aceite nossas políticas.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/app_icon.png',
                          height: 150,
                        ),
                        const SizedBox(height: 50),
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          onboardingData[index]['description']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Visibility(
                    visible: _currentPage < onboardingData.length - 1,
                    child: DotsIndicator(
                      dotsCount: onboardingData.length,
                      position: _currentPage,
                      decorator: const DotsDecorator(
                        activeColor: AppTheme.primaryColor,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_currentPage == onboardingData.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.policy);
                      },
                      child: const Text("Ler Políticas e Concordar"),
                    )
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const Text("Avançar"),
                    ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: _currentPage < onboardingData.length - 1,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.policy);
                      },
                      child: const Text("Pular"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
