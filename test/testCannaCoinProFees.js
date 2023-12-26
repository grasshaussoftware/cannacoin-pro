const CannaCoinProFees = artifacts.require("CannaCoinProFees");

contract("CannaCoinProFees", (accounts) => {
  let token;

  before(async () => {
    token = await CannaCoinProFees.deployed();
  });

  it("should correctly transfer tokens with fee", async () => {
    const sender = accounts[0];
    const receiver = accounts[1];
    const amount = web3.utils.toBN(1000);
    const fee = amount.mul(web3.utils.toBN(42)).div(web3.utils.toBN(1000));
    const expectedReceiverBalance = amount.sub(fee);

    await token.transfer(receiver, amount, { from: sender });
    const receiverBalance = await token.balanceOf(receiver);
    
    assert.equal(receiverBalance.toString(), expectedReceiverBalance.toString(), "Receiver balance is incorrect after transfer with fee");
  });

  // Additional tests can be added here
});
