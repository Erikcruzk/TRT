// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

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
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_coordinape_v1.1_signed/coordinape-protocol-7a8e6173305696c72195fa4242126d284611270c/contracts/ApeProtocol/TimeLock.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.2;

contract TimeLock is Ownable {
	uint256 internal constant _DONE_TIMESTAMP = uint256(1);

	mapping(bytes32 => uint256) public timestamps;
	uint256 public minDelay;

	event CallScheduled(
        bytes32 indexed id,
        address target,
        bytes data,
        bytes32 predecessor,
        uint256 delay
    );

	event CallCancelled(bytes32 id);

	event CallExecuted(bytes32 indexed id, address target, bytes data);

	constructor(uint256 _minDelay) {
		minDelay = _minDelay;
	}


	modifier itself() {
		require(msg.sender == address(this), "TimeLock: Caller is not contract itself");
		_;
	}

	function changeMinDelay(uint256 _min) external itself {
		minDelay = _min;
	}

	function hashOperation(address _target, bytes calldata _data, bytes32 _predecessor, bytes32 _salt) internal pure returns(bytes32) {
		return keccak256(abi.encode(_target, _data, _predecessor, _salt));
	}

	function isPendingCall(bytes32 _id) public view returns(bool) {
		return timestamps[_id] > _DONE_TIMESTAMP;
	}

	function isDoneCall(bytes32 _id) public view returns(bool) {
		return timestamps[_id] == _DONE_TIMESTAMP;
	}

	function isReadyCall(bytes32 _id) public view returns(bool) {
		return timestamps[_id] <= block.timestamp;
	}

	function schedule(address _target, bytes calldata _data, bytes32 _predecessor, bytes32 _salt, uint256 _delay) external onlyOwner {
		bytes32 id = hashOperation(_target, _data, _predecessor, _salt);
		require(timestamps[id] == 0, "TimeLock: Call already scheduled");
		require(_delay >= minDelay, "TimeLock: Insufficient delay");
		timestamps[id] = block.timestamp + minDelay;
		emit CallScheduled(id, _target, _data, _predecessor, _delay);
	}

	function cancel(bytes32 _id) external onlyOwner {
		require(isPendingCall(_id), "TimeLock: Call is not pending");
		timestamps[_id] = 0;
		emit CallCancelled(_id);
	}

	function execute(address _target, bytes calldata _data, bytes32 _predecessor, bytes32 _salt, uint256 _delay) external onlyOwner {
		bytes32 id = hashOperation(_target, _data, _predecessor, _salt);
		require(isReadyCall(id), "TimeLock: Not ready for execution");
		require(!isDoneCall(id), "TimeLock: Already executed");
		require(_predecessor == bytes32(0) || isDoneCall(_predecessor), "TimeLock: Predecessor call not executed");
		_call(id, _target, _data);
		timestamps[id] = _DONE_TIMESTAMP;
	}

	function _call(
        bytes32 id,
        address target,
        bytes calldata data
    ) internal {
        (bool success, ) = target.call(data);
        require(success, "Timelock: underlying transaction reverted");

        emit CallExecuted(id, target, data);
    }

}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_coordinape_v1.1_signed/coordinape-protocol-7a8e6173305696c72195fa4242126d284611270c/contracts/ApeProtocol/FeeRegistry.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.2;

contract FeeRegistry is TimeLock(0){
	uint256 private constant _staticFee = 100; // 100 | MAX = 10000
	bool public on;

	function activateFee() external itself {
		on = true;
	}

	function shutdownFee() external itself {
		on = false;
	}

	function staticFee() external view returns(uint256) {
		if (!on)
			return 0;
		return _staticFee;
	}

	function getVariableFee(uint256 _yield, uint256 _tapTotal) external returns(uint256 variableFee) {
		if (!on)
			return 0;
		uint256 yieldRatio = _yield * 1000 / _tapTotal;
		uint256 baseFee = 100;
		if (yieldRatio >= 900)
			variableFee = baseFee;        // 1%     @ 90% profit
		else if (yieldRatio >= 800)
			variableFee = baseFee + 25;   // 1.25%  @ 80% profit
		else if (yieldRatio >= 700)
			variableFee = baseFee + 50;   // 1.50%  @ 70% profit
		else if (yieldRatio >= 600)
			variableFee = baseFee + 75;   // 1.75%  @ 60% profit
		else if (yieldRatio >= 500)
			variableFee = baseFee + 100;  // 2.00%  @ 80% profit
		else if (yieldRatio >= 400)
			variableFee = baseFee + 125;  // 2.25%  @ 80% profit
		else if (yieldRatio >= 300)
			variableFee = baseFee + 150;  // 2.50%  @ 80% profit
		else if (yieldRatio >= 200)
			variableFee = baseFee + 175;  // 2.75%  @ 80% profit
		else if (yieldRatio >= 100)
			variableFee = baseFee + 200;  // 3.00%  @ 80% profit
		else
			variableFee = baseFee + 250;  // 3.50%  @ 0% profit
	}
}
