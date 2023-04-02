const HDWalletProvider = require('@truffle/hdwallet-provider');
const mnemonic = 'grace velvet armed never glimpse pigeon sort soup core disease pole carbon';

module.exports = {

  networks: {

     development: {
       provider: function() {
         return new HDWalletProvider(mnemonic, 'http://127.0.0.1:7545');
       },
       network_id: 5777
     },

     rinkeby: {
       provider: function() {
         return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/<your-project-id>');
       },
       network_id: 4
     },

     mainnet: {
       provider: function() {
         return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/v3/<your-project-id>');
       },
       network_id: 1,
       gasPrice: 5000000000 // 5 gwei
     }

  },

  compilers: {
    solc: {
      version: "0.8.17"
    }
  }
};