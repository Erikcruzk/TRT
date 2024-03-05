

pragma solidity ^0.4.24;




contract ITwoKeyCampaignPublicAddresses {
    address public twoKeySingletonesRegistry;
    address public contractor; 
    address public moderator; 
    function publicLinkKeyOf(address me) public view returns (address);
}