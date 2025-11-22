require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    // Sei Testnet (Arctic-1)
    seiTestnet: {
      url: "https://evm-rpc-testnet.sei-apis.com",
      chainId: 1328,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      gasPrice: 'auto',
    },
    // Sei Mainnet
    seiMainnet: {
      url: "https://evm-rpc.sei-apis.com",
      chainId: 1329,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      gasPrice: 'auto',
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  etherscan: {
    // Opcional: para verificar contratos
    apiKey: {
      seiTestnet: process.env.SEI_EXPLORER_API_KEY || "",
      seiMainnet: process.env.SEI_EXPLORER_API_KEY || "",
    },
    customChains: [
      {
        network: "seiTestnet",
        chainId: 1328,
        urls: {
          apiURL: "https://seistream.app/api",
          browserURL: "https://seistream.app"
        }
      },
      {
        network: "seiMainnet",
        chainId: 1329,
        urls: {
          apiURL: "https://seitrace.com/api",
          browserURL: "https://seitrace.com"
        }
      }
    ]
  }
};
