// File: ../sc_datasets/DAppSCAN/Quantstamp-Cryptex Finance/contracts-master/contracts/optimism/iOVM_CrossDomainMessenger.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
pragma experimental ABIEncoderV2;

/**
 * @title iOVM_CrossDomainMessenger
 */
interface iOVM_CrossDomainMessenger {

	/**********
	 * Events *
	 **********/

	event SentMessage(bytes message);
	event RelayedMessage(bytes32 msgHash);
	event FailedRelayedMessage(bytes32 msgHash);


	/*************
	 * Variables *
	 *************/

	function xDomainMessageSender() external view returns (address);


	/********************
	 * Public Functions *
	 ********************/

	/**
	 * Sends a cross domain message to the target messenger.
	 * @param _target Target contract address.
	 * @param _message Message to send to the target.
	 * @param _gasLimit Gas limit for the provided message.
	 */
	function sendMessage(
		address _target,
		bytes calldata _message,
		uint32 _gasLimit
	) external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Cryptex Finance/contracts-master/contracts/optimism/iOVM_L2CrossDomainMessenger.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
pragma experimental ABIEncoderV2;

/* Interface Imports */

/**
 * @title iOVM_L2CrossDomainMessenger
 */
interface iOVM_L2CrossDomainMessenger is iOVM_CrossDomainMessenger {

	/********************
	 * Public Functions *
	 ********************/

	/**
	 * Relays a cross domain message to a contract.
	 * @param _target Target contract address.
	 * @param _sender Message sender address.
	 * @param _message Message to send to the target.
	 * @param _messageNonce Nonce for the provided message.
	 */
	function relayMessage(
		address _target,
		address _sender,
		bytes memory _message,
		uint256 _messageNonce
	) external;
}
