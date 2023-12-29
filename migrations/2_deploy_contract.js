const CannaCoinPro = artifacts.require("CannaCoinPro");

module.exports = function (deployer) {
  // Deploy the CannaCoinPro contract
  deployer.deploy(CannaCoinPro);
};

