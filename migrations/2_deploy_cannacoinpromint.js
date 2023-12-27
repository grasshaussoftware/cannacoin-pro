const CannaCoinProMint = artifacts.require("CannaCoinProMint");

module.exports = function (deployer) {
  const gasLimit = 5000000;

  deployer.deploy(CannaCoinProMint, { gas: gasLimit });
};
