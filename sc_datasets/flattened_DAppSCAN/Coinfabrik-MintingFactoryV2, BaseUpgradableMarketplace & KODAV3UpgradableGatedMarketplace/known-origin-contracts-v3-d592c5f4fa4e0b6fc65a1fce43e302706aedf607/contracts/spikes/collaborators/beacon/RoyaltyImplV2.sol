// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/collaborators/IFundsHandler.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface IFundsHandler {

    function init(address[] calldata _recipients, uint256[] calldata _splits) external;

    function totalRecipients() external view returns (uint256);

    function royaltyAtIndex(uint256 index) external view returns (address _recipient, uint256 _split);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/collaborators/handlers/FundsSplitter.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/**
 * splits all funds as soon as the contract receives it
 */
contract FundsSplitter is IFundsHandler {

    bool private locked;

    uint256 constant SCALE = 100000;

    address[] public recipients;
    uint256[] public splits;

    /**
     * @notice Using a minimal proxy contract pattern initialises the contract and sets delegation
     * @dev initialises the FundsReceiver (see https://eips.ethereum.org/EIPS/eip-1167)
     */
    function init(address[] calldata _recipients, uint256[] calldata _splits) override external {
        require(!locked, "contract locked sorry");
        locked = true;
        recipients = _recipients;
        splits = _splits;
    }

    // TODO test GAS limit problems ... ? call vs transfer 21000 limits?

    // accept all funds
    receive() external payable {

        // accept funds
        uint256 balance = msg.value;
        uint256 singleUnitOfValue = balance / SCALE;

        // split according to total
        for (uint256 i = 0; i < recipients.length; i++) {

            // Work out split
            uint256 share = singleUnitOfValue * splits[i];

            // TODO assumed all recipients are EOA and not contracts ... ?
            // AMG: would it be a problem if a contract? Doubt it?

            // Fire split to recipient
            payable(recipients[i]).transfer(share);
        }
    }

    // Enumerable by something else

    function totalRecipients() public override view returns (uint256) {
        return recipients.length;
    }

    function royaltyAtIndex(uint256 _index) public override view returns (address recipient, uint256 split) {
        recipient = recipients[_index];
        split = splits[_index];
    }
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/collaborators/beacon/RoyaltyImplV2.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract RoyaltyImplV2 is FundsSplitter {

}
