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
    
    
    function setCountry_rating(){
        
        // Need to do the freakin byte32 conversion again...
        // However maybe I can just do it for one of the InsureExport since same importer anyway
        
        if (InsureExportA.country() == "")
        
        
    }
    
    
}
