# ERC20 Extensive Crowdsale Smart Contract
## Upfront setup
1. Create **two** [StandardTokens](https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol) or any ERC20 compatible tokens (one is for sale, the other is for buying the sale)
2. Instantiate an `ExtensiveCrowdsale` smart contract with an ERC20 token and other configurations
3. Call `setExToken()` to hook up the exToken (exchangeable Token)
4. Transfer some **token-for-sale** from wallet or the user to the contract as initial sale cap
## Buy ERC20 with another ERC20
1. Call `approve()` on the ExToken as the same amount of buying
2. Call `buyTokensWithExToken()` to buy the tokens!!!