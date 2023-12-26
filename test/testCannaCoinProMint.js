const CannaCoinProMint = artifacts.require("CannaCoinProMint");

contract("CannaCoinProMint", (accounts) => {
  let token;

  before(async () => {
    token = await CannaCoinProMint.deployed();
  });

  it("should mint the initial supply to the owner", async () => {
    const owner = accounts[0];
    const initialSupply = await token.INITIAL_SUPPLY();
    const ownerBalance = await token.balanceOf(owner);
    assert.equal(ownerBalance.toString(), initialSupply.toString(), "Initial supply was not minted to the owner");
  });

  it("should set the correct owner", async () => {
    const owner = accounts[0];
    const contractOwner = await token.owner();
    assert.equal(contractOwner, owner, "Owner is not correctly set");
  });

  // Additional tests can be added here
});
