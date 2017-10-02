pragma solidity ^0.4.0;

contract ImporterExporterInfo {

  /////////////////////
  // Out getters!
  /////////////////////
  string public description;
    
  address public importer_account;
  address public exporter_account;
  uint256 public payment_value;

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


    // WHy need this ?
  function ImporterExporterInfo() {
  }

  /////////////////////
  // Out setters!
  /////////////////////
  
  function setDescription(string _description){
    description = _description;
  }

    
  // In Remix IDE: enter address between double quotes and prefix with 0x
  // Setter: "0x583031d1113ad414f02576bd6afabfb302140225"
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
