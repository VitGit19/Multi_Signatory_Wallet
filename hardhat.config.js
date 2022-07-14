require("@nomicfoundation/hardhat-toolbox");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
};
require("dotenv").config();
 
 module.exports = {
   solidity: "0.8.9",
   networks: {
     rinkeby: {
       // This value will be replaced on runtime
       url: process.env.STAGING_ALCHEMY_KEY,
       accounts: [process.env.PRIVATE_KEY],
     },
     
   },

   mocha: {
    timeout: 100000000
  },
 };