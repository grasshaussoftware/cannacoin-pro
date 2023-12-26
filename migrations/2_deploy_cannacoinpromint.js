const CannaCoinProMint = artifacts.require("CannaCoinProMint");

module.exports = function (deployer) {
    deployer.deploy(CannaCoinProMint);
};

