// hardhat.config.js

require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.27"
      },
      {
        version: "0.8.20"
      }
    ]
  },
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
      accounts: ["0x883ab16485d303b64b35d58a04b0d2e0652c472f8d31d8eda426a8346083434b"]
    }
  }
};
