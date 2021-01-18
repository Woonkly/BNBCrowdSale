// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/ownership/Ownable.sol";

import "./Crowdsale.sol";

contract WOPCrowdsale is  Crowdsale,Ownable {
    
    
    
    constructor(
        uint256 rate,    // rate in TKNbits
        address payable wallet,
        IERC20 token
    )
        Crowdsale(rate, wallet, token)
        public
    {

    }
    
    
    function changeRate(uint256 newrate) public onlyOwner {
        _rate=newrate;
    }

    function changeWallet(address payable newWallet) public onlyOwner {
        _wallet=newWallet;
    }

    function()  external payable { }
    
    function getMyether() public view returns(uint256){
            address payable self = address(this);
            uint256 bal =  self.balance;    
            
            return bal;
            
    }

    function getWeiAmount(uint256 tkAmount) public view returns (uint256) {
        return  tkAmount.div(_rate);
    }

    function getTokenAmount(uint256 weiAmount) public view returns (uint256) {
        return _getTokenAmount(weiAmount);
    }


    function getMyBalance() public view returns (uint256) {
        return _token.balanceOf(address(this));
    }


    function buyMyTokens() public payable {
        address buyer =address(msg.sender);
        buyTokens(buyer);
    }

    
    event FundsWithdrawed(address indexed beneficiary, address indexed provider, uint256 value);

    function withdrawFunds(uint256 ret) public onlyOwner nonReentrant payable{
        require(ret<=getMyether(),"WOPCrowdsale: Error insuficients funds");
        msg.sender.transfer(ret);
        
        if(_weiRaised<=ret){
            _weiRaised = _weiRaised.sub(ret, "WOPCrowdsale: transfer amount exceeds _weiRaised");
        }else{
            _weiRaised=0;
        }

        
        emit FundsWithdrawed(address(msg.sender), address(_wallet), ret);
    }


    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        _token.transfer(beneficiary, tokenAmount);
    }


    
}

   

