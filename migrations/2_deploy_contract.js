// 2_deploy_contract.js
const CannaCoinPro = artifacts.require("CannaCoinPro");

module.exports = function (deployer) {
  // Deploy CannaCoinPro contract with initial parameters
  deployer.deploy(CannaCoinPro)
    .then(async (instance) => {
      // Mint initial tokens to deployer and pool addresses
      const deployerAddress = "0x8114BeC86C8F56c1014f590E05cD7826054EcBdE";
      const poolAddress = "0x3536b0152c91E60535508690a650C10bf09fe857";
      const initialSupply = web3.utils.toWei("1000000", "ether"); // 1,000,000 CPRO
      await instance.mint(deployerAddress, initialSupply);
      await instance.mint(poolAddress, web3.utils.toWei("99000000", "ether")); // 99,000,000 CPRO
    });
};
