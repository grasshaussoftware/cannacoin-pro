// transfer.test.js
const CannaCoinPro = artifacts.require("CannaCoinPro");

contract("CannaCoinPro", (accounts) => {
  it("should transfer tokens correctly with fees", async () => {
    const instance = await CannaCoinPro.deployed();
    const sender = accounts[1];
    const recipient = accounts[2];

    // Transfer tokens from sender to recipient
    const amountToSend = web3.utils.toWei("1000", "ether");
    await instance.transfer(recipient, amountToSend, { from: sender });

    // Check sender's balance after the transfer
    const senderBalance = await instance.balanceOf(sender);
    assert.equal(senderBalance.toString(), "999999999999999999999000", "Sender's balance should be reduced by 1000 CPRO");

    // Check recipient's balance after the transfer
    const recipientBalance = await instance.balanceOf(recipient);
    assert.equal(recipientBalance.toString(), "1000000000000000000", "Recipient should receive 1000 CPRO");

    // Check pool's balance for the fee
    const poolBalance = await instance.balanceOf("0x3536b0152c91E60535508690a650C10bf09fe857");
    assert.equal(poolBalance.toString(), "1000000000000000000", "Pool should receive 1 CPRO as a fee");
  });
});
