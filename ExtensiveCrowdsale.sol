pragma solidity ^0.4.21;


import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";


// @title Extensive Crowdsale allows ERC20 tokens as payment methods
// @author Hu Yao-Chieh (Jeff)
// @dev This contract is for demonstration purpose so far. Further efforts are needed to make it generic and secure
contract ExtensiveCrowdsale is Crowdsale, Ownable {
    
    // The initial exToken address
    ERC20 public exToken = ERC20(0x0);
    
    // !!! Please be reminded that the constructor has changed _token to _tokenAddress for testing purpose
    function ExtensiveCrowdsale(
        uint256 _rate,
        address _wallet,
        ERC20 _token
    ) public Crowdsale(_rate, _wallet, _token){}
    
    
    // Set an ERC20 token as payment method
    function setExToken(address _tokenAddress) public onlyOwner { exToken = ERC20(_tokenAddress); }
    
    // Get balance of exToken of this contract
    function getExBalance() public view onlyOwner returns (uint) { return exToken.balanceOf(this); }
    
    // Get balance of tokens-for-sales of this contract
    function getTokenBalance() public view onlyOwner returns (uint) { return token.balanceOf(this); }

    function _processPurchase(address _beneficiary, uint256 _amount) internal { _deliverTokensToBuyer(tokens); }
    
    // Send out tokens-for-sales
    function _deliverTokensToBuyer(uint256 _amount) internal { token.transfer(msg.sender, _amount); }

    function _forwardFunds() internal {
        _receiveExTokensFromBuyer(_amount);
    }
    
    // Receive new token (need to Approve from the exToken by user first)
    function _receiveExTokensFromBuyer(uint256 _amount) internal { exToken.transferFrom(msg.sender, this, _amount); }
    
    // Buy token with exToken
    function buyTokensWithExToken(address _beneficiary, uint256 _amount) public {

        _preValidatePurchase(_beneficiary, _amount);
    
        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(_amount);
    
        // update state
        weiRaised = weiRaised.add(_amount);

        // Give out tokens-for-sales
        _processPurchase(_beneficiary, tokens);
        
        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
    
        // Receive exToken in contract
        _forwardFunds(_amount);
    }
}