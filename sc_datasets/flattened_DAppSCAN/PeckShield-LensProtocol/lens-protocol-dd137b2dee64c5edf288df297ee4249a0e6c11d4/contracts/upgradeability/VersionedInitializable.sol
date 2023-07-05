// File: ../sc_datasets/DAppSCAN/PeckShield-LensProtocol/lens-protocol-dd137b2dee64c5edf288df297ee4249a0e6c11d4/contracts/libraries/Errors.sol

// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.8.10;

library Errors {
    error CannotInitImplementation();
    error Initialized();
    error SignatureExpired();
    error ZeroSpender();
    error SignatureInvalid();
    error NotOwnerOrApproved();
    error NotHub();
    error TokenDoesNotExist();
    error NotGovernance();
    error NotGovernanceOrEmergencyAdmin();
    error CallerNotWhitelistedModule();
    error CollectModuleNotWhitelisted();
    error FollowModuleNotWhitelisted();
    error ReferenceModuleNotWhitelisted();
    error ProfileCreatorNotWhitelisted();
    error NotProfileOwner();
    error NotProfileOwnerOrDispatcher();
    error PublicationDoesNotExist();
    error HandleTaken();
    error HandleLengthInvalid();
    error HandleContainsInvalidCharacters();
    error CallerNotFollowNFT();
    error CallerNotCollectNFT();
    error BlockNumberInvalid();
    error ArrayMismatch();

    // Module Errors
    error InitParamsInvalid();
    error ZeroCurrency();
    error CollectExpired();
    error FollowInvalid();
    error ModuleDataMismatch();
    error FollowNotApproved();
    error MintLimitExceeded();
    error CollectNotAllowed();

    // MultiState Errors
    error Paused();
    error PublishingPaused();
}

// File: ../sc_datasets/DAppSCAN/PeckShield-LensProtocol/lens-protocol-dd137b2dee64c5edf288df297ee4249a0e6c11d4/contracts/upgradeability/VersionedInitializable.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.10;

/**
 * @title VersionedInitializable
 *
 * @dev Helper contract to implement initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 *
 * This is slightly modified from [Aave's version.](https://github.com/aave/protocol-v2/blob/6a503eb0a897124d8b9d126c915ffdf3e88343a9/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol)
 *
 * @author Lens, inspired by Aave's implementation, which is in turn inspired by OpenZeppelin's
 * Initializable contract
 */
abstract contract VersionedInitializable {
    address private immutable originalImpl;

    /**
     * @dev Indicates that the contract has been initialized.
     */
    uint256 private lastInitializedRevision = 0;

    /**
     * @dev Modifier to use in the initializer function of a contract.
     */
    modifier initializer() {
        uint256 revision = getRevision();
        if (address(this) == originalImpl) revert Errors.CannotInitImplementation();
        if (revision <= lastInitializedRevision) revert Errors.Initialized();
        lastInitializedRevision = revision;
        _;
    }

    constructor() {
        originalImpl = address(this);
    }

    /**
     * @dev returns the revision number of the contract
     * Needs to be defined in the inherited class as a constant.
     **/
    function getRevision() internal pure virtual returns (uint256);
}
