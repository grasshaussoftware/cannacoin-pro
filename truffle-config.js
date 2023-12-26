require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

// Retrieve the mnemonic from the .env file
const { MNEMONIC } = process.env;

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545, // This is the default port for Ganache; change it if you use a different port
      network_id: "*", // Match any network
    },
    avalanche: {
      provider: () => new HDWalletProvider({
        mnemonic: {
          phrase: MNEMONIC
        },
        providerOrUrl: "https://api.avax.network/ext/bc/C/rpc" // Avalanche C-Chain RPC URL
      }),
      network_id: 43114, // Avalanche C-Chain's network id
      gas: 3000000, // Adjust the gas limit as needed
      gasPrice: 225000000000, // Adjust the gas price as needed (in wei)
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true // Set to false if you want to do a dry run
    },
    // Additional network configurations go here
  },

  compilers: {
    solc: {
      version: "0.8.23", // Use the same version as your contracts
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
