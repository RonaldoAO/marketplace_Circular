import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/blockchain/sei_wallet_provider.dart';
import '../../../../core/blockchain/sei_wallet_service.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  late SeiWalletService walletService;

  @override
  void initState() {
    super.initState();
    walletService = ref.read(seiWalletServiceProvider);
    // Escuchar cambios del servicio
    walletService.addListener(_onWalletChanged);
  }

  @override
  void dispose() {
    walletService.removeListener(_onWalletChanged);
    super.dispose();
  }

  void _onWalletChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = walletService.isConnected;
    final shortAddress = walletService.shortAddress;
    final balance = walletService.balanceInSei;

    final items = [
      ('Perfil', Icons.person_outline_rounded),
      ('Mis productos', Icons.store_mall_directory_outlined),
      ('Guardados', Icons.bookmark_outline),
      ('Configuracion', Icons.settings_outlined),
      ('Ayuda y Soporte', Icons.help_outline),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Account, saved items, and app settings.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            // Wallet Connection Card
            _WalletConnectionCard(
              isConnected: isConnected,
              shortAddress: shortAddress,
              balance: balance,
              walletService: walletService,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.black.withValues(alpha: 0.05),
                      child: Icon(item.$2, color: Colors.black87),
                    ),
                    title: Text(
                      item.$1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Colors.grey),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de tarjeta para conexión de wallet
class _WalletConnectionCard extends StatelessWidget {
  const _WalletConnectionCard({
    required this.isConnected,
    required this.shortAddress,
    required this.balance,
    required this.walletService,
  });

  final bool isConnected;
  final String? shortAddress;
  final String balance;
  final dynamic walletService;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isConnected
              ? [const Color(0xFF8B1538), const Color(0xFFB91D47)]
              : [Colors.grey[800]!, Colors.grey[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isConnected ? const Color(0xFF8B1538) : Colors.grey[700]!)
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isConnected ? null : () => _connectWallet(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isConnected ? 'Wallet Conectada' : 'Conectar Wallet',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isConnected
                                ? shortAddress ?? ''
                                : 'Conecta tu wallet para comenzar',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isConnected)
                      IconButton(
                        onPressed: () => _showWalletOptions(context),
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                if (isConnected) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Balance',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              balance,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => walletService.refreshBalance(),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _connectWallet(BuildContext context) async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final success = await walletService.connectWallet();
      if (context.mounted) {
        Navigator.of(context).pop(); // Cerrar loading

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wallet conectada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo conectar la wallet'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Cerrar loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showWalletOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copiar dirección'),
                onTap: () {
                  // TODO: Implementar copiar al portapapeles
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Actualizar balance'),
                onTap: () {
                  walletService.refreshBalance();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: Text(
                    'Cambiar a ${walletService.isTestnet ? "Mainnet" : "Testnet"}'),
                onTap: () async {
                  await walletService.toggleNetwork();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Desconectar',
                    style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await walletService.disconnectWallet();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
