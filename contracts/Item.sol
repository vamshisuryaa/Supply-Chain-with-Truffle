pragma solidity ^0.6.0;


import "./ItemManager.sol";

contract Item{
    
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _index, uint _priceInWei) public{
        
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
  
    }
    
    receive() external payable{
        
      //  address(parentContract).transfer(msg.value);// only works for 2300 gas
        
        require(pricePaid ==0, "Item is paid already");
        require(priceInWei == msg.value,"ONLY FULL PAYMENTS ALLOWED");
        pricePaid += msg.value;
        
        
        
        (bool success,) = address(parentContract).call.{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));// low level call, so very important to listen to return values , call function gives 2 return values
        require(success,"THE TRANSACTION WAASNT SUCCESSFUL, CANCELLING");
        //for function signature creation we use abi.encodeWithSignature
        
    }
    
    fallback() external{}
    
}