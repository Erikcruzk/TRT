// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MGovernance.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

struct GovernanceInfoStruct {
    mapping(address => bool) effectiveGovernors;
    address candidateGovernor;
    bool initialized;
}

abstract contract MGovernance {
    function _isGovernor(address testGovernor) internal view virtual returns (bool);

    /*
      Allows calling the function only by a Governor.
    */
    modifier onlyGovernance() {
        require(_isGovernor(msg.sender), "ONLY_GOVERNANCE");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/Governance.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Implements Generic Governance, applicable for both proxy and main contract, and possibly others.
  Notes:
   The use of the same function names by both the Proxy and a delegated implementation
   is not possible since calling the implementation functions is done via the default function
   of the Proxy. For this reason, for example, the implementation of MainContract (MainGovernance)
   exposes mainIsGovernor, which calls the internal _isGovernor method.
*/
abstract contract Governance is MGovernance {
    event LogNominatedGovernor(address nominatedGovernor);
    event LogNewGovernorAccepted(address acceptedGovernor);
    event LogRemovedGovernor(address removedGovernor);
    event LogNominationCancelled();

    function getGovernanceInfo() internal view virtual returns (GovernanceInfoStruct storage);

    /*
      Current code intentionally prevents governance re-initialization.
      This may be a problem in an upgrade situation, in a case that the upgrade-to implementation
      performs an initialization (for real) and within that calls initGovernance().

      Possible workarounds:
      1. Clearing the governance info altogether by changing the MAIN_GOVERNANCE_INFO_TAG.
         This will remove existing main governance information.
      2. Modify the require part in this function, so that it will exit quietly
         when trying to re-initialize (uncomment the lines below).
    */
    function initGovernance() internal {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(!gub.initialized, "ALREADY_INITIALIZED");
        gub.initialized = true; // to ensure addGovernor() won't fail.
        // Add the initial governer.
        addGovernor(msg.sender);
    }

    function _isGovernor(address testGovernor) internal view override returns (bool) {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        return gub.effectiveGovernors[testGovernor];
    }

    /*
      Cancels the nomination of a governor candidate.
    */
    function _cancelNomination() internal onlyGovernance {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        gub.candidateGovernor = address(0x0);
        emit LogNominationCancelled();
    }

    function _nominateNewGovernor(address newGovernor) internal onlyGovernance {
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(!_isGovernor(newGovernor), "ALREADY_GOVERNOR");
        gub.candidateGovernor = newGovernor;
        emit LogNominatedGovernor(newGovernor);
    }

    /*
      The addGovernor is called in two cases:
      1. by _acceptGovernance when a new governor accepts its role.
      2. by initGovernance to add the initial governor.
      The difference is that the init path skips the nominate step
      that would fail because of the onlyGovernance modifier.
    */
    function addGovernor(address newGovernor) private {
        require(!_isGovernor(newGovernor), "ALREADY_GOVERNOR");
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        gub.effectiveGovernors[newGovernor] = true;
    }

    function _acceptGovernance() internal {
        // The new governor was proposed as a candidate by the current governor.
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(msg.sender == gub.candidateGovernor, "ONLY_CANDIDATE_GOVERNOR");

        // Update state.
        addGovernor(gub.candidateGovernor);
        gub.candidateGovernor = address(0x0);

        // Send a notification about the change of governor.
        emit LogNewGovernorAccepted(msg.sender);
    }

    /*
      Remove a governor from office.
    */
    function _removeGovernor(address governorForRemoval) internal onlyGovernance {
        require(msg.sender != governorForRemoval, "GOVERNOR_SELF_REMOVE");
        GovernanceInfoStruct storage gub = getGovernanceInfo();
        require(_isGovernor(governorForRemoval), "NOT_GOVERNOR");
        gub.effectiveGovernors[governorForRemoval] = false;
        emit LogRemovedGovernor(governorForRemoval);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/GovernanceStorage.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Holds the governance slots for ALL entities, including proxy and the main contract.
*/
contract GovernanceStorage {
    // A map from a Governor tag to its own GovernanceInfoStruct.
    mapping(string => GovernanceInfoStruct) internal governanceInfo; //NOLINT uninitialized-state.
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/MainGovernance.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


/**
  The StarkEx contract is governed by one or more Governors of which the initial one is the
  deployer of the contract.

  A governor has the sole authority to perform the following operations:

  1. Nominate additional governors (:sol:func:`mainNominateNewGovernor`)
  2. Remove other governors (:sol:func:`mainRemoveGovernor`)
  3. Add new :sol:mod:`Verifiers` and :sol:mod:`AvailabilityVerifiers`
  4. Remove :sol:mod:`Verifiers` and :sol:mod:`AvailabilityVerifiers` after a timelock allows it
  5. Nominate Operators (see :sol:mod:`Operator`) and Token Administrators (see :sol:mod:`TokenRegister`)

  Adding governors is performed in a two step procedure:

  1. First, an existing governor nominates a new governor (:sol:func:`mainNominateNewGovernor`)
  2. Then, the new governor must accept governance to become a governor (:sol:func:`mainAcceptGovernance`)

  This two step procedure ensures that a governor public key cannot be nominated unless there is an
  entity that has the corresponding private key. This is intended to prevent errors in the addition
  process.

  The governor private key should typically be held in a secure cold wallet.
*/
/*
  Implements Governance for the StarkDex main contract.
  The wrapper methods (e.g. mainIsGovernor wrapping _isGovernor) are needed to give
  the method unique names.
  Both Proxy and StarkExchange inherit from Governance. Thus, the logical contract method names
  must have unique names in order for the proxy to successfully delegate to them.
*/
contract MainGovernance is GovernanceStorage, Governance {
    // The tag is the sting key that is used in the Governance storage mapping.
    string public constant MAIN_GOVERNANCE_INFO_TAG = "StarkEx.Main.2019.GovernorsInformation";

    /*
      Returns the GovernanceInfoStruct associated with the governance tag.
    */
    function getGovernanceInfo() internal view override returns (GovernanceInfoStruct storage) {
        return governanceInfo[MAIN_GOVERNANCE_INFO_TAG];
    }

    function mainIsGovernor(address testGovernor) external view returns (bool) {
        return _isGovernor(testGovernor);
    }

    function mainNominateNewGovernor(address newGovernor) external {
        _nominateNewGovernor(newGovernor);
    }

    function mainRemoveGovernor(address governorForRemoval) external {
        _removeGovernor(governorForRemoval);
    }

    function mainAcceptGovernance() external {
        _acceptGovernance();
    }

    function mainCancelNomination() external {
        _cancelNomination();
    }
}
