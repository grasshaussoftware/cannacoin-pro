const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');

// Replace the values below with your own Infura key and mnemonic
const infuraKey = "YOUR_INFURA_KEY";
const mnemonicPath = ".secret"; // Path to file containing mnemonic
let mnemonic;
if (fs.existsSync(mnemonicPath)) {
    mnemonic = fs.readFileSync(mnemonicPath, {encoding:'utf8', flag:'r'}).trim();
} else {
    console.error("Mnemonic file not found");
}

module.exports = {
  networks: {
    // Local development network configuration (e.g., Ganache)
    development: {
      host: "127.0.0.1",
      port: 7545, // This is the default port for Ganache GUI; change if needed
      network_id: "*" // Any network ID
    },

    // Ropsten test network configuration
    ropsten: {
      provider: () => new HDWalletProvider({
        mnemonic: {
          phrase: mnemonic
        },
        providerOrUrl: `https://ropsten.infura.io/v3/${infuraKey}`
      }),
      network_id: 3,       // Ropsten's network id
      gas: 5500000,        // Gas limit used for deploys
      confirmations: 2,    // # of confs to wait between deployments
      timeoutBlocks: 200,  // # of blocks before a deployment times out
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets)
    },

    // Additional network configurations go here
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.23",  // Fetch exact version from solc-bin
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: false,
          runs: 200
        },
      }
    }
  },

  // Truffle DB is enabled by default to store network artifacts
  db: {
    enabled: false
  }
};
