const CannaCoinPro = artifacts.require("CannaCoinPro");

contract("CannaCoinPro", accounts => {
    const [deployer, pool, user1] = accounts;
    let cannaCoinPro;

    before(async () => {
        cannaCoinPro = await CannaCoinPro.deployed();
    });

    it("should assign the total supply of tokens to the pool", async () => {
        const poolBalance = await cannaCoinPro.balanceOf(pool);
        const totalSupply = await cannaCoinPro.totalSupply();
        assert(poolBalance.toString() === totalSupply.toString(), "Pool balance should be equal to total supply");
    });

    it("should lock the correct amount of tokens for the deployer", async () => {
        const lockedBalance = await cannaCoinPro.lockedBalanceOf(deployer);
        assert(lockedBalance.toString() === web3.utils.toWei("1000000", "ether"), "Incorrect amount of locked tokens for deployer");
    });

    it("should not allow transfer of locked tokens", async () => {
        try {
            await cannaCoinPro.transfer(user1, web3.utils.toWei("1000000", "ether"), { from: deployer });
            assert.fail("Should not allow transfer of locked tokens");
        } catch (error) {
            assert(error.message.includes("transfer amount exceeds unlocked balance"), "Error should be related to locked balance");
        }
    });

    // Add more tests as needed...
});

