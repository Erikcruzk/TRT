// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/interfaces/IBlockReward.sol

pragma solidity 0.5.9;


interface IBlockReward {
    function initialize(address) external;
    function DELEGATORS_ALIQUOT() external view returns(uint256); // solhint-disable-line func-name-mixedcase
    function isRewarding() external view returns(bool);
    function isSnapshotting() external view returns(bool);
    function mintedTotally() external view returns(uint256);
    function mintedTotallyByBridge(address _bridge) external view returns(uint256);
}

// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/interfaces/IValidatorSet.sol

pragma solidity 0.5.9;


interface IValidatorSet {
    function initialize(
        address,
        address,
        address,
        address[] calldata,
        address[] calldata,
        bool
    ) external;
    function newValidatorSet() external returns(bool, uint256);
    function setStakingAddress(address, address) external;
    function blockRewardContract() external view returns(address);
    function changeRequestCount() external view returns(uint256);
    function emitInitiateChangeCallable() external view returns(bool);
    function getPendingValidators() external view returns(address[] memory);
    function getPreviousValidators() external view returns(address[] memory);
    function getValidators() external view returns(address[] memory);
    function isReportValidatorValid(address) external view returns(bool);
    function isValidator(address) external view returns(bool);
    function isValidatorBanned(address) external view returns(bool);
    function MAX_VALIDATORS() external view returns(uint256); // solhint-disable-line func-name-mixedcase
    function miningByStakingAddress(address) external view returns(address);
    function randomContract() external view returns(address);
    function stakingByMiningAddress(address) external view returns(address);
    function stakingContract() external view returns(address);
    function unremovableValidator() external view returns(address);
    function validatorIndex(address) external view returns(uint256);
    function validatorSetApplyBlock() external view returns(uint256);
}

// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/interfaces/IValidatorSetHBBFT.sol

pragma solidity 0.5.9;
pragma experimental ABIEncoderV2;


interface IValidatorSetHBBFT {
    function clearMaliceReported(address) external;
    function initializePublicKeys(bytes[] calldata) external;
    function savePublicKey(address, bytes calldata) external;
}

// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/interfaces/IStakingHBBFT.sol

pragma solidity 0.5.9;


interface IStakingHBBFT {
    function initialize(
        address,
        address[] calldata,
        uint256,
        uint256,
        bool
    ) external;
}

// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/interfaces/IRandomHBBFT.sol

pragma solidity 0.5.9;


interface IRandomHBBFT {
    function initialize(address) external;
}

// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/interfaces/ITxPermission.sol

pragma solidity 0.5.9;


interface ITxPermission {
    function initialize(address[] calldata, address) external;
}

// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/interfaces/ICertifier.sol

pragma solidity 0.5.9;


interface ICertifier {
    function initialize(address[] calldata, address) external;
}

// File: ../sc_datasets/DAppSCAN/PepperSec-POA-DPOS/posdao-contracts-fdaa685de851378b35741bdab986414dfd9042b1/contracts/InitializerHBBFT.sol

pragma solidity 0.5.9;
pragma experimental ABIEncoderV2;







contract InitializerHBBFT {
    constructor(
        address[] memory _contracts,
        address _owner,
        address[] memory _miningAddresses,
        address[] memory _stakingAddresses,
        bytes[] memory _publicKeys,
        bool _firstValidatorIsUnremovable, // must be `false` for production network
        uint256 _delegatorMinStake,
        uint256 _candidateMinStake,
        bool _erc20Restricted
    ) public {
        IValidatorSet(_contracts[0]).initialize(
            _contracts[1], // _blockRewardContract
            _contracts[2], // _randomContract
            _contracts[3], // _stakingContract
            _miningAddresses,
            _stakingAddresses,
            _firstValidatorIsUnremovable
        );
        IValidatorSetHBBFT(_contracts[0]).initializePublicKeys(
            _publicKeys
        );
        IStakingHBBFT(_contracts[3]).initialize(
            _contracts[0], // _validatorSetContract
            _stakingAddresses,
            _delegatorMinStake,
            _candidateMinStake,
            _erc20Restricted
        );
        IBlockReward(_contracts[1]).initialize(_contracts[0]);
        IRandomHBBFT(_contracts[2]).initialize(_contracts[0]);
        address[] memory permittedAddresses = new address[](1);
        permittedAddresses[0] = _owner;
        ITxPermission(_contracts[4]).initialize(permittedAddresses, _contracts[0]);
        ICertifier(_contracts[5]).initialize(permittedAddresses, _contracts[0]);
        selfdestruct(msg.sender);
    }
}
