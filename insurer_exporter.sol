pragma solidity ^0.4.11;


// In order to buyTickets, need to put in x ether in the value box to the right

contract InsureExport {
    
    address public owner;
    address public importexportcontract;
    
    
    // Constructer
    function InsureExport() {
        
        owner = msg.sender;
    }
    
    function setImportExportContract(address _c){
        // Here the address of the import-export contract is set, 
        // in order for the insurer to look up the importer
        
        importexportcontract = _c;
        
    }
    
    
    function getImportAddress() returns(address){
        
        // Think this is spot on: https://ethereum.stackexchange.com/questions/20864/using-contract-from-another-contract
        
        //See https://ethereum.stackexchange.com/questions/15930/pushing-pulling-data-from-data-storage-contract
        
        
        // Following is not working (web3 not in remix?) Would be great to do
        //it this way though
        //The index is 0 since this is the first global variable defined. 
        //If you are not sure what index the variable is at, or its a more complex 
        //type like a mapping or array, you can use http://live.ether.camp to 
        //visually inspect the storage of the contract
        //web3.eth.getStorageAt(address,0);
    }
    
    

    
    
}
