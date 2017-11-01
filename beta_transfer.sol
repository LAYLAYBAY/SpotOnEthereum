pragma solidity ^0.4.11;



contract ExportTransfer {
    address public contractaddress = address(this);
    address public owner;
    bytes32 public industry;
    uint public country;  //Use landcode
    uint public transferDeadline;
    uint public goods;

    address public importer_address;
    address public exporter_address;
    
    address [] public purchasers_address;
    uint public price = 1 ether;
    mapping (address => uint) public purchasers; 
    uint transferdate;
    bool public wasTransferOnTime;
    

    
    // Constructer
    function ExportTransfer() payable {
        owner = msg.sender;
        wasTransferOnTime = false;
        importer_address = owner;
    }
    
    function setIndustry(string _industry)  {
        // Need to convert to bytes in order to call from other contract...
        industry = stringToBytes32(_industry) ;
    }
    function setCountry(uint _country)  {
        //use landcode
        country = _country;
    }
    
    function setExporter(address _exporter)  {
         exporter_address = _exporter;
    }
     
     
    function setTransferDeadline(uint _transferDeadline) {
        // For example let input be 2 minutes
        transferDeadline = now + _transferDeadline * 1 minutes;
    }
    

    function setGoods(uint _goods) {
        // For example let input be 10 // goods == 0 && msg.sender == owner &&
        if (goods == 0 && transferdate == 0 &&  msg.sender == owner) {

             goods = _goods;
        }
    }
    

    // In order to buyGoods, need to put in x ether in the value box to the right
    function buyGoods(uint amount) payable {
        
        if (msg.value != (amount * price) || amount > goods) {
            throw;
        }
        
        purchasers[msg.sender] += amount;
        goods -= amount;
        purchasers_address.push(msg.sender); 
        
        if (goods == 0) {
            // Empty, so bought everything
            hasTransfered(msg.sender); 
            transferdate = now;
            
            // Was transfer on time?
            if (transferDeadline > transferdate && transferdate!=0){
            wasTransferOnTime = true;}
        }
    }   
    
    event hasTransfered(address a);  
  

    function transferToExporter(){
      
      
        // could add &&  && wasTransferOnTime(), however why should we?
         exporter_address.send(this.balance);

    }
  

    function getTransferDate() constant returns (uint) {
        return transferdate;
    }
 
    function stringToBytes32(string memory source) returns (bytes32 result) {
    assembly {
        
        result := mload(add(source, 32))
             }
    }
    


}
