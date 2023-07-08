// File: ../sc_datasets/DAppSCAN/PeckShield-LuckyChip/staking-23e5db6078aa12754ae69048c7754c7f1e90b375/contracts/libs/ILuckyChipReferral.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

interface ILuckyChipReferral {
    /**
     * @dev Record referral.
     */
    function recordReferral(address user, address referrer) external;

    /**
     * @dev Record referral commission.
     */
    function recordReferralCommission(address referrer, uint256 commission) external;

    /**
     * @dev Get the referrer address that referred the user.
     */
    function getReferrer(address user) external view returns (address);
}
