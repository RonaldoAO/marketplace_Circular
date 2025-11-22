import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScanItemPage extends StatefulWidget {
  const ScanItemPage({super.key});

  @override
  State<ScanItemPage> createState() => _ScanItemPageState();
}

class _ScanItemPageState extends State<ScanItemPage> {
  CameraController? _controller;
  Future<void>? _initializeFuture;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _setupCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _controller = controller;
      await controller.initialize();
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeFuture,
              builder: (context, snapshot) {
                if (_error != null) {
                  return _CameraFallback(message: _error!);
                }
                if (_controller == null ||
                    snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return CameraPreview(_controller!);
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        icon: Icons.close,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Column(
                        children: const [
                          Text(
                            'Tomar foto del material',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Coloque el material dentro del marco.\nPor favor, mantenga su dispositivo estable.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      _CircleButton(
                        icon: Icons.flash_off,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.maxWidth - 40;
                    return Center(
                      child: Container(
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white, width: 3),
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 26,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _RoundMiniButton(
                            icon: Icons.filter_center_focus,
                            label: 'Scan symbols',
                          ),
                          _RoundMiniButton(
                            icon: Icons.camera_alt_outlined,
                            label: 'Similar clothes',
                            highlighted: true,
                          ),
                          _RoundMiniButton(
                            icon: Icons.photo_library_outlined,
                            label: 'Gallery',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _CircleButton(
                        size: 70,
                        icon: Icons.camera,
                        onTap: () {},
                        background: Colors.white,
                        iconColor: Colors.black87,
                        shadow: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.background = Colors.black54,
    this.iconColor = Colors.white,
    this.shadow = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color background;
  final Color iconColor;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Icon(icon, color: iconColor, size: size * 0.45),
      ),
    );
  }
}

class _RoundMiniButton extends StatelessWidget {
  const _RoundMiniButton({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: highlighted ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(18),
            border: highlighted
                ? Border.all(color: const Color(0xFF6E8D6B))
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: highlighted ? Colors.black87 : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: highlighted ? Colors.black87 : Colors.white,
                  fontSize: 12,
                  fontWeight: highlighted ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CameraFallback extends StatelessWidget {
  const _CameraFallback({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.videocam_off, color: Colors.white54, size: 48),
          const SizedBox(height: 8),
          Text(
            'No se pudo abrir la cámara',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
