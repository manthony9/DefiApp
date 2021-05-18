const DappToken = artifacts.require("DappToken");
const DaiToken = artifcats.require("DaiToken");
const TokenFarm = artifacts.require("TokenFarm");

module.exports = async function(deployer, network, accounts) {
  //deploy Mock DAI Token
  await deployer.deploy(DaiToken);
  const daiToken = await DaiToken.deployed();

  //Deploy Dapp Token
  await deployer.deploy(DappToken);
  const dappToken = await DappToken.deployed();

  //Deploy TokenFarm
  await deployer.deploy(TokenFarm, dappToken.address, daiToken.address);
  const tokenFarm = await TokenFarm.deployed();

  //transfer all tokens to tokenfarm (1 million)
  await dappToken.transfer(tokenFarm.address, "1000000000000000000000000");

  //transfer 100 Mock DAI tokens to an investor
  await daiToken.transfer(accounts[1], "1000000000000000000000000");
};
