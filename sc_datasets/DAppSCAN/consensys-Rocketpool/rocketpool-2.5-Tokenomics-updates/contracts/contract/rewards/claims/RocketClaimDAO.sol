pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

import "../../RocketBase.sol";
import "../../../interface/RocketVaultInterface.sol";
import "../../../interface/rewards/RocketRewardsPoolInterface.sol";
import "../../../interface/rewards/claims/RocketClaimDAOInterface.sol";


// RPL Rewards claiming by the DAO
contract RocketClaimDAO is RocketBase, RocketClaimDAOInterface {

    // Events
    event RPLTokensSentByDAOProtocol(string invoiceID, address indexed from, address indexed to, uint256 amount, uint256 time);

    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) {
        // Version
        version = 1;
    }

    // Determine if this contract is enabled or not for claims
    function getEnabled() override public view returns (bool) {
        // Init the rewards pool contract
        RocketRewardsPoolInterface rewardsPool = RocketRewardsPoolInterface(getContractAddress('rocketRewardsPool'));
        return rewardsPool.getClaimingContractEnabled('rocketClaimDAO');
    }


    // Spend the network DAOs RPL rewards 
    function spend(string memory _invoiceID, address _recipientAddress, uint256 _amount) override public onlyLatestContract("rocketDAOProtocolProposals", msg.sender) {
        // Load contracts
        RocketVaultInterface rocketVault = RocketVaultInterface(getContractAddress('rocketVault'));
        // Addresses
        address rplTokenAddress = getContractAddress('rocketTokenRPL');
        // Some initial checks
        require(_amount > 0 && _amount <= rocketVault.balanceOfToken('rocketClaimDAO', rplTokenAddress), "You cannot send 0 RPL or more than the DAO has in its account");
        // Send now
        require(rocketVault.withdrawToken(_recipientAddress, rplTokenAddress, _amount), "Could not send token balance from vault for network DAO");
        // Log it
        emit RPLTokensSentByDAOProtocol(_invoiceID, address(this), _recipientAddress, _amount, block.timestamp);
    }
  

}
