// __author__ = "Herman Hellenes"
// __copyright__ = "Copyright 2017, EY FSO EMEIA"
// __credits__ = ["Herman Hellenes"]
// __license__ = "EY"
// __version__ = "1.0"
// __maintainer__ = "Herman Hellenes"
// __email__ = "herman.a.hellenes@no.ey.com"
// __creation__ = "29/10/2017"
// __status__ = "Production"

////////////////////////////////////////
// Mission description
////////////////////////////////////////
// Goal: This contract will make the pricing of the insurance contract. We 
//       import insurer_exporter.sol, and make one InsureExport object per InsureExport contract
//       in which the related importer has been a purchaser 
//       OBS: This don't need to be on the Blockchain, however if so the reason would be auditing 
//       of the price model and how as well as making sure people are using it correctly 
// Input: Contract addresses where the importer has been a purchaser - from EtherScan
// Output: A price that can be picked up in a contract between exporter and insurer, where then 
//         the exporter can agree on the price and sign the agreement


import "./insurer_exporter.sol"; // Require you have this file open in a tab in the browser

contract InsurancePricing {
    
    
    uint country_rating;
    uint industry_rating;
    uint payment_rating;

     // In order to accessing the other contracts
    InsureExport InsureExportA; 
    InsureExport InsureExportB; 
    

    function setContractConnections(address _A, address _B){
        // Here set the InsureExport object to the address of interest 
        InsureExportA = InsureExport(_A);
        InsureExportB = InsureExport(_B);
    }
    
    function check_importer_address_from_contract_address(address _B) {
        
        
    }
        //checkifcangetaddresstoimporterwhenhave_export_import_contract that is going to be insured
    
    
    function setCountry_rating(){
        // just make that landcode = rating as thomas suggested
         // if (InsureExportA.country() == "")
        
        
    }
    
    
}
