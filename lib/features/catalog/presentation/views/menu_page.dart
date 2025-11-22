import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String? _connectedWallet;
  bool _isConnecting = false;

  final _items = const [
    ('Profile', Icons.person_outline_rounded),
    ('My Listings', Icons.store_mall_directory_outlined),
    ('Saved', Icons.bookmark_outline),
    ('Settings', Icons.settings_outlined),
    ('Help & Support', Icons.help_outline),
  ];

  Future<void> _connectWallet(String walletName, String address) async {
    setState(() => _isConnecting = true);

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _connectedWallet = '$walletName · $address';
      _isConnecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conectado a Sei con $walletName'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _disconnectWallet() {
    setState(() => _connectedWallet = null);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión de Sei desconectada'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openWalletSelector() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final wallets = [
          ('Compass Wallet', 'sei1p3kq4x9d2t3v6s8h4xk7y8z9s4c2l0v5'),
          ('Fin Wallet', 'sei1t9q4m5n7w2h6x8y4z1p0c3v9s7d5f2'),
          ('Leap Cosmos', 'sei1n8d6s4f2p0c3v9z7x5w1h6k8y4m2t'),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Text(
                  'Conectar wallet Sei',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sei es la Layer 1 EVM más rápida. Selecciona tu wallet para firmar transacciones en segundos.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                for (final wallet in wallets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.06),
                        child: const Icon(Icons.account_balance_wallet_outlined,
                            color: Colors.black87),
                      ),
                      title: Text(wallet.$1,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        '${wallet.$2.substring(0, 8)}...${wallet.$2.substring(wallet.$2.length - 4)}',
                        style: const TextStyle(letterSpacing: 0.2),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _connectWallet(wallet.$1, wallet.$2);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            _SeiWalletCard(
              isConnecting: _isConnecting,
              connectedWallet: _connectedWallet,
              onConnect: _openWalletSelector,
              onDisconnect: _disconnectWallet,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _items[index];
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

class _SeiWalletCard extends StatelessWidget {
  const _SeiWalletCard({
    required this.isConnecting,
    required this.connectedWallet,
    required this.onConnect,
    required this.onDisconnect,
  });

  final bool isConnecting;
  final String? connectedWallet;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Sei · Fastest L1 EVM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (connectedWallet != null)
                TextButton.icon(
                  onPressed: onDisconnect,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Desconectar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Conecta tu wallet Sei para firmar transacciones y gestionar tus activos en la cadena más rápida.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          if (connectedWallet != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      connectedWallet!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else
            Text(
              'Sin wallet conectada',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isConnecting ? null : onConnect,
            icon: isConnecting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Icon(Icons.link),
            label: Text(
              isConnecting
                  ? 'Esperando firma...'
                  : connectedWallet != null
                      ? 'Cambiar wallet Sei'
                      : 'Conectar wallet Sei',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
