



pragma solidity 0.8.13;

interface IPriceFeed {

    
    event LastGoodPriceUpdated(uint _lastGoodPrice);
   
    
    function fetchPrice() external returns (uint);
}





pragma solidity 0.8.13;

interface IAstridBase {
    function priceFeed() external view returns (IPriceFeed);
}