import 'dart:async';

import 'package:flutter/material.dart';

import '../../../catalog/presentation/views/home_tabs_page.dart';
import 'auth_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _controller;
  late final Timer _timer;
  int _current = 0;

  final _slides = [
    _Slide(
      title: 'Intercambia con confianza',
      description:
          'Encuentra productos cerca de ti y acuerda intercambios seguros.',
      imageUrl:
          'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=900&q=80',
    ),
    _Slide(
      title: 'Chatea y acuerda',
      description: 'Coordina entregas con mensajeria integrada y alertas.',
      imageUrl:
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=900&q=80',
    ),
    _Slide(
      title: 'Gana y recicla',
      description: 'Dale segunda vida a tus articulos y genera ahorros.',
      imageUrl:
          'https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?auto=format&fit=crop&w=900&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      _current = (_current + 1) % _slides.length;
      _controller.animateToPage(
        _current,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goToAuth() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeTabsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.refresh, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'EcoMarket',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _goToHome,
                    child: const Text(
                      'Saltar',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textHeight = constraints.maxHeight * 0.33;
                    final imageHeight = constraints.maxHeight - textHeight;
                    return Stack(
                      children: [
                        SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _controller,
                            onPageChanged: (index) =>
                                setState(() => _current = index),
                            itemCount: _slides.length,
                            itemBuilder: (context, index) {
                              final slide = _slides[index];
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 420),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeOut,
                                child: _SlideImage(
                                  key: ValueKey(slide.imageUrl),
                                  slide: slide,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: imageHeight - 80,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: textHeight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.85),
                                  Colors.black,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: textHeight - 32,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 320),
                                      switchInCurve: Curves.easeOut,
                                      switchOutCurve: Curves.easeOut,
                                      child: Column(
                                        key: ValueKey(_slides[_current].title),
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _slides[_current].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _slides[_current].description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 15,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: _goToAuth,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF6E8D6B),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'Comenzar',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideImage extends StatelessWidget {
  const _SlideImage({super.key, required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.network(slide.imageUrl, fit: BoxFit.cover),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }
}

class _Slide {
  _Slide({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  final String title;
  final String description;
  final String imageUrl;
}
