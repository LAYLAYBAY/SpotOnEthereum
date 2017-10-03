pragma solidity ^0.4.0;


contract ImporterExporterContract {
    

  /////////////////////
  // Out getters!
  /////////////////////

  string public description;
  // 'public' makes externally readable (not writeable) by users or contracts

    
  address public importer_account;
  address public exporter_account;
  uint256 public payment_value;

  address owner; 

  uint16 public transferdate;
  bool public ready_to_transfer;
  
  // dictionary that maps addresses to balances
  mapping (address => uint) private balances;
  // "private" means that other contracts can't directly query balances
  // but data is still viewable to other parties on blockchain

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
  
  // This is the constructor!
  function ImporterExporterContract() {
      // Now, because deploying a contract is a transaction,
      // and msg.sender is the one doing that (spending ether on creating the contract)
      // So here we save the address of the owner
      // msg provides details about the message that's sent to the contract
      // msg.sender is contract caller (address of contract creator)
      owner = msg.sender;
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
    
    function deposit() public returns (uint) {
        // uint used for currency amount (there are no doubles
        //  or floats) and for dates (in unix time)
       
        balances[msg.sender] += msg.value;
        // no "this." or "self." required with state variable
        // all values set to data type's initial value by default

        DepositMade(msg.sender, msg.value); // fire event

        return balances[msg.sender];
    }
    
    /// @notice Get balance
    /// @return The balance of the user
    // 'constant' prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function balance() constant returns (uint) {
        return balances[msg.sender];
    }
  
  
    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () {
        throw; // throw reverts state to before call
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
  
  event DepositMade(address accountAddress, uint amount);
  
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
    2 ether == 2000 finney;
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
  
  
  
  // Now we go into the transfering 
  
  
  
  
  

}
