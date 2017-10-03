pragma solidity ^0.4.0;


// TODO: get a proper working transfering function, that the exporter can use to transfering
// to importer (owner). Now have functions deposit but maybe "<address>.transfer(uint256 amount):
// send given amount of Wei to Address, throws on failure" should be introduced

// The transfer should trigger the Depostmade. Should combine this with setPaymentValue
// and ready_to_transfer and balances. An external, the insurer, should be able to see
// if the payment was on time or not.

// Hints: 
// All addresses can be sent ether
// owner.send(SOME_BALANCE); // returns false on failure
// if (owner.send) {} // typically wrap in 'if', as contract addresses have
// functions have executed on send and can fail

// Now is a bit of a mess, make this clean and easy
// Try to follow https://theethereum.wiki/w/index.php/ERC20_Token_Standard as much as possible!

//Following is an interface contract declaring the required functions and events to meet the ERC20 standard:
// https://github.com/ethereum/EIPs/issues/20
contract ERC20 {
     function totalSupply() constant returns (uint totalSupply);
     function balanceOf(address _owner) constant returns (uint balance);
     function transfer(address _to, uint _value) returns (bool success);
     function transferFrom(address _from, address _to, uint _value) returns (bool success);
     function approve(address _spender, uint _value) returns (bool success);
     function allowance(address _owner, address _spender) constant returns (uint remaining);
     event Transfer(address indexed _from, address indexed _to, uint _value);
     event Approval(address indexed _owner, address indexed _spender, uint _value);
 }

contract ImporterExporterContract {
    
  
  /////////////////////
  // Out getters!
  /////////////////////
  
  // can here put description of the contract
  string public description; // 'public' makes externally readable (not writeable) by users or contracts

  // accounts
  address public importer_account;
  address public exporter_account;
  address public owner; 
  
   // This is the constructor!
  function ImporterExporterContract() {
      // Now, because deploying a contract is a transaction,
      // and msg.sender is the one doing that (spending ether on creating the contract)
      // So here we save the address of the owner
      // msg provides details about the message that's sent to the contract
      // msg.sender is contract caller (address of contract creator)
      owner = msg.sender;
  }

  // Names; just saving company names and country
  // setNames is a mapping from uint256 to Names (the struct below). 
  // uint256 is the key, that we have to enter to the "names box" to the
  // right in order to get Names out
  mapping(uint256 => Names) public names;
  struct Names {
    string name_exporter_company;
    string exporter_country;
    string name_importer_company;
    string importer_country;
  }
  
  
  // transferdate
  uint16 public transferdate;
  bool public ready_to_transfer;
  
  uint256 public payment_value;

  // Balances for each account
  mapping (address => uint) balances;   // dictionary that maps addresses to balances

  // What is the balance of a particular account?
      // 'constant' prevents function from editing state variables;
     // allows function to run locally/off blockchain
  function balanceOf(address _owner) constant returns (uint256 balance) {
         return balances[_owner];}

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
  
 

  // Securing that only the contract owner can make modifications, we can deploy onlyOwner
  modifier onlyOwner {
      // Only the owner can make modifications: modifications mean update setters after first setting basically
      // Might be a bit special when the state is in the constructor though
    if (msg.sender != owner) {
       //Then we throw an exception
         throw;
     } 
     //But if now, we go on and exceexception
     //The underscore here, is just a placeholder for the functuion you want to modify (see example with sesetTransferDate below)
     _;
    }

    


    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () {
        throw; // throw reverts state to before call
    }
    
    
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _amount) returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
         return true;
     }
    
  /////////////////////
  // Out setters!
  /////////////////////
 function setTransferDate(uint16 _transdate) onlyOwner {
    
    // Enter unix timestamp
    transferdate = _transdate;
    
    //Now this is logging msg.sender when changing the transferdate
    Changed(msg.sender);
  }
  
  //Events are like writing logs to the blockchain. Publicize actions to external listeners
  event Changed (address a);
  
  event Approval(address indexed _owner, address indexed _spender, uint _value);
  
  event Transfer(address indexed _from, address indexed _to, uint _value);
  
  function setTransferDateReady(){
      // http://solidity.readthedocs.io/en/latest/units-and-global-variables.html
      // https://www.unixtimestamp.com/index.php
      if (now > transferdate){
          ready_to_transfer = true;
               }
     else{ready_to_transfer = false;}
      
  }
  

  function setDescription(string _description){
    description = _description;
  }
  
  
   function setImporterAccount(address _account){
    importer_account = _account;
    Changed(msg.sender);

  }
  
  

  function setExporterAccount(address _account){
    exporter_account = _account;
    Changed(msg.sender);

  }
  
  function setPaymentValue(uint256 _payment_value){
    payment_value = _payment_value;
    Changed(msg.sender);

  }
  
  
  // This does the mapping: mapping(uint256 => Data) public requirements;
  // Here, the key is a uint256, the uint256 _idx below
  // Setter: 456, "aaa", "bbb" (setRequirements)
  // Getter: 456 (requirements)
  function setNames(uint256 _idx, string _name_exporter_company, string _exporter_country,
                    string _name_importer_company, string _importer_country) {
      // It's a mapping from uint256 to the Data struct
      // "now" is a global variable, setting the current block timestamp
      names[_idx] = Names(_name_exporter_company, _exporter_country, _name_importer_company,
                          _importer_country); 
  }
  
  
}
