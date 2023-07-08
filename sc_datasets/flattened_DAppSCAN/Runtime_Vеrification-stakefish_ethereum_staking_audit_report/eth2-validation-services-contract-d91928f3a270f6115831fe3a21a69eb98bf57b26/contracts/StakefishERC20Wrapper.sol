// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/interfaces/IStakefishServicesContract.sol

// Copyright (C) 2021 BITFISH LIMITED

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// SPDX-License-Identifier: GPL-3.0-only


pragma solidity ^0.8.0;

/// @notice Governs the life cycle of a single Eth2 validator with ETH provided by multiple stakers.
interface IStakefishServicesContract {
    /// @notice The life cycle of a services contract.
    enum State {
        NotInitialized,
        PreDeposit,
        PostDeposit,
        Withdrawn
    }

    /// @notice Emitted when a `spender` is set to allow the transfer of an `owner`'s deposit stake amount.
    /// `amount` is the new allownace.
    /// @dev Also emitted when {transferDepositFrom} is called.
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /// @notice Emitted when deposit stake amount is transferred.
    /// @param from The address of deposit stake owner.
    /// @param to The address of deposit stake beneficiary.
    /// @param amount The amount of transferred deposit stake.
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    /// @notice Emitted when a `spender` is set to allow withdrawal on behalf of a `owner`.
    /// `amount` is the new allowance.
    /// @dev Also emitted when {WithdrawFrom} is called.
    event WithdrawalApproval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /// @notice Emitted when `owner`'s ETH are withdrawan to `to`.
    /// @param owner The address of deposit stake owner.
    /// @param to The address of ETH beneficiary.
    /// @param amount The amount of deposit stake to be converted to ETH.
    /// @param value The amount of withdrawn ETH.
    event Withdrawal(
        address indexed owner,
        address indexed to,
        uint256 amount,
        uint256 value
    );

    /// @notice Emitted when 32 ETH is transferred to the eth2 deposit contract.
    /// @param pubkey A BLS12-381 public key.
    event ValidatorDeposited(
        bytes pubkey // 48 bytes
    );

    /// @notice Emitted when a validator exits and the operator settles the commission.
    /// @param timestamp The block timestamp when the operator services are ended.
    event ServiceEnd(
        uint256 timestamp
    );

    /// @notice Emitted when deposit to the services contract.
    /// @param from The address of the deposit stake owner.
    /// @param amount The accepted amount of ETH deposited into the services contract.
    event Deposit(
        address from,
        uint256 amount
    );

    /// @notice Updates the exit date of the validator.
    /// @dev The exit date should be in the range of uint64.
    /// @param newExitDate The new exit date should come before the previously specified exit date.
    function updateExitDate(uint64 newExitDate) external;

    /// @notice Submits a Phase 0 DepositData to the eth2 deposit contract.
    /// @dev The Keccak hash of the contract address and all submitted data should match the `_operatorDataCommitment`.
    /// Emits a {ValidatorDeposited} event.
    /// @param validatorPubKey A BLS12-381 public key.
    /// @param depositSignature A BLS12-381 signature.
    /// @param depositDataRoot The SHA-256 hash of the SSZ-encoded DepositData object.
    /// @param exitDate The expected exit date of the created validator
    function createValidator(
        bytes calldata validatorPubKey, // 48 bytes
        bytes calldata depositSignature, // 96 bytes
        bytes32 depositDataRoot,
        uint64 exitDate
    ) external;

    /// @notice Deposits `msg.value` of ETH.
    /// @dev If the balance of the contract exceeds 32 ETH, the excess will be sent
    /// back to `msg.sender`.
    /// Emits a {Deposit} event.
    function deposit() external payable returns (uint256 surplus);


    /// @notice Deposits `msg.value` of ETH on behalf of `depositor`.
    /// @dev If the balance of the contract exceeds 32 ETH, the excess will be sent
    /// back to `depositor`.
    /// Emits a {Deposit} event.
    function depositOnBehalfOf(address depositor) external payable returns (uint256 surplus);

    /// @notice Settles operator service commission and enable withdrawal.
    /// @dev It can be called by operator if the time has passed `_exitDate`.
    /// It can be called by any address if the time has passed `_exitDate + MAX_SECONDS_IN_EXIT_QUEUE`.
    /// Emits a {ServiceEnd} event.
    function endOperatorServices() external;

    /// @notice Withdraws all the ETH of `msg.sender`.
    /// @dev It can only be called when the contract state is not `PostDeposit`.
    /// Emits a {Withdrawal} event.
    function withdrawAll() external returns (uint256);

    /// @notice Withdraws the ETH of `msg.sender` which is corresponding to the `amount` of deposit stake.
    /// @dev It can only be called when the contract state is not `PostDeposit`.
    /// Emits a {Withdrawal} event.
    function withdraw(uint256 amount) external returns (uint256);

    /// @notice Withdraws the ETH of `msg.sender` which is corresponding to the `amount` of deposit stake to a specified address.
    /// @dev It can only be called when the contract state is not `PostDeposit`.
    /// Emits a {Withdrawal} event.
    function withdrawTo(uint256 amount, address payable beneficiary) external returns (uint256);

    /// @notice Sets `amount` as the allowance of `spender` over the caller's deposit stake.
    /// @dev Emits an {Approval} event.
    function approve(address spender, uint256 amount) external returns (bool);


    /// @notice Sets `amount` as the allowance of `spender` over the caller's deposit amount that can be withdrawn.
    /// @dev Emits an {WithdrawalApproval} event.
    function approveWithdrawal(address spender, uint256 amount) external;

    /// @notice Withdraws the ETH of `depositor` which is corresponding to the `amount` of deposit stake to a specified address.
    /// @dev Emits a {Withdrawal} event.
    /// Emits a {WithdrawalApproval} event indicating the updated allowance.
    function withdrawFrom(
        address depositor,
        address payable beneficiary,
        uint256 amount
    ) external returns (uint256);

    /// @notice Transfers `amount` deposit stake from caller to `to`.
    /// @dev Emits a {Transfer} event.
    function transferDeposit(address to, uint256 amount) external returns (bool);

    /// @notice Transfers `amount` deposit stake from `from` to `to`.
    /// @dev Emits a {Transfer} event.
    /// Emits an {Approval} event indicating the updated allowance.
    function transferDepositFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /// @notice Returns the remaining number of deposit stake that `spender` will be allowed to withdraw
    /// on behalf of `depositor` through {withdrawFrom}.
    function withdrawalAllowance(address depositor, address spender) external view returns (uint256);

    /// @notice Returns the operator service commission rate.
    function getCommissionRate() external view returns (uint256);

    /// @notice Returns the exit date of the validator.
    function getExitDate() external view returns (uint256);

    /// @notice Returns the state of the contract.
    function getState() external view returns (State);

    /// @notice Returns the address of operator.
    function getOperatorAddress() external view returns (address);

    /// @notice Returns the amount of deposit stake owned by `depositor`.
    function getDeposit(address depositor) external view returns (uint256);

    /// @notice Returns the total amount of deposit stake.
    function getTotalDeposits() external view returns (uint256);

    /// @notice Returns the remaining number of deposit stake that `spender` will be allowed to transfer
    /// on behalf of `depositor` through {transferDepositFrom}.
    function getAllowance(address owner, address spender) external view returns (uint256);

    /// @notice Returns the commitment which is the hash of the contract address and all inputs to the `createValidator` function.
    function getOperatorDataCommitment() external view returns (bytes32);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/libraries/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/libraries/Initializable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/utils/Initializable.sol

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/StakefishERC20Wrapper.sol

// Copyright (C) 2021 BITFISH LIMITED

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// SPDX-License-Identifier: GPL-3.0-only

pragma solidity 0.8.4;




contract StakefishERC20Wrapper is IERC20, ReentrancyGuard, Initializable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address payable private _serviceContract;
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    uint256 private constant DECIMALS = 18;

    event Mint(address indexed sender, address indexed to, uint256 amount);
    event Redeem(address indexed sender, address indexed to, uint256 amount);

    function initialize(
        string memory name_,
        string memory symbol_,
        address payable serviceContract
    ) public initializer {
        _name = name_;
        _symbol = symbol_;
        _serviceContract = serviceContract;
    }

    // Wrapper functions

    function mintTo(address to, uint256 amount) public nonReentrant {
        require(amount > 0, "Amount can't be 0");

        _mint(to, amount);

        bool success = IStakefishServicesContract(_serviceContract).transferDepositFrom(
            msg.sender,
            address(this),
            amount
        );
        require(success, "Transfer deposit failed");

        emit Mint(msg.sender, to, amount);
    }

    function mint(uint256 amount) external {
        mintTo(msg.sender, amount);
    }

    function redeemTo(address to, uint256 amount) public nonReentrant {
        require(amount > 0, "Amount can't be 0");

        _burn(msg.sender, amount);

        bool success = IStakefishServicesContract(_serviceContract).transferDeposit(
            to,
            amount
        );
        require(success, "Transfer deposit failed");

        emit Redeem(msg.sender, to, amount);
    }

    function redeem(uint256 amount) external {
        redeemTo(msg.sender, amount);
    }

    // ERC20 functions

    function transfer(address to, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        // It will revert if underflow
        _approve(from, msg.sender, currentAllowance - amount);
        _transfer(from, to, amount);
       
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
        return true;
    }

    function decimals() public pure returns (uint256) {
        return DECIMALS;
    }

    function name() public view returns (string memory) {
        return _name;    
    }

    function symbol() public view returns (string memory) {
        return _symbol;    
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view override returns (uint256) {
        return _balances[owner];
    } 

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(to != address(0), "Transfer to the zero address");

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(spender != address(0), "Approve to the zero address");
        
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _mint(address owner, uint256 amount) internal {
        require(owner != address(0), "Mint to the zero address");

        _totalSupply += amount;
        _balances[owner] += amount;

        emit Transfer(address(0), owner, amount);
    }

    function _burn(address owner, uint256 amount) internal {
        require(owner != address(0), "Burn from the zero address");

        _totalSupply -= amount;
        _balances[owner] -= amount;

        emit Transfer(owner, address(0), amount);
    }
}
