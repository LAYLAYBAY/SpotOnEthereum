pragma solidity ^0.4.11;


contract InsureExport {
    
    address public owner;
    address public importexportcontract;
    
    
    // Constructer
    function ExportTransfer() {
        
        owner = msg.sender;
    }
    
    function setImportExportContract (){
        // Here the address of the import-export contract is set, 
        // in order for the insurer to look up the importer
        
        
        
        
    }
}
