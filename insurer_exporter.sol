pragma solidity ^0.4.11;


// Importing

import "./beta_transfer1.sol"; // Require you have this file open in a tab in the browser

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
    // Here just tried to reference a single contract, and now works well
    // However we want to have input of the importer's address, and from that 
    // find the different contracts this importer is engaged in
    // The import-export contract address is 0x689F85526Da3fB9953D7733266B4cE1883e79609
    address public importexportcontract; 

    string c;

    // Constructer
    function InsureExport() {
        
        owner = msg.sender;
    }
    
    function setImportExportContract(address _c){
        // Here the address of the import-export contract is set, 
        // in order for the insurer to look up the importer
        
        importexportcontract = _c;

    }
    
    function setContractConnection(){
        // Here set the ExportTransfer object to the address we want 
        export_import = ExportTransfer(importexportcontract);
        
    }
    
    function getIndustry() returns (string) {
        
        return bytes32ToString(export_import.industry());
    }
    
    
    function getCountry() returns (uint) {
        return export_import.country();
    }
    
    
    function getExportImportOwner() returns (address) {
        return export_import.owner();
    }
    
    function getImporter() returns (address) {
        return export_import.importer_address();
    }
    

    function getTransferDeadline() constant returns (uint) {
        //The compiler automatically creates getter functions for all public state variables.
        uint deadline = export_import.transferDeadline();
        return deadline;
    }
    
    
    function getWasTransferOnTime() returns (bool) {
        return export_import.wasTransferOnTime();
    }



    function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

 
    
}
