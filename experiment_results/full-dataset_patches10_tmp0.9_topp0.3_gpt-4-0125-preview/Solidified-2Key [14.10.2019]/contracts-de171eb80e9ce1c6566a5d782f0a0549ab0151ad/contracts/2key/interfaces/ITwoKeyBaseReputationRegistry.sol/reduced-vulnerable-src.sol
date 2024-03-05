

pragma solidity ^0.4.24;




contract ITwoKeyBaseReputationRegistry {
    function updateOnConversionExecutedEvent(address converter, address contractor, address acquisitionCampaign) public;
    function updateOnConversionRejectedEvent(address converter, address contractor, address acquisitionCampaign) public;
}