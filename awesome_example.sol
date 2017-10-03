// from https://www.youtube.com/watch?v=kOBet0BPKzg

pragma solidity ^0.4.11;


// In order to buyTickets, need to put in x ether in the value box to the right

contract FuncConcert {
    
    address owner;
    uint public tickets;
    uint constant price = 1 ether;
    mapping (address => uint) public purchasers;
    
    function FuncConcert(uint t) {
        
        owner = msg.sender;
        tickets = t;
    }
    
    function buyTickets(uint amount) payable {
        
        if (msg.value != (amount * price) || amount > tickets) {
            throw;
        }
        
        purchasers[msg.sender] += amount;
        tickets -= amount;
        
        
        if (tickets == 0) {
            selfdestruct(owner);
        }
    }   
    
    
    // Fallback
    function () payable {
        buyTickets(1);
        //Useful scenario: sending directly to the contract wallet
    }
    
    
    // Abstract function
    function website() returns (string); // needs to be implemented below in AbstractFuncAttack
    
}

// Interface
interface Refundable {
    function refund(uint numTickets) returns(bool);
}


// Inheritance
contract AbstractFuncAttack is FuncConcert(10), Refundable {
    
    function refund(uint numTickets) returns(bool){
        if (purchasers[msg.sender] < numTickets){
            return false;
        }
        
        // every address type has a member function called transfer
        msg.sender.transfer(numTickets * price); // refund
        purchasers[msg.sender] -= numTickets; // remove tickets
        tickets += numTickets; //put tickets back on the market
        return true;
    }
    
    function website() returns (string) {
        return "http://AbstractFuncAttack.com";
    }
    
}
