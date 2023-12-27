const CannaCoinProFees = artifacts.require("CannaCoinProFees");

module.exports = function (deployer) {
  const gasLimit = 5000000;

  deployer.deploy(CannaCoinProFees, { gas: gasLimit });
};
