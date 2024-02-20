

pragma solidity ^0.4.24;




contract ITwoKeyCampaignPublicAddresses {
    address public twoKeySingletonesRegistry;
    address public contractor; 
    address public moderator; 
    function publicLinkKeyOf(address me) public view returns (address);
}



pragma solidity ^0.4.24;





contract ITwoKeyAcquisitionCampaignStateVariables is ITwoKeyCampaignPublicAddresses {
    address public twoKeyAcquisitionLogicHandler;
    address public conversionHandler;

    function getInventoryBalance() public view returns (uint);
}