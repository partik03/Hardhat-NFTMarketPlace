require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config()
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337,
    },
    goerli:{
      url: process.env.GOERLI_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    polygon:{
      url: process.env.POLYGON_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
