// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/libraries/SafeCast.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  SafeCast
/// @notice Safely cast between uint256 and uint128
library SafeCast {
    /// @notice reverts if x > type(uint128).max
    function toUint128(uint256 x) internal pure returns (uint128 z) {
        require(x <= type(uint128).max);
        z = uint128(x);
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/libraries/Reserve.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

/// @title   Reserves Library
/// @author  Primitive
/// @dev     Data structure library for an Engine's Reserves
library Reserve {
    using SafeCast for uint256;

    /// @notice                Stores global state of a pool
    /// @param reserveRisky    Risky token reserve
    /// @param reserveStable   Stable token reserve
    /// @param liquidity       Total supply of liquidity
    /// @param blockTimestamp  Last timestamp of which updated the accumulators
    /// @param cumulativeRisky Cumulative sum of the risky reserves
    /// @param cumulativeStable Cumulative sum of stable reserves
    /// @param cumulativeLiquidity Cumulative sum of total liquidity supply
    struct Data {
        uint128 reserveRisky;
        uint128 reserveStable;
        uint128 liquidity;
        uint32 blockTimestamp;
        uint256 cumulativeRisky;
        uint256 cumulativeStable;
        uint256 cumulativeLiquidity;
    }

    /// @notice                 Adds to the cumulative reserves
    /// @dev                    Overflow is desired on the cumulative values
    /// @param  res             Reserve storage to update
    /// @param  blockTimestamp  Checkpoint timestamp of update
    function update(Data storage res, uint32 blockTimestamp) internal {
        uint32 deltaTime = blockTimestamp - res.blockTimestamp;
        // overflow is desired
        if (deltaTime != 0) {
            unchecked {
                res.cumulativeRisky += uint256(res.reserveRisky) * deltaTime;
                res.cumulativeStable += uint256(res.reserveStable) * deltaTime;
                res.cumulativeLiquidity += uint256(res.liquidity) * deltaTime;
            }
            res.blockTimestamp = blockTimestamp;
        }
    }

    /// @notice                 Increases one reserve value and decreases the other
    /// @param  reserve         Reserve state to update
    /// @param  riskyForStable  Direction of swap
    /// @param  deltaIn         Amount of tokens paid, increases one reserve by
    /// @param  deltaOut        Amount of tokens sent out, decreases the other reserve by
    /// @param  blockTimestamp  Timestamp used to update cumulative reserves
    function swap(
        Data storage reserve,
        bool riskyForStable,
        uint256 deltaIn,
        uint256 deltaOut,
        uint32 blockTimestamp
    ) internal {
        update(reserve, blockTimestamp);
        if (riskyForStable) {
            reserve.reserveRisky += deltaIn.toUint128();
            reserve.reserveStable -= deltaOut.toUint128();
        } else {
            reserve.reserveRisky -= deltaOut.toUint128();
            reserve.reserveStable += deltaIn.toUint128();
        }
    }

    /// @notice                 Add to both reserves and total supply of liquidity
    /// @param  reserve         Reserve storage to manipulate
    /// @param  delRisky        Amount of risky tokens to add to the reserve
    /// @param  delStable       Amount of stable tokens to add to the reserve
    /// @param  delLiquidity    Amount of liquidity created with the provided tokens
    /// @param  blockTimestamp  Timestamp used to update cumulative reserves
    function allocate(
        Data storage reserve,
        uint256 delRisky,
        uint256 delStable,
        uint256 delLiquidity,
        uint32 blockTimestamp
    ) internal {
        update(reserve, blockTimestamp);
        reserve.reserveRisky += delRisky.toUint128();
        reserve.reserveStable += delStable.toUint128();
        reserve.liquidity += delLiquidity.toUint128();
    }

    /// @notice                 Remove from both reserves and total supply of liquidity
    /// @param  reserve         Reserve storage to manipulate
    /// @param  delRisky        Amount of risky tokens to remove to the reserve
    /// @param  delStable       Amount of stable tokens to remove to the reserve
    /// @param  delLiquidity    Amount of liquidity removed from total supply
    /// @param  blockTimestamp  Timestamp used to update cumulative reserves
    function remove(
        Data storage reserve,
        uint256 delRisky,
        uint256 delStable,
        uint256 delLiquidity,
        uint32 blockTimestamp
    ) internal {
        update(reserve, blockTimestamp);
        reserve.reserveRisky -= delRisky.toUint128();
        reserve.reserveStable -= delStable.toUint128();
        reserve.liquidity -= delLiquidity.toUint128();
    }

    /// @notice                 Calculates risky and stable token amounts of `delLiquidity`
    /// @param reserve          Reserve in memory to use reserves and liquidity of
    /// @param delLiquidity     Amount of liquidity to fetch underlying tokens of
    /// @return delRisky        Amount of risky tokens controlled by `delLiquidity`
    /// @return delStable       Amount of stable tokens controlled by `delLiquidity`
    function getAmounts(Data memory reserve, uint256 delLiquidity)
        internal
        pure
        returns (uint256 delRisky, uint256 delStable)
    {
        uint256 liq = uint256(reserve.liquidity);
        delRisky = (delLiquidity * uint256(reserve.reserveRisky)) / liq;
        delStable = (delLiquidity * uint256(reserve.reserveStable)) / liq;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/test/libraries/TestReserve.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

/// @title   Reserve Lib API Test
/// @author  Primitive
/// @dev     For testing purposes ONLY

contract TestReserve {
    using Reserve for Reserve.Data;
    using Reserve for mapping(bytes32 => Reserve.Data);

    /// @notice Used for testing time
    uint256 public timestamp;
    /// @notice Storage slot for the reserveId used for testing
    bytes32 public reserveId;
    /// @notice All the reserve data structs to use for testing
    mapping(bytes32 => Reserve.Data) public reserves;

    constructor() {}

    /// @notice Used for testing
    function res() public view returns (Reserve.Data memory) {
        return reserves[reserveId];
    }

    /// @notice Called before each unit test to initialize a reserve to test
    function beforeEach(
        string memory name,
        uint256 timestamp_,
        uint256 reserveRisky,
        uint256 reserveStable
    ) public {
        timestamp = timestamp_; // set the starting time for this reserve
        bytes32 resId = keccak256(abi.encodePacked(name)); // get bytes32 id for name
        reserveId = resId; // set this resId in global state to easily fetch in test
        // create a new reserve data struct
        reserves[resId] = Reserve.Data({
            reserveRisky: uint128(reserveRisky), // risky token balance
            reserveStable: uint128(reserveStable), // stable token balance
            liquidity: uint128(2e18),
            blockTimestamp: uint32(timestamp_),
            cumulativeRisky: 0,
            cumulativeStable: 0,
            cumulativeLiquidity: 0
        });
    }

    /// @notice Used for time dependent tests
    function _blockTimestamp() public view returns (uint32 blockTimestamp) {
        blockTimestamp = uint32(timestamp);
    }

    /// @notice Increments the timestamp used for testing
    function step(uint256 timestep) public {
        timestamp += uint32(timestep);
    }

    /// @notice Adds amounts to cumulative reserves
    function shouldUpdate(bytes32 resId) public returns (Reserve.Data memory) {
        reserves[resId].update(_blockTimestamp());
        return reserves[resId];
    }

    /// @notice Increases one reserve value and decreases the other by different amounts
    function shouldSwap(
        bytes32 resId,
        bool addXRemoveY,
        uint256 deltaIn,
        uint256 deltaOut
    ) public returns (Reserve.Data memory) {
        reserves[resId].swap(addXRemoveY, deltaIn, deltaOut, _blockTimestamp());
        return reserves[resId];
    }

    /// @notice Add to both reserves and total supply of liquidity
    function shouldAllocate(
        bytes32 resId,
        uint256 delRisky,
        uint256 delStable,
        uint256 delLiquidity
    ) public returns (Reserve.Data memory) {
        reserves[resId].allocate(delRisky, delStable, delLiquidity, _blockTimestamp());
        return reserves[resId];
    }

    /// @notice Remove from both reserves and total supply of liquidity
    function shouldRemove(
        bytes32 resId,
        uint256 delRisky,
        uint256 delStable,
        uint256 delLiquidity
    ) public returns (Reserve.Data memory) {
        reserves[resId].remove(delRisky, delStable, delLiquidity, _blockTimestamp());
        return reserves[resId];
    }

    function update(
        bytes32 resId,
        uint256 risky,
        uint256 stable,
        uint256 liquidity,
        uint32 blockTimestamp
    ) public returns (Reserve.Data memory) {
        reserves[resId].cumulativeRisky = risky;
        reserves[resId].cumulativeStable = stable;
        reserves[resId].cumulativeLiquidity = liquidity;
        reserves[resId].blockTimestamp = blockTimestamp;
        return reserves[resId];
    }
}
