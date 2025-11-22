import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web3/flutter_web3.dart' as web3_provider;

/// Servicio para gestionar la conexión a wallets en Sei Network
class SeiWalletService extends ChangeNotifier {
  // Configuración de Sei Network
  static const String seiTestnetRpc = 'https://evm-rpc-testnet.sei-apis.com';
  static const String seiMainnetRpc = 'https://evm-rpc.sei-apis.com';
  static const int seiTestnetChainId = 1328;
  static const int seiMainnetChainId = 1329;

  // Estado del servicio
  Web3Client? _web3Client;
  String? _connectedAddress;
  EtherAmount? _balance;
  bool _isConnected = false;
  bool _isTestnet = true; // Por defecto usar testnet

  // Getters
  String? get connectedAddress => _connectedAddress;
  String? get shortAddress => _connectedAddress != null
      ? '${_connectedAddress!.substring(0, 6)}...${_connectedAddress!.substring(_connectedAddress!.length - 4)}'
      : null;
  EtherAmount? get balance => _balance;
  String get balanceInSei => _balance != null
      ? '${_balance!.getValueInUnit(EtherUnit.ether).toStringAsFixed(4)} SEI'
      : '0.0000 SEI';
  bool get isConnected => _isConnected;
  Web3Client? get web3Client => _web3Client;
  bool get isTestnet => _isTestnet;
  String get currentRpc => _isTestnet ? seiTestnetRpc : seiMainnetRpc;
  int get currentChainId => _isTestnet ? seiTestnetChainId : seiMainnetChainId;

  SeiWalletService() {
    _initialize();
  }

  /// Inicializa el servicio y restaura la sesión si existe
  Future<void> _initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAddress = prefs.getString('sei_wallet_address');
      final savedTestnet = prefs.getBool('sei_is_testnet') ?? true;

      _isTestnet = savedTestnet;
      _web3Client = Web3Client(currentRpc, http.Client());

      if (savedAddress != null && savedAddress.isNotEmpty) {
        _connectedAddress = savedAddress;
        _isConnected = true;
        await _updateBalance();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error inicializando SeiWalletService: $e');
    }
  }

  /// Conecta la wallet usando MetaMask u otra wallet Web3
  Future<bool> connectWallet() async {
    try {
      if (kIsWeb) {
        // Para Web: usar flutter_web3
        if (!web3_provider.Ethereum.isSupported) {
          throw Exception(
              'MetaMask no está instalado. Por favor instala MetaMask para continuar.');
        }

        final accounts =
            await web3_provider.ethereum!.requestAccount() as List<dynamic>;
        if (accounts.isEmpty) {
          return false;
        }

        _connectedAddress = accounts.first.toString();

        // Verificar/cambiar a la red Sei
        await _switchToSeiNetwork();

        // Guardar en preferencias
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('sei_wallet_address', _connectedAddress!);
        await prefs.setBool('sei_is_testnet', _isTestnet);

        _isConnected = true;
        await _updateBalance();
        notifyListeners();

        return true;
      } else {
        // Para móvil: usar deep linking a wallets móviles
        throw UnimplementedError(
            'La conexión de wallet móvil se implementará con WalletConnect');
      }
    } catch (e) {
      debugPrint('Error conectando wallet: $e');
      return false;
    }
  }

  /// Cambia a la red Sei (o la agrega si no existe)
  Future<void> _switchToSeiNetwork() async {
    if (!kIsWeb) return;

    try {
      // Intentar cambiar a la red
      await web3_provider.ethereum!.walletSwitchChain(currentChainId);
    } catch (e) {
      // Si la red no existe, agregarla
      try {
        final params = {
          'chainId': '0x${currentChainId.toRadixString(16)}',
          'chainName': _isTestnet ? 'Sei Testnet' : 'Sei Network',
          'nativeCurrency': {
            'name': 'SEI',
            'symbol': 'SEI',
            'decimals': 18,
          },
          'rpcUrls': [currentRpc],
          'blockExplorerUrls': [
            _isTestnet ? 'https://seistream.app/' : 'https://seitrace.com/'
          ],
        };

        // Usar ethereum.request directamente
        await web3_provider.ethereum!.request('wallet_addEthereumChain', [params]);
      } catch (addError) {
        debugPrint('Error agregando red Sei: $addError');
        rethrow;
      }
    }
  }

  /// Desconecta la wallet
  Future<void> disconnectWallet() async {
    _connectedAddress = null;
    _balance = null;
    _isConnected = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sei_wallet_address');

    notifyListeners();
  }

  /// Actualiza el balance de la wallet
  Future<void> _updateBalance() async {
    if (_connectedAddress == null || _web3Client == null) return;

    try {
      final address = EthereumAddress.fromHex(_connectedAddress!);
      _balance = await _web3Client!.getBalance(address);
      notifyListeners();
    } catch (e) {
      debugPrint('Error actualizando balance: $e');
    }
  }

  /// Cambia entre testnet y mainnet
  Future<void> toggleNetwork() async {
    _isTestnet = !_isTestnet;
    _web3Client = Web3Client(currentRpc, http.Client());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sei_is_testnet', _isTestnet);

    if (_isConnected) {
      await _switchToSeiNetwork();
      await _updateBalance();
    }

    notifyListeners();
  }

  /// Refresca el balance manualmente
  Future<void> refreshBalance() async {
    await _updateBalance();
  }

  @override
  void dispose() {
    _web3Client?.dispose();
    super.dispose();
  }
}
