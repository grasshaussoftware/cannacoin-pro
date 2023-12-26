const CannaCoinProFees = artifacts.require("CannaCoinProFees");

module.exports = function (deployer) {
  // Deploy the CannaCoinProFees contract
  deployer.deploy(CannaCoinProFees);
};
