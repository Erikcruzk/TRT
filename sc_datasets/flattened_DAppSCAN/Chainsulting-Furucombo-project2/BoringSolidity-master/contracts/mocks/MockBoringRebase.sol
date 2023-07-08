// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/libraries/BoringRebase.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Rebase {
    uint128 elastic;
    uint128 base;
}

/// @notice A rebasing library using overflow-/underflow-safe math.
library RebaseLibrary {
    /// @notice Calculates the base value in relationship to `elastic` and `total`.
    function toBase(
        Rebase memory total,
        uint256 elastic,
        bool roundUp
    ) internal pure returns (uint256 base) {
        if (total.elastic == 0) {
            base = elastic;
        } else {
            base = (elastic * total.base) / total.elastic;
            if (roundUp && (base * total.elastic) / total.base < elastic) {
                base++;
            }
        }
    }

    /// @notice Calculates the elastic value in relationship to `base` and `total`.
    function toElastic(
        Rebase memory total,
        uint256 base,
        bool roundUp
    ) internal pure returns (uint256 elastic) {
        if (total.base == 0) {
            elastic = base;
        } else {
            elastic = (base * total.elastic) / total.base;
            if (roundUp && (elastic * total.base) / total.elastic < base) {
                elastic++;
            }
        }
    }

    /// @notice Add `elastic` to `total` and doubles `total.base`.
    /// @return (Rebase) The new total.
    /// @return base in relationship to `elastic`.
    function add(
        Rebase memory total,
        uint256 elastic,
        bool roundUp
    ) internal pure returns (Rebase memory, uint256 base) {
        base = toBase(total, elastic, roundUp);
        total.elastic += uint128(elastic);
        total.base += uint128(base);
        return (total, base);
    }

    /// @notice Sub `base` from `total` and update `total.elastic`.
    /// @return (Rebase) The new total.
    /// @return elastic in relationship to `base`.
    function sub(
        Rebase memory total,
        uint256 base,
        bool roundUp
    ) internal pure returns (Rebase memory, uint256 elastic) {
        elastic = toElastic(total, base, roundUp);
        total.elastic -= uint128(elastic);
        total.base -= uint128(base);
        return (total, elastic);
    }

    /// @notice Add `elastic` and `base` to `total`.
    function add(
        Rebase memory total,
        uint256 elastic,
        uint256 base
    ) internal pure returns (Rebase memory) {
        total.elastic += uint128(elastic);
        total.base += uint128(base);
        return total;
    }

    /// @notice Subtract `elastic` and `base` to `total`.
    function sub(
        Rebase memory total,
        uint256 elastic,
        uint256 base
    ) internal pure returns (Rebase memory) {
        total.elastic -= uint128(elastic);
        total.base -= uint128(base);
        return total;
    }

    /// @notice Add `elastic` to `total` and update storage.
    /// @return newElastic Returns updated `elastic`.
    function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
        newElastic = total.elastic += uint128(elastic);
    }

    /// @notice Subtract `elastic` from `total` and update storage.
    /// @return newElastic Returns updated `elastic`.
    function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
        newElastic = total.elastic -= uint128(elastic);
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/mocks/MockBoringRebase.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockBoringRebase {
    using RebaseLibrary for Rebase;
    Rebase public total;

    function set(uint128 elastic, uint128 base) public {
        total.elastic = elastic;
        total.base = base;
    }

    function toBase(uint256 elastic, bool roundUp) public view returns (uint256 base) {
        base = total.toBase(elastic, roundUp);
    }

    function toElastic(uint256 base, bool roundUp) public view returns (uint256 elastic) {
        elastic = total.toElastic(base, roundUp);
    }

    function add(uint256 elastic, bool roundUp) public returns (uint256 base) {
        (total, base) = total.add(elastic, roundUp);
    }

    function sub(uint256 base, bool roundUp) public returns (uint256 elastic) {
        (total, elastic) = total.sub(base, roundUp);
    }

    function add2(uint256 base, uint256 elastic) public {
        total = total.add(base, elastic);
    }

    function sub2(uint256 base, uint256 elastic) public {
        total = total.sub(base, elastic);
    }

    function addElastic(uint256 elastic) public returns (uint256 newElastic) {
        newElastic = total.addElastic(elastic);
        require(newElastic == 150, "MockBoringRebase: test failed");
    }

    function subElastic(uint256 elastic) public returns (uint256 newElastic) {
        newElastic = total.subElastic(elastic);
        require(newElastic == 110, "MockBoringRebase: test failed");
    }
}
