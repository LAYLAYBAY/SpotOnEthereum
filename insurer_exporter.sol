// __author__ = "Herman Hellenes"
// __copyright__ = "Copyright 2017, EY FSO EMEIA"
// __credits__ = ["Herman Hellenes"]
// __license__ = "EY"
// __version__ = "1.0"
// __maintainer__ = "Herman Hellenes"
// __email__ = "herman.a.hellenes@no.ey.com"
// __creation__ = "20/10/2017"
// __status__ = "Production"


pragma solidity ^0.4.11;


// Importing

import "./beta31.sol"; // Require you have this file open in a tab in the browser

// dont get this to work, would be nice though...
// import "github.com/herman-hellenes/SpotOnEthereum/blob/master/beta_transfer.sol";

// but this works! wierd, maybe some settings on my github?
//import "github.com/ethereum/ens/contracts/ENS.sol";

contract InsureExport {
    
    // This contract is used by the insurer to load data from the exporter-importer contract
    // First we aim to obtain information from that contract, especially the importer's 
    // address. This we will further use to see this importer's previous contracts
    // to make a rating model that determine an insurance premium for a new deadline
    
    // After this, next step is to make a contract between exporter and importer
    // where the exporter agrees on the insurance premium and then sign the deal 
    // However this could be done in a seperate contract if beneficial
    
    // The owner of this contract is now the exporter, with 0x42d7ca171ebef46dcd0d7fff7c5dd16b926a48a3, which is on 
    // the Ropsten testnet
    address public owner; 
        
    // In order to accessing the other contract
    ExportTransfer export_import; 
    ExportTransfer export_import_old_A;
    ExportTransfer export_import_old_B;
    // Here just tried to reference a single contract, and now works well
    // However we want to have input of the importer's address, and from that 
    // find the different contracts this importer is engaged in
    // The import-export contract address is 0x689F85526Da3fB9953D7733266B4cE1883e79609
    address public importexportcontract; 
    address public import_exportcontract_Old_A; 
    address public import_exportcontract_Old_B; 
    string c;

    uint public importer_country;
    uint public old_contracts_on_time;
    uint public ether_size_expimp;
    
    uint public insurance_subtraction;
    uint public insurance_price;
    
    ///For paying the insurance price 
    address public insurer_address;
    address [] public insurance_purchaser_address;
    mapping (address => uint) public insurance_purchaser; 
    uint public num_insurances; //previously goods
    
    // Constructer
    function InsureExport() {
        
        owner = msg.sender;
        num_insurances = 1;
        insurer_address = 0x81fB3c851C428167C1649d7e402d6385236a788D;
    }
    
    
     // In order to buyInsurance, need to put in x ether in the value box to the right
    function buyInsurance(uint amount) payable {
        
        if (msg.value != (amount * insurance_price) || amount > num_insurances) {
            throw;
        }
        
        insurance_purchaser[msg.sender] += amount;
        num_insurances -= amount;
        insurance_purchaser_address.push(msg.sender); 
        
        if (num_insurances == 0) {
            // Empty, so bought everything
            hasTransferedInsurancePayment(msg.sender); 

        }
    }
    
    event hasTransferedInsurancePayment(address a);  
  

    function transferToInsurer(){
      
         insurer_address.send(this.balance);
    }
    
    
    function setImportExportContract(address _c){
        // Here the address of the import-export contract is set, 
        // in order for the insurer to look up the importer
        
        importexportcontract = _c;
        // Here set the ExportTransfer object to the address we want 
        export_import = ExportTransfer(importexportcontract);

    }
    


    function getTransferDeadline() constant returns (uint) {
        //The compiler automatically creates getter functions for all public state variables.
        uint deadline = export_import.transferDeadline();
        return deadline;
    }
    
    
    function getWasTransferOnTime() returns (bool) {
        bool wasontime = export_import.wasTransferOnTime();
        return wasontime;
    }




    //////////////////////////////////////////////////////////////////////////////////////
    // For getting if-transfered from the past (old importers contracts)
    //////////////////////////////////////////////////////////////////////////////////////
    function setOldImportExportContract(address _a, address _b){
        // Here the address of the old import-export contract is set, 
        import_exportcontract_Old_A = _a;
        import_exportcontract_Old_B = _b;
        
        // Here set the ExportTransfer object to the address we want 
        export_import_old_A = ExportTransfer(import_exportcontract_Old_A);
        export_import_old_B = ExportTransfer(import_exportcontract_Old_B);

    }
    



   
    function getWasOldTransfersOnTime() returns (uint) {
        // return 0 if none were  on  time 
        // return 1 if one was on time 
        // return 2 if both were on time 
        bool on_time_A = export_import_old_A.wasTransferOnTime();
        bool on_time_B = export_import_old_B.wasTransferOnTime();
        
        uint on_time_A_int = on_time_A ? 1 : 0;
        uint on_time_B_int = on_time_B ? 1 : 0;
        uint sum_A_B = on_time_A_int + on_time_B_int;
        old_contracts_on_time = sum_A_B;
        return sum_A_B;
    }



    //////////////////////////////////////////////////////////////////////////////////////
    // Price model
    //////////////////////////////////////////////////////////////////////////////////////
    function calculateInsurancePrice() {
        // calculate and finally set insurance_price var
        
        // Cant yet do float division in Solidity, so make a very simple discrete model 
        uint country_price;
        if (importer_country > 100 ) {
            country_price = 100 finney;
            } else{country_price = 0 finney;}
            
        ether_size_expimp = export_import.price();
        importer_country = export_import.country();
        
        insurance_subtraction= 200 finney + old_contracts_on_time*100 finney - country_price;
        insurance_price = ether_size_expimp - insurance_subtraction;
    }




 
    
}

