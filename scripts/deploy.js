const hre = require("hardhat");

async function main() {
  console.log("🚀 Desplegando AuctionMarketplace en Sei Network...\n");

  // Obtener el signer
  const [deployer] = await hre.ethers.getSigners();

  console.log("📝 Desplegando con la cuenta:", deployer.address);
  console.log("💰 Balance de la cuenta:", hre.ethers.formatEther(await hre.ethers.provider.getBalance(deployer.address)), "SEI\n");

  // Desplegar el contrato
  const AuctionMarketplace = await hre.ethers.getContractFactory("AuctionMarketplace");
  console.log("⏳ Desplegando contrato...");

  const auctionMarketplace = await AuctionMarketplace.deploy();
  await auctionMarketplace.waitForDeployment();

  const contractAddress = await auctionMarketplace.getAddress();

  console.log("\n✅ AuctionMarketplace desplegado exitosamente!");
  console.log("📍 Dirección del contrato:", contractAddress);

  // Información de red
  const network = await hre.ethers.provider.getNetwork();
  console.log("🌐 Red:", network.name);
  console.log("🔗 Chain ID:", network.chainId.toString());

  // Explorer URL
  let explorerUrl = "";
  if (network.chainId === 1328n) {
    explorerUrl = `https://seistream.app/address/${contractAddress}`;
  } else if (network.chainId === 1329n) {
    explorerUrl = `https://seitrace.com/address/${contractAddress}`;
  }

  if (explorerUrl) {
    console.log("🔍 Ver en Explorer:", explorerUrl);
  }

  console.log("\n📋 PRÓXIMOS PASOS:");
  console.log("1. Actualiza la dirección del contrato en auction_service.dart:");
  console.log(`   static const String contractAddress = '${contractAddress}';`);
  console.log("\n2. Copia el ABI a Flutter:");
  console.log("   cp artifacts/contracts/AuctionMarketplace.sol/AuctionMarketplace.json assets/contracts/");
  console.log("\n3. Verifica el contrato (opcional):");
  console.log(`   npx hardhat verify --network ${network.name === 'seiTestnet' ? 'seiTestnet' : 'seiMainnet'} ${contractAddress}`);

  // Guardar deployment info
  const fs = require('fs');
  const deploymentInfo = {
    network: network.name,
    chainId: network.chainId.toString(),
    contractAddress: contractAddress,
    deployer: deployer.address,
    timestamp: new Date().toISOString(),
    explorerUrl: explorerUrl
  };

  fs.writeFileSync(
    `deployment-${network.name}-${Date.now()}.json`,
    JSON.stringify(deploymentInfo, null, 2)
  );

  console.log("\n💾 Información guardada en deployment-*.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Error durante el deployment:");
    console.error(error);
    process.exit(1);
  });
