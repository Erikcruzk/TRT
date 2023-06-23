pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

import "./RocketDAOProtocolSettings.sol";
import "../../../../interface/dao/protocol/settings/RocketDAOProtocolSettingsDepositInterface.sol";
 
// Network deposit settings

contract RocketDAOProtocolSettingsDeposit is RocketDAOProtocolSettings, RocketDAOProtocolSettingsDepositInterface {

    // Construct
    constructor(address _rocketStorageAddress) RocketDAOProtocolSettings(_rocketStorageAddress, "deposit") {
        // Set version
        version = 1;
        // Initialize settings on deployment
        if(!getBool(keccak256(abi.encodePacked(settingNameSpace, "deployed")))) {
            // Apply settings
            setSettingBool("deposit.enabled", true);
            setSettingBool("deposit.assign.enabled", true);
            setSettingUint("deposit.minimum", 0.01 ether);
            setSettingUint("deposit.pool.maximum", 1000 ether);
            setSettingUint("deposit.assign.maximum", 2);
            // Settings initialized
            setBool(keccak256(abi.encodePacked(settingNameSpace, "deployed")), true);
        }
    }

    // Deposits currently enabled
    function getDepositEnabled() override public view returns (bool) {
        return getSettingBool("deposit.enabled");
    }

    // Deposit assignments currently enabled
    function getAssignDepositsEnabled() override public view returns (bool) {
        return getSettingBool("deposit.assign.enabled");
    }

    // Minimum deposit size
    function getMinimumDeposit() override public view returns (uint256) {
        return getSettingUint("deposit.minimum");
    }

    // The maximum size of the deposit pool
    function getMaximumDepositPoolSize() override public view returns (uint256) {
        return getSettingUint("deposit.pool.maximum");
    }

    // The maximum number of deposit assignments to perform at once
    function getMaximumDepositAssignments() override public view returns (uint256) {
        return getSettingUint("deposit.assign.maximum");
    }

}
