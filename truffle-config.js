require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

const ganacheMnemonic = process.env.GANACHE_MNEMONIC;
const avalancheMnemonic = process.env.AVALANCHE_MNEMONIC;

module.exports = {
  networks: {
    development: {
      host: "10.0.0.10",
      port: 8545, // Default port for Ganache
      network_id: "*", // Match any network
      provider: () => new HDWalletProvider(ganacheMnemonic, "http://10.0.0.10:3000")
    },
    avalanche: {
      provider: () => new HDWalletProvider(avalancheMnemonic, "https://api.avax.network/ext/bc/C/rpc"),
      network_id: 43114, // Avalanche C-Chain's network id
      gas: 3000000, // Standard gas limit
      gasPrice: 250000000000, // Average gas price in wei (250 Gwei)
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true // Set to false for a dry run
    },
    // Additional network configurations go here
  },

  compilers: {
    solc: {
      version: "^0.8.23", //
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  },

  db: {
    enabled: false
  }
};
