pragma solidity ^0.4.0;

import "http://github.com/pipermerriam/ethereum-datetime/contracts/DateTime.sol";

contract helloWorld {

    function renderHelloWorld () returns (int256) {
        int y = 2;
       
       address ethereum_datetime = 0x1a6184cd4c5bea62b0116de7962ee7315b7bcbce;
         DateTime dateTime = DateTime(ethereum_datetime);

        uint8 dayOfWeek = dateTime.getWeekday(now);  // 0 to 7 in this implementation
        return dayOfWeek;
 }
}








