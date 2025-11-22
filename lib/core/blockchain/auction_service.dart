import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'sei_wallet_service.dart';

/// Servicio para interactuar con el smart contract de subastas
class AuctionService {
  final SeiWalletService _walletService;
  DeployedContract? _contract;

  // Dirección del contrato desplegado (actualizar después del deployment)
  // TESTNET: Actualizar esta dirección después de desplegar el contrato
  static const String contractAddress = '0xcd91dab1Aa03f454DB569758763683C90Cd3865D';

  AuctionService(this._walletService) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Cargar el ABI del contrato
      final abiString = await rootBundle.loadString('assets/contracts/AuctionMarketplace.json');
      final contractAbi = ContractAbi.fromJson(abiString, 'AuctionMarketplace');

      final address = EthereumAddress.fromHex(contractAddress);
      _contract = DeployedContract(contractAbi, address);
    } catch (e) {
      debugPrint('Error inicializando AuctionService: $e');
    }
  }

  /// Crea una nueva subasta
  ///
  /// [itemId] ID del item a subastar
  /// [durationInHours] Duración de la subasta en horas
  Future<String?> createAuction(String itemId, int durationInHours) async {
    if (_contract == null || _walletService.web3Client == null) {
      throw Exception('Service not initialized');
    }

    if (!_walletService.isConnected || _walletService.connectedAddress == null) {
      throw Exception('Wallet not connected');
    }

    try {
      // final function = _contract!.function('createAuction');
      // final durationInSeconds = durationInHours * 3600;

      // Para web, usar flutter_web3
      if (kIsWeb) {
        // TODO: Implementar usando ethereum.request
        throw UnimplementedError('Web implementation pending - itemId: $itemId, duration: ${durationInHours}h');
      } else {
        // Para móvil (cuando implementemos WalletConnect)
        throw UnimplementedError('Mobile implementation pending');
      }
    } catch (e) {
      debugPrint('Error creando subasta: $e');
      rethrow;
    }
  }

  /// Realiza una oferta en una subasta
  ///
  /// [auctionId] ID de la subasta
  /// [bidAmount] Cantidad a ofertar en SEI
  Future<String?> placeBid(int auctionId, double bidAmount) async {
    if (_contract == null || _walletService.web3Client == null) {
      throw Exception('Service not initialized');
    }

    if (!_walletService.isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      // final function = _contract!.function('placeBid');
      // final amountInWei = EtherAmount.fromInt(
      //   EtherUnit.wei,
      //   BigInt.from((bidAmount * 1e18).toInt()),
      // );

      // Para web, usar flutter_web3
      if (kIsWeb) {
        // TODO: Implementar usando ethereum.request
        throw UnimplementedError('Web implementation pending - auctionId: $auctionId, bid: $bidAmount SEI');
      } else {
        // Para móvil
        throw UnimplementedError('Mobile implementation pending');
      }
    } catch (e) {
      debugPrint('Error realizando oferta: $e');
      rethrow;
    }
  }

  /// Finaliza una subasta
  ///
  /// [auctionId] ID de la subasta a finalizar
  Future<String?> endAuction(int auctionId) async {
    if (_contract == null || _walletService.web3Client == null) {
      throw Exception('Service not initialized');
    }

    if (!_walletService.isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      // final function = _contract!.function('endAuction');

      if (kIsWeb) {
        throw UnimplementedError('Web implementation pending - auctionId: $auctionId');
      } else {
        throw UnimplementedError('Mobile implementation pending');
      }
    } catch (e) {
      debugPrint('Error finalizando subasta: $e');
      rethrow;
    }
  }

  /// Obtiene información de una subasta
  ///
  /// [auctionId] ID de la subasta
  Future<AuctionInfo?> getAuction(int auctionId) async {
    if (_contract == null || _walletService.web3Client == null) {
      return null;
    }

    try {
      final function = _contract!.function('getAuction');
      final result = await _walletService.web3Client!.call(
        contract: _contract!,
        function: function,
        params: [BigInt.from(auctionId)],
      );

      return AuctionInfo.fromContractResult(result);
    } catch (e) {
      debugPrint('Error obteniendo subasta: $e');
      return null;
    }
  }

  /// Verifica si una subasta está activa
  ///
  /// [auctionId] ID de la subasta
  Future<bool> isAuctionActive(int auctionId) async {
    if (_contract == null || _walletService.web3Client == null) {
      return false;
    }

    try {
      final function = _contract!.function('isAuctionActive');
      final result = await _walletService.web3Client!.call(
        contract: _contract!,
        function: function,
        params: [BigInt.from(auctionId)],
      );

      return result.first as bool;
    } catch (e) {
      debugPrint('Error verificando estado de subasta: $e');
      return false;
    }
  }

  /// Obtiene todas las ofertas de una subasta
  ///
  /// [auctionId] ID de la subasta
  Future<List<BidInfo>> getAuctionBids(int auctionId) async {
    if (_contract == null || _walletService.web3Client == null) {
      return [];
    }

    try {
      final function = _contract!.function('getAuctionBids');
      final result = await _walletService.web3Client!.call(
        contract: _contract!,
        function: function,
        params: [BigInt.from(auctionId)],
      );

      final bidsData = result.first as List;
      return bidsData.map((bid) => BidInfo.fromContractResult(bid)).toList();
    } catch (e) {
      debugPrint('Error obteniendo ofertas: $e');
      return [];
    }
  }

  /// Retira fondos de ofertas superadas
  ///
  /// [auctionId] ID de la subasta
  Future<String?> withdraw(int auctionId) async {
    if (_contract == null || _walletService.web3Client == null) {
      throw Exception('Service not initialized');
    }

    if (!_walletService.isConnected) {
      throw Exception('Wallet not connected');
    }

    try {
      // final function = _contract!.function('withdraw');

      if (kIsWeb) {
        throw UnimplementedError('Web implementation pending - auctionId: $auctionId');
      } else {
        throw UnimplementedError('Mobile implementation pending');
      }
    } catch (e) {
      debugPrint('Error retirando fondos: $e');
      rethrow;
    }
  }
}

/// Información de una subasta
class AuctionInfo {
  final int auctionId;
  final String seller;
  final String itemId;
  final DateTime startTime;
  final DateTime endTime;
  final double highestBid;
  final String? highestBidder;
  final bool ended;
  final bool cancelled;

  AuctionInfo({
    required this.auctionId,
    required this.seller,
    required this.itemId,
    required this.startTime,
    required this.endTime,
    required this.highestBid,
    this.highestBidder,
    required this.ended,
    required this.cancelled,
  });

  factory AuctionInfo.fromContractResult(List<dynamic> result) {
    return AuctionInfo(
      auctionId: (result[0] as BigInt).toInt(),
      seller: (result[1] as EthereumAddress).hex,
      itemId: result[2] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(
        (result[3] as BigInt).toInt() * 1000,
      ),
      endTime: DateTime.fromMillisecondsSinceEpoch(
        (result[4] as BigInt).toInt() * 1000,
      ),
      highestBid: (result[5] as BigInt).toDouble() / 1e18,
      highestBidder: (result[6] as EthereumAddress).hex != '0x0000000000000000000000000000000000000000'
          ? (result[6] as EthereumAddress).hex
          : null,
      ended: result[7] as bool,
      cancelled: result[8] as bool,
    );
  }

  bool get isActive => !ended && !cancelled && DateTime.now().isBefore(endTime);

  Duration get remainingTime => endTime.difference(DateTime.now());
}

/// Información de una oferta
class BidInfo {
  final String bidder;
  final double amount;
  final DateTime timestamp;

  BidInfo({
    required this.bidder,
    required this.amount,
    required this.timestamp,
  });

  factory BidInfo.fromContractResult(List<dynamic> result) {
    return BidInfo(
      bidder: (result[0] as EthereumAddress).hex,
      amount: (result[1] as BigInt).toDouble() / 1e18,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (result[2] as BigInt).toInt() * 1000,
      ),
    );
  }
}
