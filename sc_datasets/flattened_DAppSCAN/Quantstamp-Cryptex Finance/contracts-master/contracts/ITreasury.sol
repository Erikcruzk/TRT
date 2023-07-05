// File: ../sc_datasets/DAppSCAN/Quantstamp-Cryptex Finance/contracts-master/contracts/Proprietor.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.7.5;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Proprietor {
	address public owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/**
	 * @dev Initializes the contract setting the deployer as the initial owner.
     */
	constructor (address _owner) {
		require(_owner != address(0), "Proprietor::constructor: address can't be zero");
		owner = _owner;
		emit OwnershipTransferred(address(0), owner);
	}

	/**
	 * @dev Throws if called by any account other than the owner.
     */
	modifier onlyOwner() virtual {
		require(owner == msg.sender, "Proprietor: caller is not the owner");
		_;
	}

	/**
	 * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
	function renounceOwnership() public virtual onlyOwner {
		emit OwnershipTransferred(owner, address(0));
		owner = address(0);
	}

	/**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
	function transferOwnership(address newOwner) public virtual onlyOwner {
		require(newOwner != address(0), "Proprietor: new owner is the zero address");
		emit OwnershipTransferred(owner, newOwner);
		owner = newOwner;
	}
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Cryptex Finance/contracts-master/contracts/ITreasury.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

/**
 * @title TCAP Treasury
 * @author Cryptex.finance
 * @notice This contract will hold the assets generated on L2 networks.
 */
contract ITreasury is Proprietor {
	/// @notice An event emitted when a transaction is executed
	event TransactionExecuted(
		address indexed target,
		uint256 value,
		string signature,
		bytes data
	);


	/**
	 * @notice Constructor
	 * @param _owner the owner of the contract
	 */
	constructor(address _owner) Proprietor(_owner) {}

	/**
	 * @notice Allows the owner to execute custom transactions
	 * @param target address
	 * @param value uint256
	 * @param signature string
	 * @param data bytes
	 * @dev Only owner can call it
	 */
	function executeTransaction(
		address target,
		uint256 value,
		string memory signature,
		bytes memory data
	) external payable onlyOwner returns (bytes memory) {
		bytes memory callData;
		if (bytes(signature).length == 0) {
			callData = data;
		} else {
			callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
		}

		require(
			target != address(0),
			"ITreasury::executeTransaction: target can't be zero"
		);

		// solium-disable-next-line security/no-call-value
		(bool success, bytes memory returnData) =
		target.call{value : value}(callData);
		require(
			success,
			"ITreasury::executeTransaction: Transaction execution reverted."
		);

		emit TransactionExecuted(target, value, signature, data);
		(target, value, signature, data);

		return returnData;
	}

	/**
	 * @notice Retrieves the eth stuck on the treasury
	 * @param _to address
	 * @dev Only owner can call it
	 */
	function retrieveETH(address _to) external onlyOwner {
		require(
			_to != address(0),
			"ITreasury::retrieveETH: address can't be zero"
		);
		uint256 amount = address(this).balance;
		payable(_to).transfer(amount);
	}

	/// @notice Allows the contract to receive ETH
	receive() external payable {}
}
