// File: ../sc_datasets/DAppSCAN/Quantstamp-RariCapital V2/rari-stable-pool-contracts-7f351ca3df72a0196f3640f30a6db73660ab1467/contracts/external/dydx/lib/Account.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

/**
 * @title Account
 * @author dYdX
 *
 * Library of structs and functions that represent an account
 */
library Account {
    // Represents the unique key that specifies an account
    struct Info {
        address owner;  // The address that owns the account
        uint256 number; // A nonce that allows a single address to control many accounts
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-RariCapital V2/rari-stable-pool-contracts-7f351ca3df72a0196f3640f30a6db73660ab1467/contracts/external/dydx/lib/Types.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

/**
 * @title Types
 * @author dYdX
 *
 * Library for interacting with the basic structs used in Solo
 */
library Types {
    // ============ AssetAmount ============

    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par  // the amount is denominated in par
    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at
    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }

    // ============ Par (Principal Amount) ============

    // Individual principal amount for an account
    struct Par {
        bool sign; // true if positive
        uint128 value;
    }

    // ============ Wei (Token Amount) ============

    // Individual token amount for an account
    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-RariCapital V2/rari-stable-pool-contracts-7f351ca3df72a0196f3640f30a6db73660ab1467/contracts/external/dydx/Getters.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;


/**
 * @title Getters
 * @author dYdX
 *
 * Public read-only functions that allow transparency into the state of Solo
 */
contract Getters {
    using Types for Types.Par;

    /**
     * Get an account's summary for each market.
     *
     * @param  account  The account to query
     * @return          The following values:
     *                   - The ERC20 token address for each market
     *                   - The account's principal value for each market
     *                   - The account's (supplied or borrowed) number of tokens for each market
     */
    function getAccountBalances(
        Account.Info memory account
    )
        public
        view
        returns (
            address[] memory,
            Types.Par[] memory,
            Types.Wei[] memory
        );
}
