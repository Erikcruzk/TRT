// File: ../sc_datasets/DAppSCAN/Chainsecurity-Primitive Finance  Core engine smart contracts/rmm-core-c44f8ca1ee43772ec4ba56e031bdb6fb8aac0ca3/contracts/libraries/SafeCast.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

/// @notice Safely cast between uint256 and uint128
library SafeCast {
    /// @notice reverts if x > type(uint128).max
    function toUint128(uint256 x) internal pure returns (uint128 z) {
        require((z = uint128(x)) == x);
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Primitive Finance  Core engine smart contracts/rmm-core-c44f8ca1ee43772ec4ba56e031bdb6fb8aac0ca3/contracts/libraries/Margin.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

/// @notice  Margin Library
/// @author  Primitive
/// @dev     Uses a data struct with two uint128s to optimize for one storage slot
library Margin {
    using SafeCast for uint256;

    struct Data {
        uint128 balanceRisky; // Balance of the risky token, aka underlying asset
        uint128 balanceStable; // Balance of the stable token, aka "quote" asset
    }

    /// @notice             Adds to risky and stable token balances
    /// @param  margin      Margin data of an account in storage to manipulate
    /// @param  delRisky    Amount of risky tokens to add to margin
    /// @param  delStable   Amount of stable tokens to add to margin
    function deposit(
        Data storage margin,
        uint256 delRisky,
        uint256 delStable
    ) internal {
        if (delRisky > 0) margin.balanceRisky += delRisky.toUint128();
        if (delStable > 0) margin.balanceStable += delStable.toUint128();
    }

    /// @notice             Removes risky and stable token balance from `msg.sender`'s internal margin account
    /// @param  margins     Margin data mapping, uses `msg.sender`'s margin account
    /// @param  delRisky    Amount of risky tokens to subtract from margin
    /// @param  delStable   Amount of stable tokens to subtract from margin
    /// @return margin      Data storage of a margin account
    function withdraw(
        mapping(address => Data) storage margins,
        uint256 delRisky,
        uint256 delStable
    ) internal returns (Data storage margin) {
        margin = margins[msg.sender];
        if (delRisky > 0) margin.balanceRisky -= delRisky.toUint128();
        if (delStable > 0) margin.balanceStable -= delStable.toUint128();
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Primitive Finance  Core engine smart contracts/rmm-core-c44f8ca1ee43772ec4ba56e031bdb6fb8aac0ca3/contracts/test/libraries/TestMargin.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

/// @title   Margin Lib API Test
/// @author  Primitive
/// @dev     For testing purposes ONLY

contract TestMargin {
    using Margin for Margin.Data;
    using Margin for mapping(address => Margin.Data);

    /// @notice Mapping used for testing
    mapping(address => Margin.Data) public margins;

    function margin() public view returns (Margin.Data memory) {
        return margins[msg.sender];
    }

    /// @notice Adds to risky and riskless token balances
    /// @param  delRisky  The amount of risky tokens to add to margin
    /// @param  delStable  The amount of stable tokens to add to margin
    /// @return The margin data storage item
    function shouldDeposit(uint256 delRisky, uint256 delStable) public returns (Margin.Data memory) {
        uint128 preX = margins[msg.sender].balanceRisky;
        uint128 preY = margins[msg.sender].balanceStable;
        margins[msg.sender].deposit(delRisky, delStable);
        assert(preX + delRisky >= margins[msg.sender].balanceRisky);
        assert(preY + delStable >= margins[msg.sender].balanceStable);
        return margins[msg.sender];
    }

    /// @notice Removes risky and riskless token balance from `msg.sender`'s internal margin account
    /// @param  delRisky  The amount of risky tokens to add to margin
    /// @param  delStable  The amount of stable tokens to add to margin
    /// @return The margin data storage item
    function shouldWithdraw(uint256 delRisky, uint256 delStable) public returns (Margin.Data memory) {
        uint128 preX = margins[msg.sender].balanceRisky;
        uint128 preY = margins[msg.sender].balanceStable;
        margins[msg.sender] = margins.withdraw(delRisky, delStable);
        assert(preX - delRisky >= margins[msg.sender].balanceRisky);
        assert(preY - delStable >= margins[msg.sender].balanceStable);
        return margins[msg.sender];
    }
}
