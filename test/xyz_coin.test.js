const XYZCoin = artifacts.require("XYZCoin");
const truffleAssert = require("truffle-assertions");

contract("XYZCoin", accounts => {
  const [creator, alice, bob, outsider] = accounts;
  let coin;
  beforeEach(async () => { coin = await XYZCoin.new({ from: creator }); });

  it("sets the correct name, symbol, decimals and supply", async () => {
    assert.equal(await coin.name(), "XYZCoin");
    assert.equal(await coin.symbol(), "XYZ");
    assert.equal((await coin.decimals()).toString(), "0");
    assert.equal((await coin.totalSupply()).toString(), "1000");
  });
  it("assigns the entire supply to creator", async () => {
    assert.equal((await coin.balanceOf(creator)).toString(), "1000");
  });
  it("transfers tokens and emits Transfer, including zero value", async () => {
    let tx = await coin.transfer(alice, 50, { from: creator });
    assert.equal((await coin.balanceOf(alice)).toString(), "50");
    assert.equal((await coin.balanceOf(creator)).toString(), "950");
    truffleAssert.eventEmitted(tx, "Transfer", e => e.from === creator && e.to === alice && e.value.toString() === "50");
    tx = await coin.transfer(alice, 0, { from: creator });
    truffleAssert.eventEmitted(tx, "Transfer", e => e.value.toString() === "0");
  });
  it("sets and reads allowances and emits Approval", async () => {
    const tx = await coin.approve(bob, 80, { from: creator });
    assert.equal((await coin.allowance(creator, bob)).toString(), "80");
    truffleAssert.eventEmitted(tx, "Approval", e => e.owner === creator && e.spender === bob && e.value.toString() === "80");
  });
  it("allows approved delegated transfer, including zero", async () => {
    await coin.approve(bob, 80, { from: creator });
    let tx = await coin.transferFrom(creator, alice, 25, { from: bob });
    assert.equal((await coin.balanceOf(alice)).toString(), "25");
    assert.equal((await coin.allowance(creator, bob)).toString(), "55");
    truffleAssert.eventEmitted(tx, "Transfer", e => e.value.toString() === "25");
    tx = await coin.transferFrom(creator, alice, 0, { from: bob });
    truffleAssert.eventEmitted(tx, "Transfer", e => e.value.toString() === "0");
  });
  it("rejects transfers with insufficient balance", async () => {
    await truffleAssert.reverts(coin.transfer(alice, 1001, { from: creator }), "Insufficient balance");
  });
  it("rejects transfers without sufficient approval", async () => {
    await truffleAssert.reverts(coin.transferFrom(creator, alice, 1, { from: outsider }), "Not authorized");
  });
  it("rejects delegated transfers exceeding the approved allowance", async () => {
    await coin.approve(bob, 3, { from: creator });
    await truffleAssert.reverts(coin.transferFrom(creator, alice, 4, { from: bob }), "Not authorized");
  });
});
