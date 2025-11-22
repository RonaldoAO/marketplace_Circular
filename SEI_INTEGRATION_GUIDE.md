# Guía de Integración de Sei Network

Esta guía te ayudará a completar la integración de Sei blockchain en tu marketplace de subastas.

## Estado Actual de la Integración

### ✅ Completado

1. **Dependencias Instaladas**
   - `web3dart`: Librería para interactuar con blockchains EVM
   - `flutter_web3`: Para conectar wallets en Web
   - `url_launcher`: Para deep links a wallets móviles
   - `shared_preferences`: Para persistir la sesión de wallet

2. **Servicios Creados**
   - `SeiWalletService`: Gestión de conexión de wallet
   - `AuctionService`: Interacción con smart contracts
   - Providers de Riverpod para estado global

3. **UI Implementada**
   - Tarjeta de conexión de wallet en MenuPage
   - Muestra dirección y balance
   - Opciones de cambiar red y desconectar

4. **Smart Contract**
   - `AuctionMarketplace.sol`: Contrato de subastas completo
   - Funciones: crear subasta, ofertar, finalizar, retirar fondos

## Próximos Pasos

### 1. Compilar y Desplegar el Smart Contract

#### Instalación de Herramientas

```bash
# Instalar Node.js y npm (si no lo tienes)
# Luego instalar Hardhat
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
```

#### Crear proyecto Hardhat

```bash
# En la raíz del proyecto marketplace
npx hardhat init
```

#### Configurar Hardhat para Sei

Edita `hardhat.config.js`:

```javascript
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    seiTestnet: {
      url: "https://evm-rpc-testnet.sei-apis.com",
      chainId: 1328,
      accounts: [process.env.PRIVATE_KEY] // Tu clave privada
    },
    seiMainnet: {
      url: "https://evm-rpc.sei-apis.com",
      chainId: 1329,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
```

#### Crear archivo .env

```bash
PRIVATE_KEY=tu_clave_privada_aqui
```

⚠️ **IMPORTANTE**: Nunca compartas tu clave privada y agrégala al .gitignore

#### Script de Deploy

Crea `scripts/deploy.js`:

```javascript
async function main() {
  const AuctionMarketplace = await ethers.getContractFactory("AuctionMarketplace");
  const auction = await AuctionMarketplace.deploy();
  await auction.deployed();

  console.log("AuctionMarketplace desplegado en:", auction.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

#### Desplegar

```bash
# Desplegar en testnet
npx hardhat run scripts/deploy.js --network seiTestnet

# La salida mostrará la dirección del contrato, por ejemplo:
# AuctionMarketplace desplegado en: 0x1234567890abcdef...
```

#### Actualizar la dirección del contrato

Después del deploy, actualiza la constante `contractAddress` en `lib/core/blockchain/auction_service.dart`:

```dart
static const String contractAddress = '0xTU_DIRECCION_DEL_CONTRATO_AQUI';
```

### 2. Generar ABI del Contrato

```bash
# Después de compilar el contrato
npx hardhat compile

# Copiar el ABI
cp artifacts/contracts/AuctionMarketplace.sol/AuctionMarketplace.json lib/assets/contracts/
```

Actualiza `pubspec.yaml` para incluir el asset:

```yaml
flutter:
  assets:
    - assets/contracts/AuctionMarketplace.json
```

### 3. Configurar Permisos

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 4. Obtener SEI de Testnet

Para probar las subastas, necesitas SEI de testnet:

1. Ve al faucet de Sei Testnet: https://faucet.sei.io/
2. Conecta tu wallet (MetaMask)
3. Asegúrate de estar en Sei Testnet (Chain ID: 1328)
4. Solicita tokens SEI

### 5. Integrar Ofertas en Product Detail Page

Ya está preparado el servicio, ahora solo necesitas integrarlo en la UI. Aquí hay un ejemplo de cómo usarlo:

```dart
// En product_detail_page.dart
final auctionService = AuctionService(ref.read(seiWalletServiceProvider));

// Crear subasta
await auctionService.createAuction(listing.id, 72); // 72 horas

// Realizar oferta
await auctionService.placeBid(auctionId, bidAmount);

// Ver información de subasta
final auctionInfo = await auctionService.getAuction(auctionId);
```

### 6. Testing

1. **Test en Web (Más fácil para empezar)**
   - Instala MetaMask
   - Agrega Sei Testnet manualmente o deja que la app lo haga
   - Conecta tu wallet
   - Prueba crear subastas y ofertar

2. **Test en Móvil**
   - Requiere implementar WalletConnect
   - Instala una wallet móvil compatible (MetaMask Mobile, Trust Wallet)

## Recursos Útiles

### Documentación Oficial
- Sei Docs: https://docs.sei.io/
- Sei EVM: https://docs.sei.io/dev-ecosystem-providers/evm-general
- Sei Explorer Testnet: https://seistream.app/
- Sei Explorer Mainnet: https://seitrace.com/

### Faucets y Herramientas
- Faucet Testnet: https://faucet.sei.io/
- RPC Testnet: https://evm-rpc-testnet.sei-apis.com
- RPC Mainnet: https://evm-rpc.sei-apis.com

### Smart Contract Testing
- Hardhat: https://hardhat.org/
- Remix IDE (alternativa): https://remix.ethereum.org/

## Mejoras Futuras

### Funcionalidades Adicionales
1. **Subastas con precio de reserva**: Precio mínimo para vender
2. **Extensión automática**: Si hay oferta en últimos minutos, extender tiempo
3. **Historial de subastas**: Ver subastas pasadas del usuario
4. **Notificaciones on-chain**: Eventos de nuevas ofertas
5. **Integración con IPFS**: Almacenar metadata de productos
6. **Escrow automático**: Bloquear producto hasta pago confirmado

### Optimizaciones
1. **Batching de transacciones**: Agrupar múltiples acciones
2. **Gas optimization**: Optimizar uso de gas en smart contract
3. **Caching de datos**: Reducir llamadas RPC
4. **Indexing con The Graph**: Consultar datos históricos eficientemente

## Troubleshooting

### Error: "MetaMask no está instalado"
- Instala la extensión de MetaMask en tu navegador
- Para móvil, implementa WalletConnect

### Error: "Wrong network"
- Asegúrate de estar conectado a Sei Testnet (Chain ID: 1328)
- La app debería cambiar automáticamente la red

### Transacción falla
- Verifica que tienes suficiente SEI para gas
- Confirma que los parámetros son correctos
- Revisa los logs en el explorer de Sei

### Balance no actualiza
- Presiona el botón de refresh en la wallet card
- Verifica tu conexión a internet
- Confirma que estás en la red correcta

## Soporte

Para más ayuda:
- Discord de Sei: https://discord.gg/sei
- GitHub Issues del proyecto
- Documentación de web3dart: https://pub.dev/packages/web3dart

---

**¡Feliz desarrollo en Sei Network! 🚀**
