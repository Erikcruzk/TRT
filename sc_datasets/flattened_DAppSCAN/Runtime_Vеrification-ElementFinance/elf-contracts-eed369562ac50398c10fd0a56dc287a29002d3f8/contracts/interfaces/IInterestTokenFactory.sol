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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/libraries/DateString.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

library DateString {
    uint256 public constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint256 public constant SECONDS_PER_HOUR = 60 * 60;
    uint256 public constant SECONDS_PER_MINUTE = 60;
    int256 public constant OFFSET19700101 = 2440588;

    // This function was forked from https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
    // ------------------------------------------------------------------------
    // Calculate year/month/day from the number of days since 1970/01/01 using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and adding the offset 2440588 so that 1970/01/01 is day 0
    //
    // int L = days + 68569 + offset
    // int N = 4 * L / 146097
    // L = L - (146097 * N + 3) / 4
    // year = 4000 * (L + 1) / 1461001
    // L = L - 1461 * year / 4 + 31
    // month = 80 * L / 2447
    // dd = L - 2447 * month / 80
    // L = month / 11
    // month = month + 2 - 12 * L
    // year = 100 * (N - 49) + year + L
    // ------------------------------------------------------------------------
    // solhint-disable-next-line private-vars-leading-underscore
    function _daysToDate(uint256 _days)
        internal
        pure
        returns (
            uint256 year,
            uint256 month,
            uint256 day
        )
    {
        int256 __days = int256(_days);
        // solhint-disable-next-line var-name-mixedcase
        int256 L = __days + 68569 + OFFSET19700101;
        // solhint-disable-next-line var-name-mixedcase
        int256 N = (4 * L) / 146097;
        L = L - (146097 * N + 3) / 4;
        int256 _year = (4000 * (L + 1)) / 1461001;
        L = L - (1461 * _year) / 4 + 31;
        int256 _month = (80 * L) / 2447;
        int256 _day = L - (2447 * _month) / 80;
        L = _month / 11;
        _month = _month + 2 - 12 * L;
        _year = 100 * (N - 49) + _year + L;

        year = uint256(_year);
        month = uint256(_month);
        day = uint256(_day);
    }

    /// @dev Writes a prefix and an timestamp encoding to an output storage location
    ///      This function is designed to only work with ASCII encoded strings. No emojis please.
    /// @param _prefix The string to write before the timestamp
    /// @param _timestamp the timestamp to encode and store
    /// @param _output the storage location of the output string
    /// NOTE - Current cost ~90k if gas is problem revisit and use assembly to remove the extra
    ///        sstore s.
    function encodeAndWriteTimestamp(
        string memory _prefix,
        uint256 _timestamp,
        string storage _output
    ) internal {
        // Cast the prefix string to a byte array
        bytes memory bytePrefix = bytes(_prefix);
        // Cast the output string to a byte array
        bytes storage bytesOutput = bytes(_output);
        // Copy the bytes from the prefix onto the byte array
        // NOTE - IF PREFIX CONTAINS NON-ASCII CHARS THIS WILL CAUSE AN INCORRECT STRING LENGTH
        for (uint256 i = 0; i < bytePrefix.length; i++) {
            bytesOutput.push(bytePrefix[i]);
        }
        // Add a ':' to the string to separate the prefix from the the date
        bytesOutput.push(bytes1(":"));
        // Add the date string
        timestampToDateString(_timestamp, _output);
    }

    /// @dev Converts a unix second encoded timestamp to a date format (year, month, day)
    ///      then writes the string encoding of that to the output pointer.
    /// @param _timestamp the unix seconds timestamp
    /// @param _outputPointer the storage pointer to change.
    function timestampToDateString(
        uint256 _timestamp,
        string storage _outputPointer
    ) internal {
        // We pretend the string is a 'bytes' only push UTF8 encodings to it
        bytes storage output = bytes(_outputPointer);
        // First we get the day month and year
        (uint256 year, uint256 month, uint256 day) = _daysToDate(
            _timestamp / SECONDS_PER_DAY
        );
        // First we add encoded day to the string
        {
            // Round out the second digit
            uint256 firstDigit = day / 10;
            // add it to the encoded byte for '0'
            output.push(bytes1(uint8(bytes1("0")) + uint8(firstDigit)));
            // Extract the second digit
            uint256 secondDigit = day % 10;
            // add it to the string
            output.push(bytes1(uint8(bytes1("0")) + uint8(secondDigit)));
        }
        output.push(bytes1("-"));
        // Next we encode the month string and add it
        if (month == 1) {
            output.push(bytes1("J"));
            output.push(bytes1("A"));
            output.push(bytes1("N"));
        } else if (month == 2) {
            output.push(bytes1("F"));
            output.push(bytes1("E"));
            output.push(bytes1("B"));
        } else if (month == 3) {
            output.push(bytes1("M"));
            output.push(bytes1("A"));
            output.push(bytes1("R"));
        } else if (month == 4) {
            output.push(bytes1("A"));
            output.push(bytes1("P"));
            output.push(bytes1("R"));
        } else if (month == 5) {
            output.push(bytes1("M"));
            output.push(bytes1("A"));
            output.push(bytes1("Y"));
        } else if (month == 6) {
            output.push(bytes1("J"));
            output.push(bytes1("U"));
            output.push(bytes1("N"));
        } else if (month == 7) {
            output.push(bytes1("J"));
            output.push(bytes1("U"));
            output.push(bytes1("L"));
        } else if (month == 8) {
            output.push(bytes1("A"));
            output.push(bytes1("U"));
            output.push(bytes1("G"));
        } else if (month == 9) {
            output.push(bytes1("S"));
            output.push(bytes1("E"));
            output.push(bytes1("P"));
        } else if (month == 10) {
            output.push(bytes1("O"));
            output.push(bytes1("C"));
            output.push(bytes1("T"));
        } else if (month == 11) {
            output.push(bytes1("N"));
            output.push(bytes1("O"));
            output.push(bytes1("V"));
        } else if (month == 12) {
            output.push(bytes1("D"));
            output.push(bytes1("E"));
            output.push(bytes1("C"));
        } else {
            revert("date decoding error");
        }
        output.push(bytes1("-"));
        // We take the last two digits of the year
        // Hopefully that's enough
        {
            uint256 lastDigits = year % 100;
            // Round out the second digit
            uint256 firstDigit = lastDigits / 10;
            // add it to the encoded byte for '0'
            output.push(bytes1(uint8(bytes1("0")) + uint8(firstDigit)));
            // Extract the second digit
            uint256 secondDigit = lastDigits % 10;
            // add it to the string
            output.push(bytes1(uint8(bytes1("0")) + uint8(secondDigit)));
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/IInterestToken.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IInterestToken is IERC20Permit {
    function mint(address _account, uint256 _amount) external;

    function burn(address _account, uint256 _amount) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/InterestToken.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;


contract InterestToken is ERC20Permit, IInterestToken {
    // The tranche address which controls the minting
    address public immutable tranche;

    /// @dev Initializes the ERC20 and writes the correct names
    /// @param _tranche The tranche contract address
    /// @param _strategySymbol The symbol of the associated WrappedPosition contract
    /// @param _timestamp The unlock time on the tranche
    constructor(
        address _tranche,
        string memory _strategySymbol,
        uint256 _timestamp,
        uint8 _decimals
    ) ERC20Permit("Element Interest Token ", "ELV:") {
        tranche = _tranche;
        _setupDecimals(_decimals);
        // Write the strategySymbol and expiration time to name and symbol
        DateString.encodeAndWriteTimestamp(_strategySymbol, _timestamp, name);
        DateString.encodeAndWriteTimestamp(_strategySymbol, _timestamp, symbol);
    }

    /// @dev Prevents execution if the caller isn't the tranche
    modifier onlyMintAuthority() {
        require(msg.sender == tranche, "caller is not an authorized minter");
        _;
    }

    /// @dev Mints tokens to an address
    /// @param _account The account to mint to
    /// @param _amount The amount to mint
    function mint(address _account, uint256 _amount)
        external
        override
        onlyMintAuthority
    {
        _mint(_account, _amount);
    }

    /// @dev Burns tokens from an address
    /// @param _account The account to burn from
    /// @param _amount The amount of token to burn
    function burn(address _account, uint256 _amount)
        external
        override
        onlyMintAuthority
    {
        _burn(_account, _amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/IInterestTokenFactory.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IInterestTokenFactory {
    function deployInterestToken(
        address tranche,
        string memory strategySymbol,
        uint256 expiration,
        uint8 underlyingDecimals
    ) external returns (InterestToken interestToken);
}
