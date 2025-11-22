import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sei_wallet_service.dart';

// Instancia global del servicio (singleton)
final _walletServiceInstance = SeiWalletService();

/// Provider del servicio de wallet de Sei
final seiWalletServiceProvider = Provider<SeiWalletService>((ref) {
  return _walletServiceInstance;
});

/// Provider para verificar si la wallet está conectada
final isWalletConnectedProvider = Provider<bool>((ref) {
  ref.watch(seiWalletServiceProvider);
  return _walletServiceInstance.isConnected;
});

/// Provider para la dirección de la wallet
final walletAddressProvider = Provider<String?>((ref) {
  ref.watch(seiWalletServiceProvider);
  return _walletServiceInstance.connectedAddress;
});

/// Provider para la dirección corta de la wallet
final shortWalletAddressProvider = Provider<String?>((ref) {
  ref.watch(seiWalletServiceProvider);
  return _walletServiceInstance.shortAddress;
});

/// Provider para el balance de la wallet
final walletBalanceProvider = Provider<String>((ref) {
  ref.watch(seiWalletServiceProvider);
  return _walletServiceInstance.balanceInSei;
});
