// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IERC20 {
    function symbol() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);

    // Note this is non standard but nearly all ERC20 have exposed decimal functions
    function decimals() external view returns (uint8);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/interfaces/IERC20Permit.sol

// Forked from openzepplin
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit is IERC20 {
    /**
     * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
     * given `owner`'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/interfaces/IInterestToken.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IInterestToken is IERC20Permit {
    function mint(address _account, uint256 _amount) external;

    function burn(address _account, uint256 _amount) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/interfaces/ITranche.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;


interface ITranche is IERC20Permit {
    function deposit(uint256 _shares, address destination)
        external
        returns (uint256);

    function prefundedDeposit(address _destination) external returns (uint256);

    function withdrawPrincipal(uint256 _amount, address _destination)
        external
        returns (uint256);

    function withdrawInterest(uint256 _amount, address _destination)
        external
        returns (uint256);

    function interestToken() external view returns (IInterestToken);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/interfaces/IWETH.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 wad) external;

    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/libraries/Authorizable.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.7.0;

contract Authorizable {
    // This contract allows a flexible authorization scheme

    // The owner who can change authorization status
    address public owner;
    // A mapping from an address to its authorization status
    mapping(address => bool) public authorized;

    /// @dev We set the deployer to the owner
    constructor() {
        owner = msg.sender;
    }

    /// @dev This modifier checks if the msg.sender is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Sender not owner");
        _;
    }

    /// @dev This modifier checks if an address is authorized
    modifier onlyAuthorized() {
        require(isAuthorized(msg.sender), "Sender not Authorized");
        _;
    }

    /// @dev Returns true if an address is authorized
    /// @param who the address to check
    /// @return true if authorized false if not
    function isAuthorized(address who) public view returns (bool) {
        return authorized[who];
    }

    /// @dev Privileged function authorize an address
    /// @param who the address to authorize
    function authorize(address who) external onlyOwner() {
        _authorize(who);
    }

    /// @dev Privileged function to de authorize an address
    /// @param who The address to remove authorization from
    function deauthorize(address who) external onlyOwner() {
        authorized[who] = false;
    }

    /// @dev Function to change owner
    /// @param who The new owner address
    function setOwner(address who) public onlyOwner() {
        owner = who;
    }

    /// @dev Inheritable function which authorizes someone
    /// @param who the address to authorize
    function _authorize(address who) internal {
        authorized[who] = true;
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/UserProxy.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;





/// @author Element Finance
/// @title User Proxy
contract UserProxy is Authorizable {
    // This contract is a convenience library to consolidate
    // the actions needed to create interest or principal tokens to one call.
    // It will hold user allowances, and can be disabled by authorized addresses
    // for security.
    // If frozen users still control their own tokens so can manually redeem them.

    // Store the accessibility state of the contract
    bool public isFrozen = false;
    // Constant wrapped ether address
    IWETH public immutable weth;
    // Tranche factory address for Tranche contract address derivation
    address internal immutable _trancheFactory;
    // Tranche bytecode hash for Tranche contract address derivation.
    // This is constant as long as Tranche does not implement non-constant constructor arguments.
    bytes32 internal immutable _trancheBytecodeHash;
    // A constant which represents ether
    address internal constant _ETH_CONSTANT = address(
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    );

    /// @dev Marks the msg.sender as authorized and sets them
    ///      as the owner in authorization library
    /// @param _weth The constant weth contract address
    /// @param __trancheFactory Address of the TrancheFactory contract
    /// @param __trancheBytecodeHash Hash of the Tranche bytecode.
    constructor(
        IWETH _weth,
        address __trancheFactory,
        bytes32 __trancheBytecodeHash
    ) Authorizable() {
        _authorize(msg.sender);
        weth = _weth;
        _trancheFactory = __trancheFactory;
        _trancheBytecodeHash = __trancheBytecodeHash;
    }

    /// @dev Requires that the contract is not frozen
    modifier notFrozen() {
        require(!isFrozen, "Contract frozen");
        _;
    }

    /// @dev Allows an authorized address to freeze or unfreeze this contract
    /// @param _newState True for frozen and false for unfrozen
    function setIsFrozen(bool _newState) external onlyAuthorized() {
        isFrozen = _newState;
    }

    /// @notice Mints a Principal/Interest token pair from either underlying token or Eth
    ///      then returns the tokens to the caller.
    /// @dev This function assumes that it already has an allowance for the token in question.
    /// @param _amount The amount of underlying to turn into tokens
    /// @param _underlying Either (1) The underlying ERC20 token contract
    ///                   or (2) the _ETH_CONSTANT to indicate the user has sent eth.
    ///                   This token should revert in the event of a transfer failure.
    /// @param _expiration The expiration time of the Tranche contract
    /// @param _position The contract which manages pooled deposits
    function mint(
        uint256 _amount,
        IERC20 _underlying,
        uint256 _expiration,
        address _position
    ) external payable notFrozen() {
        // If the underlying token matches this predefined 'ETH token'
        // then we create weth for the user and go from there
        if (address(_underlying) == _ETH_CONSTANT) {
            // Check that the amount matches the amount provided
            require(msg.value == _amount, "Incorrect amount provided");
            // Create weth from the provided eth
            // NOTE - This can be made slightly cheaper by depositing 1 wei into this
            //        contract address on weth.
            weth.deposit{ value: msg.value }();
            weth.transfer(address(_position), _amount);
            // Proceed to internal minting steps
            _mint(_expiration, _position);
        } else {
            // Move the user's funds to the wrapped position contract
            _underlying.transferFrom(msg.sender, address(_position), _amount);
            // Proceed to internal minting steps
            _mint(_expiration, _position);
        }
    }

    /// @notice Mints a Principal/Interest token pair from a underlying token which supports
    ///      the permit method.
    /// @dev This call sets the allowance on this contract
    ///      for the underlying ERC20 token to be unlimited and expects the
    ///      signature to have an expiration time of uint256.max
    /// @param _amount The amount of underlying to turn into tokens
    /// @param _underlying The underlying ERC20 token contract
    /// @param _expiration The expiration time of the Tranche contract
    /// @param _position The contract which manages pooled positions
    /// @param _v The bit indicator which allows address recover from signature
    /// @param _r The r component of the signature.
    /// @param _s The s component of the signature.
    function mintPermit(
        uint256 _amount,
        IERC20Permit _underlying,
        uint256 _expiration,
        address _position,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external notFrozen() {
        // Permit this contract to have unlimited access to
        // the msg.sender's funds
        _underlying.permit(
            msg.sender,
            address(this),
            type(uint256).max,
            type(uint256).max,
            _v,
            _r,
            _s
        );
        // Move the user's funds to the wrapped position contract
        _underlying.transferFrom(msg.sender, address(_position), _amount);
        // Pass call to internal function which works once approved
        _mint(_expiration, _position);
    }

    /// @dev This internal mint function performs the core minting logic after
    ///      the contract has already transferred to WrappedPosition contract
    /// @param _expiration The tranche expiration time
    /// @param _position The contract which interacts with the yield bearing strategy
    function _mint(uint256 _expiration, address _position) internal {
        // Use create2 to derive the tranche contract
        ITranche tranche = _deriveTranche(address(_position), _expiration);
        // Move funds into the Tranche contract
        // it will credit the msg.sender with the new tokens
        tranche.prefundedDeposit(msg.sender);
    }

    /// @dev This internal function produces the deterministic create2
    ///      address of the Tranche contract from a wrapped position contract and expiration
    /// @param _position The wrapped position contract address
    /// @param _expiration The expiration time of the tranche
    /// @return The derived Tranche contract
    function _deriveTranche(address _position, uint256 _expiration)
        internal
        virtual
        view
        returns (ITranche)
    {
        bytes32 salt = keccak256(abi.encodePacked(_position, _expiration));
        bytes32 addressBytes = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                _trancheFactory,
                salt,
                _trancheBytecodeHash
            )
        );
        return ITranche(address(uint160(uint256(addressBytes))));
    }

    /// @dev This contract holds a number of allowances for addresses so if it is deprecated
    ///      it should be removed so that users do not have to remove allowances.
    ///      Note - onlyOwner is a stronger check than onlyAuthorized, many addresses can be
    ///      authorized to freeze or unfreeze the contract but only the owner address can kill
    function deprecate() external onlyOwner() {
        selfdestruct(payable(msg.sender));
    }
}
