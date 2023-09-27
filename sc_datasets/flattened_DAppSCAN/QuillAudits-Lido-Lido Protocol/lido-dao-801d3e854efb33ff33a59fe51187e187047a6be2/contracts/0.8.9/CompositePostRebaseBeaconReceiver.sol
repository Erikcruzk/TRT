// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido Protocol/lido-dao-801d3e854efb33ff33a59fe51187e187047a6be2/contracts/0.8.9/interfaces/IOrderedCallbacksArray.sol

// SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

/**
  * @title Interface defining an ordered callbacks array supporting add/insert/remove ops
  */
interface IOrderedCallbacksArray {
    /**
      * @notice Callback added event
      *
      * @dev emitted by `addCallback` and `insertCallback` functions
      */
    event CallbackAdded(address indexed callback, uint256 atIndex);

    /**
      * @notice Callback removed event
      *
      * @dev emitted by `removeCallback` function
      */
    event CallbackRemoved(address indexed callback, uint256 atIndex);

    /**
      * @notice Callback length
      * @return Added callbacks count
      */
    function callbacksLength() external view returns (uint256);

    /**
      * @notice Add a `_callback` to the back of array
      * @param _callback callback address
      *
      * @dev cheapest way to insert new item (doesn't incur additional moves)
      */
    function addCallback(address _callback) external;

    /**
      * @notice Insert a `_callback` at the given `_atIndex` position
      * @param _callback callback address
      * @param _atIndex callback insert position
      *
      * @dev insertion gas cost is higher for the lower `_atIndex` values
      */
    function insertCallback(address _callback, uint256 _atIndex) external;

    /**
      * @notice Remove a callback at the given `_atIndex` position
      * @param _atIndex callback remove position
      *
      * @dev remove gas cost is higher for the lower `_atIndex` values
      */
    function removeCallback(uint256 _atIndex) external;

    /**
      * @notice Get callback at position
      * @return Callback at the given `_atIndex`
      *
      * @dev function reverts if `_atIndex` is out of range
      */
    function callbacks(uint256 _atIndex) external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido Protocol/lido-dao-801d3e854efb33ff33a59fe51187e187047a6be2/contracts/0.8.9/OrderedCallbacksArray.sol

// SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>

// SPDX-License-Identifier: GPL-3.0

/* See contracts/COMPILERS.md */
pragma solidity 0.8.9;

/**
  * @title Contract defining an ordered callbacks array supporting add/insert/remove ops
  *
  * Contract adds permission modifiers ontop of `IOderedCallbacksArray` interface functions.
  * Only the `VOTING` address can invoke storage mutating (add/insert/remove) functions.
  */
contract OrderedCallbacksArray is IOrderedCallbacksArray {
    uint256 public constant MAX_CALLBACKS_COUNT = 16;

    address public immutable VOTING;

    address[] public callbacks;

    modifier onlyVoting() {
        require(msg.sender == VOTING, "MSG_SENDER_MUST_BE_VOTING");
        _;
    }

    constructor(address _voting) {
        require(_voting != address(0), "VOTING_ZERO_ADDRESS");

        VOTING = _voting;
    }

    function callbacksLength() public view override returns (uint256) {
        return callbacks.length;
    }

    function addCallback(address _callback) external override onlyVoting {
        _insertCallback(_callback, callbacks.length);
    }

    function insertCallback(address _callback, uint256 _atIndex) external override onlyVoting {
        _insertCallback(_callback, _atIndex);
    }

    function removeCallback(uint256 _atIndex) external override onlyVoting {
        uint256 oldCArrayLength = callbacks.length;
        require(_atIndex < oldCArrayLength, "INDEX_IS_OUT_OF_RANGE");

        emit CallbackRemoved(callbacks[_atIndex], _atIndex);

        for (uint256 cIndex = _atIndex; cIndex < oldCArrayLength-1; cIndex++) {
            callbacks[cIndex] = callbacks[cIndex+1];
        }

        callbacks.pop();
    }

    function _insertCallback(address _callback, uint256 _atIndex) private {
        require(_callback != address(0), "CALLBACK_ZERO_ADDRESS");

        uint256 oldCArrayLength = callbacks.length;
        require(_atIndex <= oldCArrayLength, "INDEX_IS_OUT_OF_RANGE");
        require(oldCArrayLength < MAX_CALLBACKS_COUNT, "MAX_CALLBACKS_COUNT_EXCEEDED");

        emit CallbackAdded(_callback, _atIndex);

        callbacks.push();

        if (oldCArrayLength > 0) {
            for (uint256 cIndex = oldCArrayLength; cIndex > _atIndex; cIndex--) {
                callbacks[cIndex] = callbacks[cIndex-1];
            }
        }

        callbacks[_atIndex] = _callback;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido Protocol/lido-dao-801d3e854efb33ff33a59fe51187e187047a6be2/contracts/0.8.9/interfaces/IBeaconReportReceiver.sol

// SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

/**
  * @title Interface defining a callback that the quorum will call on every quorum reached
  */
interface IBeaconReportReceiver {
    /**
      * @notice Callback to be called by the oracle contract upon the quorum is reached
      * @param _postTotalPooledEther total pooled ether on Lido right after the quorum value was reported
      * @param _preTotalPooledEther total pooled ether on Lido right before the quorum value was reported
      * @param _timeElapsed time elapsed in seconds between the last and the previous quorum
      */
    function processLidoOracleReport(uint256 _postTotalPooledEther,
                                     uint256 _preTotalPooledEther,
                                     uint256 _timeElapsed) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido Protocol/lido-dao-801d3e854efb33ff33a59fe51187e187047a6be2/contracts/0.8.9/CompositePostRebaseBeaconReceiver.sol

// SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>

// SPDX-License-Identifier: GPL-3.0

/* See contracts/COMPILERS.md */
pragma solidity 0.8.9;


/**
  * @title Contract defining an composite post-rebase beacon receiver for the Lido oracle
  *
  * Contract adds permission modifiers.
  * Only the `ORACLE` address can invoke `processLidoOracleReport` function.
  */
contract CompositePostRebaseBeaconReceiver is OrderedCallbacksArray, IBeaconReportReceiver {
    address public immutable ORACLE;

    modifier onlyOracle() {
        require(msg.sender == ORACLE, "MSG_SENDER_MUST_BE_ORACLE");
        _;
    }

    constructor(
        address _voting,
        address _oracle
    ) OrderedCallbacksArray(_voting) {
        require(_oracle != address(0), "ORACLE_ZERO_ADDRESS");

        ORACLE = _oracle;
    }

    function processLidoOracleReport(
        uint256 _postTotalPooledEther,
        uint256 _preTotalPooledEther,
        uint256 _timeElapsed
    ) external override onlyOracle {
        uint256 callbacksLen = callbacksLength();

        for (uint256 brIndex = 0; brIndex < callbacksLen; brIndex++) {
            IBeaconReportReceiver(callbacks[brIndex])
                .processLidoOracleReport(
                    _postTotalPooledEther,
                    _preTotalPooledEther,
                    _timeElapsed
                );
        }
    }
}