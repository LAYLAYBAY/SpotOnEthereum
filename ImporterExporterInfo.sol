pragma solidity ^0.4.0;


//import "https://github.com/pipermerriam/ethereum-datetime/blob/master/contracts/api.sol"
//import "https://github.com/pipermerriam/ethereum-datetime/blob/master/contracts/DateTime.sol"
import "http://github.com/pipermerriam/ethereum-datetime/contracts/DateTime.sol";

//getYear(uint timestamp) constant returns (uint16)


contract TestContract {

  /////////////////////
  // Out getters!
  /////////////////////
  string public description;
    
  address public importer_account;
  address public exporter_account;
  uint256 public payment_value;

  address owner; 
  bool public leap; 
  
  uint16 public transferdate;
  bool public ready_to_transfer;

  // setRequirements is a mapping from uint256 to Data (the struct below). 
  // uint256 is the key, that we have to enter to the "requirements box" to the
  // right in order to get Data out
  mapping(uint256 => Data) public requirements; 
  struct Data {
    uint time;
    string ref;
    string info;
  }


  mapping(uint256 => Label[]) public labels;
  struct Label {
    string name_exporter_company;
    string exporter_country;
    string name_importer_company;
    string importer_country;
  }
  


  
  function TestContract() {
      // This is the constructor!
      
      // Now, because deploying a contract is a transaction,
      // and msg.sender is the one doing that (spending ether on creating the contract)
      // So here we save the address of the
      owner = msg.sender;
  }
  
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
  
  
 function setTransferDate(uint16 _transdate) onlyOwner {
    
    // Enter unix timestamp
    transferdate = _transdate;
    
    //Now this is logging msg.sender when changing the transferdate
    Changed(msg.sender);
  }
  
  //Events are like writing logs to the blockchain
  event Changed (address a);
  
  function setTransferDateReady(){
      // http://solidity.readthedocs.io/en/latest/units-and-global-variables.html
      // https://www.unixtimestamp.com/index.php
      if (now > transferdate){
          ready_to_transfer = true;
               }
     else{ready_to_transfer = false;}
      
  }
  
  function setIsLeapYear(uint16 year) {
    bool _leap = true;
    if (year % 4 != 0) {
        _leap = false;}
    else if (year % 100 != 0) {
        _leap = true;}
    else if (year % 400 != 0) {
        _leap = false;}
    
    
    
    leap = _leap;
      
  }

  /////////////////////
  // Out setters!
  /////////////////////
  
  function setDescription(string _description){
    description = _description;
  }
  
  
   function setImporterAccount(address _account){
    importer_account = _account;
  }
  
  

  function setExporterAccount(address _account){
    exporter_account = _account;
  }
  
  function setPaymentValue(uint256 _payment_value){
    payment_value = _payment_value;
  }
  
  
  // This does the mapping: mapping(uint256 => Data) public requirements;
  // Here, the key is a uint256, the uint256 _idx below
  // Setter: 456, "aaa", "bbb" (setRequirements)
  // Getter: 456 (requirements)
  function setRequirements(uint256 _idx, string _ref, string _info) {
      // It's a mapping from uint256 to the Data struct
      // "now" is a global variable, setting the current block timestamp
      requirements[_idx] = Data(now, _ref, _info); 
  }


}
