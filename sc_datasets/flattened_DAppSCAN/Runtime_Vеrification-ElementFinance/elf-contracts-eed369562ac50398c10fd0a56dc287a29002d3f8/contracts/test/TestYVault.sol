// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/IERC20.sol

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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/IYearnVaultV2.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IYearnVault is IERC20 {
    function deposit(uint256, address) external returns (uint256);

    function withdraw(
        uint256,
        address,
        uint256
    ) external returns (uint256);

    // Returns the amount of underlying per each unit [1e18] of yearn shares
    function pricePerShare() external view returns (uint256);

    function governance() external view returns (address);

    function setDepositLimit(uint256) external;

    function totalSupply() external view returns (uint256);

    function totalAssets() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/IERC20Permit.sol

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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/libraries/ERC20Permit.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

abstract contract ERC20Permit is IERC20Permit {
    // --- ERC20 Data ---
    string public name;
    string public override symbol;
    uint8 public override decimals;

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;
    mapping(address => uint256) public override nonces;

    // --- EIP712 niceties ---
    // solhint-disable-next-line var-name-mixedcase
    bytes32 public override DOMAIN_SEPARATOR;
    // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32
        public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
        decimals = 18;

        balanceOf[address(0)] = type(uint256).max;
        balanceOf[address(this)] = type(uint256).max;

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name)),
                keccak256(bytes("1")),
                _getChainId(),
                address(this)
            )
        );
    }

    // --- Token ---
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        return transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(
        address spender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 balance = balanceOf[spender];
        uint256 allowed = allowance[spender][msg.sender];
        require(balance >= amount, "ERC20: insufficient-balance");
        if (spender != msg.sender && allowed != type(uint256).max) {
            require(allowed >= amount, "ERC20: insufficient-allowance");
            allowance[spender][msg.sender] = allowed - amount;
        }
        balanceOf[spender] = balance - amount;
        balanceOf[recipient] = balanceOf[recipient] + amount;
        emit Transfer(spender, recipient, amount);
        return true;
    }

    function _mint(address account, uint256 amount) internal virtual {
        balanceOf[account] = balanceOf[account] + amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        balanceOf[account] = balanceOf[account] - amount;
        emit Transfer(account, address(0), amount);
    }

    function approve(address account, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        allowance[msg.sender][account] = amount;
        emit Approval(msg.sender, account, amount);
        return true;
    }

    // --- Approve by signature ---
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        owner,
                        spender,
                        value,
                        nonces[owner],
                        deadline
                    )
                )
            )
        );

        require(owner != address(0), "ERC20: invalid-address-0");
        require(owner == ecrecover(digest, v, r, s), "ERC20: invalid-permit");
        require(
            deadline == 0 || block.timestamp <= deadline,
            "ERC20: permit-expired"
        );
        nonces[owner]++;
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _setupDecimals(uint8 decimals_) internal {
        decimals = decimals_;
    }

    function _getChainId() private view returns (uint256 chainId) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        // solhint-disable-next-line no-inline-assembly
        assembly {
            chainId := chainid()
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/libraries/ERC20PermitWithSupply.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

abstract contract ERC20PermitWithSupply is ERC20Permit {
    uint256 public totalSupply;

    function _mint(address account, uint256 amount) internal override {
        balanceOf[account] = balanceOf[account] + amount;
        totalSupply += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal override {
        balanceOf[account] = balanceOf[account] - amount;
        totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/test/TestERC20.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

// An ERC20 with specified decimals, we may add unlimited mint and other test functions
contract TestERC20 is ERC20Permit {
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20Permit(name_, symbol_) {
        _setupDecimals(decimals_);
    }

    function setBalance(address destination, uint256 amount) external {
        balanceOf[destination] = amount;
        emit Transfer(address(0), destination, amount);
    }

    function uncheckedTransfer(address destination, uint256 amount) external {
        balanceOf[destination] += amount;
        emit Transfer(address(0), destination, amount);
    }

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/test/TestYVault.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;



contract TestYVault is ERC20PermitWithSupply {
    address public token;

    constructor(address _token) ERC20Permit("test ytoken", "yToken") {
        token = _token;
    }

    function deposit(uint256 _amount, address destination)
        external
        returns (uint256)
    {
        uint256 _shares = (_amount * 1e18) / pricePerShare(); // calculate shares
        IERC20(token).transferFrom(msg.sender, address(this), _amount); // pull deposit from sender
        _mint(destination, _shares); // mint shares for sender
        return _shares;
    }

    function withdraw(
        uint256 _shares,
        address destination,
        uint256
    ) external returns (uint256) {
        uint256 _amount = (_shares * pricePerShare()) / 1e18;
        _burn(msg.sender, _shares);
        IERC20(token).transfer(destination, _amount);
        return _amount;
    }

    function pricePerShare() public view returns (uint256) {
        uint256 balance = ERC20Permit(token).balanceOf(address(this));
        if (balance == 0) return 1e18;
        return (balance * 1e18) / totalSupply;
    }

    function updateShares() external {
        uint256 balance = ERC20Permit(token).balanceOf(address(this));
        TestERC20(token).mint(address(this), balance / 10);
    }

    function totalAssets() public view returns (uint256) {
        return ERC20Permit(token).balanceOf(address(this));
    }

    function governance() external pure returns (address) {
        revert("Unimplemented");
    }

    function setDepositLimit(uint256) external pure {
        revert("Unimplemented");
    }
}
