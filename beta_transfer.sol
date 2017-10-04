// from https://www.youtube.com/watch?v=kOBet0BPKzg

pragma solidity ^0.4.11;


// In order to buyTickets, need to put in x ether in the value box to the right

contract ExportTransfer {
    
    address public owner;
    uint public goods;
    uint constant price = 1 ether;
    mapping (address => uint) public purchasers;
    uint transferDeadline;
    uint transferdate;
    
    // Constructer
    function ExportTransfer(uint g, uint d) {
        
        owner = msg.sender;
        goods = g;
        transferDeadline = d;
    }
    
    function buyGoods(uint amount) payable {
        
        if (msg.value != (amount * price) || amount > goods) {
            throw;
        }
        
        purchasers[msg.sender] += amount;
        goods -= amount;
        
        
        if (goods == 0) {
            // Empty, so bought everything
            hasTransfered(msg.sender); 
            transferdate = now;
            selfdestruct(owner);
        }
    }   
    
  event hasTransfered(address a);  
  
  
  function wasTransferOnTime() returns(bool){

      if (transferDeadline > transferdate){
          return true;}
          
     else{return false;}
      
  }
    
    
    // Fallback
    function () payable {
        buyGoods(1);
        //Useful scenario: sending directly to the contract wallet
    }
    
    
    // Abstract function
    function website() returns (string); // needs to be implemented below in AbstractFuncAttack
    
}

// Interface
interface Refundable {
    function refund(uint numTickets) returns(bool);
}


interface ERC20 {
     //function totalSupply() constant returns (uint totalSupply);
    // function balanceOf(address _owner) constant returns (uint balance);
     //function transfer(address _to, uint _value) returns (bool success);
     //function transferFrom(address _from, address _to, uint _value) returns (bool success);
     //function approve(address _spender, uint _value) returns (bool success);
     //function allowance(address _owner, address _spender) constant returns (uint remaining);     // Returns the amount which _spender is still allowed to withdraw from _owner
     //event Transfer(address indexed _from, address indexed _to, uint _value);
     //event Approval(address indexed _owner, address indexed _spender, uint _value);
     
     
 }


// Inheritance
contract GiekExportTransfer is ExportTransfer(10, now + 10 minutes) {
    
    function website() returns (string) {
        return "http://AbstractFuncAttack.com";
    }
    
  // Balances for each account
  mapping (address => uint) balances;   // dictionary that maps addresses to balances
    
  // Owner of account approves the transfer of an amount to another account
  mapping(address => mapping (address => uint256)) allowed;
    
    // Send _value amount of tokens from address _from to address _to
  // The transferFrom method is used for a withdraw workflow, allowing contracts to send
  // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
  // fees in sub-currencies; the command should fail unless the _from account has
  // deliberately authorized the sender of the message via some mechanism; we propose
  // these standardized APIs for approval:
  function transferFrom(
         address _from,
         address _to,
         uint256 _amount
     ) returns (bool success) {
         if (balances[_from] >= _amount
             && allowed[_from][msg.sender] >= _amount
             && _amount > 0
             && balances[_to] + _amount > balances[_to]) {
             balances[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             balances[_to] += _amount;
             return true;
         } else {
             return false;
         }
   }
  
         
         
}
