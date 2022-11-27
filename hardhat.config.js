require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [    //可指定多个sol版本
      {version: "0.8.9"},
      {version: "0.8.0"},
      {version: "0.6.10"}
    ],
    // overrides: {
    //   "contracts/erc20/Simple20Bank.sol": {
    //     version: "0.6.10",
    //     settings: {}
    //   },
    //   "contracts/erc20/Simple20Token.sol": {
    //     version: "0.8.0",
    //     settings: {}
    //   }
    // },
  },
  defaultNetwork: "hardhat",
};
