// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/Identity.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

interface Identity {
    /*
      Allows a caller, typically another contract,
      to ensure that the provided address is of the expected type and version.
    */
    function identify() external pure returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/SubContractor.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

interface SubContractor is Identity {
    function initialize(bytes calldata data) external;

    function initializerSize() external view returns (uint256);

    /*
      Returns an array with selectors for validation.
      These selectors are the critical ones for maintaining self custody and anti censorship.
      During the upgrade process, as part of the sub-contract validation, the MainDispatcher
      validates that the selectos are mapped to the correct sub-contract.
    */
    function validatedSelectors() external pure returns (bytes4[] memory);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/IDispatcherBase.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Interface for a generic dispatcher to use, which the concrete dispatcher must implement.
  It contains the functions that are specific to the concrete dispatcher instance.
  The interface is implemented as contract, because interface implies all methods external.
*/
abstract contract IDispatcherBase {
    function getSubContract(bytes4 selector) public view virtual returns (address);

    function setSubContractAddress(uint256 index, address subContract) internal virtual;

    function getNumSubcontracts() internal pure virtual returns (uint256);

    function validateSubContractIndex(uint256 index, address subContract) internal pure virtual;

    /*
      Ensures initializer can be called. Reverts otherwise.
    */
    function initializationSentinel() internal view virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/BlockDirectCall.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  This contract provides means to block direct call of an external function.
  A derived contract (e.g. MainDispatcherBase) should decorate sensitive functions with the
  notCalledDirectly modifier, thereby preventing it from being called directly, and allowing only calling
  using delegate_call.
*/
abstract contract BlockDirectCall {
    address immutable this_;

    constructor() internal {
        this_ = address(this);
    }

    modifier notCalledDirectly() {
        require(this_ != address(this), "DIRECT_CALL_DISALLOWED");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/libraries/Common.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Common Utility librarries.
  I. Addresses (extending address).
*/
library Addresses {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function performEthTransfer(address recipient, uint256 amount) internal {
        (bool success, ) = recipient.call{value: amount}(""); // NOLINT: low-level-calls.
        require(success, "ETH_TRANSFER_FAILED");
    }

    /*
      Safe wrapper around ERC20/ERC721 calls.
      This is required because many deployed ERC20 contracts don't return a value.
      See https://github.com/ethereum/solidity/issues/4116.
    */
    function safeTokenContractCall(address tokenAddress, bytes memory callData) internal {
        require(isContract(tokenAddress), "BAD_TOKEN_ADDRESS");
        // NOLINTNEXTLINE: low-level-calls.
        (bool success, bytes memory returndata) = tokenAddress.call(callData);
        require(success, string(returndata));

        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "TOKEN_OPERATION_FAILED");
        }
    }

    /*
      Validates that the passed contract address is of a real contract,
      and that its id hash (as infered fromn identify()) matched the expected one.
    */
    function validateContractId(address contractAddress, bytes32 expectedIdHash) internal {
        require(isContract(contractAddress), "ADDRESS_NOT_CONTRACT");
        (bool success, bytes memory returndata) = contractAddress.call( // NOLINT: low-level-calls.
            abi.encodeWithSignature("identify()")
        );
        require(success, "FAILED_TO_IDENTIFY_CONTRACT");
        string memory realContractId = abi.decode(returndata, (string));
        require(
            keccak256(abi.encodePacked(realContractId)) == expectedIdHash,
            "UNEXPECTED_CONTRACT_IDENTIFIER"
        );
    }
}

/*
  II. StarkExTypes - Common data types.
*/
library StarkExTypes {
    // Structure representing a list of verifiers (validity/availability).
    // A statement is valid only if all the verifiers in the list agree on it.
    // Adding a verifier to the list is immediate - this is used for fast resolution of
    // any soundness issues.
    // Removing from the list is time-locked, to ensure that any user of the system
    // not content with the announced removal has ample time to leave the system before it is
    // removed.
    struct ApprovalChainData {
        address[] list;
        // Represents the time after which the verifier with the given address can be removed.
        // Removal of the verifier with address A is allowed only in the case the value
        // of unlockedForRemovalTime[A] != 0 and unlockedForRemovalTime[A] < (current time).
        mapping(address => uint256) unlockedForRemovalTime;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MainDispatcherBase.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;




abstract contract MainDispatcherBase is IDispatcherBase, BlockDirectCall {
    using Addresses for address;

    /*
      This entry point serves only transactions with empty calldata. (i.e. pure value transfer tx).
      We don't expect to receive such, thus block them.
    */
    receive() external payable {
        revert("CONTRACT_NOT_EXPECTED_TO_RECEIVE");
    }

    fallback() external payable {
        address subContractAddress = getSubContract(msg.sig);
        require(subContractAddress != address(0x0), "NO_CONTRACT_FOR_FUNCTION");

        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 for now, as we don"t know the out size yet.
            let result := delegatecall(gas(), subContractAddress, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    /*
      1. Extract subcontracts.
      2. Verify correct sub-contract initializer size.
      3. Extract sub-contract initializer data.
      4. Call sub-contract initializer.

      The init data bytes passed to initialize are structed as following:
      I. N slots (uin256 size) addresses of the deployed sub-contracts.
      II. An address of an external initialization contract (optional, or ZERO_ADDRESS).
      III. (Up to) N bytes sections of the sub-contracts initializers.

      If already initialized (i.e. upgrade) we expect the init data to be consistent with this.
      and if a different size of init data is expected when upgrading, the initializerSize should
      reflect this.

      If an external initializer contract is not used, ZERO_ADDRESS is passed in its slot.
      If the external initializer contract is used, all the remaining init data is passed to it,
      and internal initialization will not occur.

      External Initialization Contract
      --------------------------------
      External Initialization Contract (EIC) is a hook for custom initialization.
      Typically in an upgrade flow, the expected initialization contains only the addresses of
      the sub-contracts. Normal initialization of the sub-contracts is such that is not needed
      in an upgrade, and actually may be very dangerous, as changing of state on a working system
      may corrupt it.

      In the event that some state initialization is required, the EIC is a hook that allows this.
      It may be deployed and called specifically for this purpose.

      The address of the EIC must be provided (if at all) when a new implementation is added to
      a Proxy contract (as part of the initialization vector).
      Hence, it is considered part of the code open to reviewers prior to a time-locked upgrade.

      When a custom initialization is performed using an EIC,
      the main dispatcher initialize extracts and stores the sub-contracts addresses, and then
      yields to the EIC, skipping the rest of its initialization code.


      Flow of MainDispatcher initialize
      ---------------------------------
      1. Extraction and assignment of subcontracts addresses
         Main dispatcher expects a valid and consistent set of addresses in the passed data.
         It validates that, extracts the addresses from the data, and validates that the addresses
         are of the expected type and order. Then those addresses are stored.

      2. Extraction of EIC address
         The address of the EIC is extracted from the data.
         External Initializer Contract is optional. ZERO_ADDRESS indicates it is not used.

      3a. EIC is used
          Dispatcher calls the EIC initialize function with the remaining data.
          Note - In this option 3b is not performed.

      3b. EIC is not used
          If there is additional initialization data then:
          I. Sentitenl function is called to permit subcontracts initialization.
          II. Dispatcher loops through the subcontracts and for each one it extracts the
              initializing data and passes it to the subcontract's initialize function.

    */
    function initialize(bytes calldata data) external virtual notCalledDirectly {
        // Number of sub-contracts.
        uint256 nSubContracts = getNumSubcontracts();

        // We support currently 4 bits per contract, i.e. 16, reserving 00 leads to 15.
        require(nSubContracts <= 15, "TOO_MANY_SUB_CONTRACTS");

        // Sum of subcontract initializers. Aggregated for verification near the end.
        uint256 totalInitSizes = 0;

        // Offset (within data) of sub-contract initializer vector.
        // Just past the sub-contract+eic addresses.
        uint256 initDataContractsOffset = 32 * (nSubContracts + 1);

        // Init data MUST include addresses for all sub-contracts + EIC.
        require(data.length >= initDataContractsOffset, "SUB_CONTRACTS_NOT_PROVIDED");

        // Size of passed data, excluding sub-contract addresses.
        uint256 additionalDataSize = data.length - initDataContractsOffset;

        // Extract & update contract addresses.
        for (uint256 nContract = 1; nContract <= nSubContracts; nContract++) {
            // Extract sub-contract address.
            address contractAddress = abi.decode(
                data[32 * (nContract - 1):32 * nContract],
                (address)
            );

            validateSubContractIndex(nContract, contractAddress);

            // Contracts are indexed from 1 and 0 is not in use here.
            setSubContractAddress(nContract, contractAddress);
        }

        // Check if we have an external initializer contract.
        address externalInitializerAddr = abi.decode(
            data[initDataContractsOffset - 32:initDataContractsOffset],
            (address)
        );

        // 3(a). Yield to EIC initialization.
        if (externalInitializerAddr != address(0x0)) {
            callExternalInitializer(externalInitializerAddr, data[initDataContractsOffset:]);
            return;
        }

        // 3(b). Subcontracts initialization.
        // I. If no init data passed besides sub-contracts, return.
        if (additionalDataSize == 0) {
            return;
        }

        // Just to be on the safe side.
        assert(externalInitializerAddr == address(0x0));

        // II. Gate further initialization.
        initializationSentinel();

        // III. Loops through the subcontracts, extracts their data and calls their initializer.
        for (uint256 nContract = 1; nContract <= nSubContracts; nContract++) {
            // Extract sub-contract address.
            address contractAddress = abi.decode(
                data[32 * (nContract - 1):32 * nContract],
                (address)
            );

            // The initializerSize is called via delegatecall, so that it can relate to the state,
            // and not only to the new contract code. (e.g. return 0 if state-intialized else 192).
            // NOLINTNEXTLINE: controlled-delegatecall low-level-calls calls-loop.
            (bool success, bytes memory returndata) = contractAddress.delegatecall(
                abi.encodeWithSelector(SubContractor(contractAddress).initializerSize.selector)
            );
            require(success, string(returndata));
            uint256 initSize = abi.decode(returndata, (uint256));
            require(initSize <= additionalDataSize, "INVALID_INITIALIZER_SIZE");
            require(totalInitSizes + initSize <= additionalDataSize, "INVALID_INITIALIZER_SIZE");

            if (initSize == 0) {
                continue;
            }

            // Call sub-contract initializer.
            // NOLINTNEXTLINE: controlled-delegatecall calls-loop.
            (success, returndata) = contractAddress.delegatecall(
                abi.encodeWithSelector(
                    this.initialize.selector,
                    data[initDataContractsOffset:initDataContractsOffset + initSize]
                )
            );
            require(success, string(returndata));
            totalInitSizes += initSize;
            initDataContractsOffset += initSize;
        }
        require(additionalDataSize == totalInitSizes, "MISMATCHING_INIT_DATA_SIZE");
    }

    function callExternalInitializer(address externalInitializerAddr, bytes calldata extInitData)
        private
    {
        require(externalInitializerAddr.isContract(), "NOT_A_CONTRACT");

        // NOLINTNEXTLINE: low-level-calls, controlled-delegatecall.
        (bool success, bytes memory returndata) = externalInitializerAddr.delegatecall(
            abi.encodeWithSelector(this.initialize.selector, extInitData)
        );
        require(success, string(returndata));
        require(returndata.length == 0, string(returndata));
    }
}