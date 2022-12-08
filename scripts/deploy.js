// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
 const [deployer] = await ethers.getSigners();
 const balance = await deployer.getBalance();
 const Marketplace = await hre.ethers.getContractFactory("NFTMarketplace");
 const marketplace = await Marketplace.deploy();
 await marketplace.deployed();
 console.log("Marketplace deployed to:", marketplace.address);
//  const data = {
//   address: marketplace.address,
//   abi: JSON
//  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
