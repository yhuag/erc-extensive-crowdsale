pragma solidity ^0.4.21;


import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";


// Allow buying oldToken (tokens for sale) with newToken
contract ExtensiveCrowdsale is Crowdsale, Ownable {
    
    // The initial newToken address
    ERC20 public newToken = ERC20(0x0);
    
    // Hardcoded setup data
    address wallet = 0x5ff2c17ada131e5D9fa0f927395Abe35657e4768;
    address tokenAddress = 0x426d21246eF37ECdCb012E4B9427a78F9285dFEb;
    uint256 rate = 100;
    
    // !!! Please be reminded that the constructor has changed _token to _tokenAddress for testing purpose
    function ExtensiveCrowdsale() public Crowdsale(rate, wallet, ERC20(tokenAddress)) {}
    
    
    // Add new ERC20 token as payment method
    function setToken(address _tokenAddress) public onlyOwner {
        newToken = ERC20(_tokenAddress);
    }
    
    // Get balance of the caller in terms of the nweToken
    function getNewBalance() public view returns (uint) {
        return newToken.balanceOf(this);
    }
    
    // Get balance of old tokens in contarct
    function getOldBalance() public view returns (uint) {
        return token.balanceOf(this);
    }
    
    // Sell out old token
    function _deliverOldTokensToBuyer(uint256 _tokenAmount) internal {
        token.transfer(msg.sender, _tokenAmount);
    }
    
    // Receive new token (need to Approve from the newToken by user first)
    function _receiveNewTokensFromBuyer(uint256 _tokenAmount) internal {
        newToken.transferFrom(msg.sender, this, _tokenAmount);
    }
    
    // Buy token with newToken
    function buyTokensWithNewToken(uint256 _amount) public {

        // _preValidatePurchase(_beneficiary, _newTokenAmount);
    
        // calculate token amount to be created
        // uint256 oldTokenAmount = _getTokenAmount(_newTokenAmount);
    
        // update state
        // weiRaised = weiRaised.add(_newTokenAmount);
    
        // Give out old token
        _deliverOldTokensToBuyer(_amount);
    
        // Receive new token 
        _receiveNewTokensFromBuyer(_amount);
    }
    
    
}