const CannaCoinProMint = artifacts.require("CannaCoinProMint");

module.exports = function (deployer, network, accounts) {
  // Deploy the CannaCoinProMint contract
  // Assuming accounts[0] will be the owner of the CannaCoinProMint contract
  deployer.deploy(CannaCoinProMint, accounts[0]);
};
