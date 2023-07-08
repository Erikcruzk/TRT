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

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido Protocol/lido-dao-801d3e854efb33ff33a59fe51187e187047a6be2/contracts/0.8.9/test_helpers/BeaconReceiverMock.sol

// SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>

// SPDX-License-Identifier: GPL-3.0

/* See contracts/COMPILERS.md */
pragma solidity 0.8.9;

/**
  * @title Mock helper for the `CompositePostRebaseBeaconReceiver` tests.
  *
  * @dev DON'T USE THIS CODE IN A PRODUCTION
  */
contract BeaconReceiverMock is IBeaconReportReceiver {
    uint256 public immutable id;
    uint256 public processedCounter;

    constructor(uint256 _id) {
        id = _id;
    }

    function processLidoOracleReport(uint256, uint256, uint256) external override {
        processedCounter++;
    }
}
