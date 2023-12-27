// constructor.test.js
const CannaCoinPro = artifacts.require("CannaCoinPro");

contract("CannaCoinPro", (accounts) => {
  it("should deploy the contract with correct initial values", async () => {
    const instance = await CannaCoinPro.deployed();

    const totalSupply = await instance.TOTAL_SUPPLY();
    assert.equal(totalSupply.toString(), "100000000000000000000000000", "Total supply should be 100,000,000 CPRO");

    const deployerBalance = await instance.balanceOf(accounts[0]);
    assert.equal(deployerBalance.toString(), "1000000000000000000000000", "Deployer should have 1,000,000 CPRO");

    const poolBalance = await instance.balanceOf("0x3536b0152c91E60535508690a650C10bf09fe857");
    assert.equal(poolBalance.toString(), "99000000000000000000000000", "Pool should have 99,000,000 CPRO");
  });
});
