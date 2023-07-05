// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/collab/handlers/ICollabFundsHandler.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface ICollabFundsHandler {

    function init(address[] calldata _recipients, uint256[] calldata _splits) external;

    function totalRecipients() external view returns (uint256);

    function shareAtIndex(uint256 index) external view returns (address _recipient, uint256 _split);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/collab/handlers/CollabFundsHandlerBase.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

abstract contract CollabFundsHandlerBase is ICollabFundsHandler {

    /// @notice in line with EIP-2981 format - precision 100.00000%
    uint256 internal constant modulo = 100_00000;

    address[] public recipients;
    uint256[] public splits;

    bool internal locked = false;

    /**
     * @notice Using a minimal proxy contract pattern initialises the contract and sets delegation
     * @dev initialises the FundsReceiver (see https://eips.ethereum.org/EIPS/eip-1167)
     */
    function init(address[] calldata _recipients, uint256[] calldata _splits) override virtual external {
        require(!locked, "contract locked sorry");

        // Validate splits are correct
        uint256 total;
        for (uint256 i = 0; i < _splits.length; i++) {
            total = total + _splits[i];
        }
        require(total == modulo, "Shares dont not equal 100%");

        locked = true;
        recipients = _recipients;
        splits = _splits;
    }

    /// get the number of recipients this funds handler is configured for
    function totalRecipients() public override virtual view returns (uint256) {
        return recipients.length;
    }

    /// get the recipient and split at the given index of the shares list
    function shareAtIndex(uint256 _index) public override view returns (address recipient, uint256 split) {
        recipient = recipients[_index];
        split = splits[_index];
    }
}
