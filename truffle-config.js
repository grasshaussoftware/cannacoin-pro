require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

const ganacheMnemonic = process.env.GANACHE_MNEMONIC;
const avalancheMnemonic = process.env.AVAX_MNEMONIC;
const infuraUrl = "https://avalanche-mainnet.infura.io/v3/6f128516655a48ffac7b7656f8ca9f0f"; 

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      provider: () => new HDWalletProvider({ mnemonic: ganacheMnemonic, providerOrUrl: "http://127.0.0.1:8545" }),
    },
    avalanche: {
      provider: () => new HDWalletProvider({ mnemonic: avalancheMnemonic, providerOrUrl: infuraUrl }),
      network_id: 43114,
      gas: 5000000,
      gasPrice: 250000000000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
    // Add more networks here if needed
  },

  compilers: {
    solc: {
      version: "0.8.23",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },

  db: {
    enabled: false,
  },
};
