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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/IWrappedPosition.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;


interface IWrappedPosition is IERC20Permit {
    function token() external view returns (IERC20);

    function balanceOfUnderlying(address who) external view returns (uint256);

    function getSharesToUnderlying(uint256 shares)
        external
        view
        returns (uint256);

    function deposit(address sender, uint256 amount) external returns (uint256);

    function withdraw(
        address sender,
        uint256 _shares,
        uint256 _minUnderlying
    ) external returns (uint256);

    function withdrawUnderlying(
        address _destination,
        uint256 _amount,
        uint256 _minUnderlying
    ) external returns (uint256);

    function prefundedDeposit(address _destination)
        external
        returns (
            uint256,
            uint256,
            uint256
        );
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/IInterestToken.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IInterestToken is IERC20Permit {
    function mint(address _account, uint256 _amount) external;

    function burn(address _account, uint256 _amount) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/ITranche.sol

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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/interfaces/ITrancheFactory.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface ITrancheFactory {
    function getData()
        external
        returns (
            address,
            uint256,
            InterestToken
        );
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/Tranche.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;






/// @author Element Finance
/// @title Tranche
contract Tranche is ERC20Permit, ITranche {
    IInterestToken public immutable override interestToken;
    IWrappedPosition public immutable position;
    IERC20 public immutable underlying;
    uint8 internal immutable _underlyingDecimals;

    // The outstanding amount of underlying which
    // can be redeemed from the contract from Principal Tokens
    // NOTE - we use smaller sizes so that they can be one storage slot
    uint128 public valueSupplied;
    // The total supply of interest tokens
    uint128 public interestSupply;
    // The timestamp when tokens can be redeemed.
    uint256 public immutable unlockTimestamp;
    // The amount of slippage allowed on the Principal token redemption [0.1 basis points]
    uint256 internal constant _SLIPPAGE_BP = 1e13;

    /// @notice Constructs this contract
    constructor() ERC20Permit("Element Principal Token", "ELF:") {
        // Assume the caller is the Tranche factory.
        ITrancheFactory trancheFactory = ITrancheFactory(msg.sender);
        (
            address wpAddress,
            uint256 expiration,
            IInterestToken interestTokenTemp
        ) = trancheFactory.getData();
        interestToken = interestTokenTemp;

        IWrappedPosition wpContract = IWrappedPosition(wpAddress);
        position = wpContract;

        string memory strategySymbol = wpContract.symbol();
        // Store the immutable time variables
        unlockTimestamp = expiration;
        // We use local because immutables are not readable in construction
        IERC20 localUnderlying = wpContract.token();
        underlying = localUnderlying;
        // We load and store the underlying decimals
        uint8 localUnderlyingDecimals = localUnderlying.decimals();
        _underlyingDecimals = localUnderlyingDecimals;
        // And set this contract to have the same
        _setupDecimals(localUnderlyingDecimals);

        // Write the strategySymbol  and expiration time to name and symbol
        DateString.encodeAndWriteTimestamp(strategySymbol, expiration, name);
        DateString.encodeAndWriteTimestamp(strategySymbol, expiration, symbol);
    }

    /**
    @notice Deposit wrapped position tokens and receive interest and Principal ERC20 tokens.
            If interest has already been accrued by the wrapped position
            tokens held in this contract, the number of Principal tokens minted is
            reduced in order to pay for the accrued interest.
    @param _amount The amount of underlying to deposit
    @param _destination The address to mint to
    @return The amount of principal tokens minted after earned interest discount
     */
    function deposit(uint256 _amount, address _destination)
        external
        override
        returns (uint256)
    {
        // Transfer the underlying to be wrapped into the position
        underlying.transferFrom(msg.sender, address(position), _amount);
        // Now that we have funded the deposit we can call
        // the prefunded deposit
        return prefundedDeposit(_destination);
    }

    /// @notice This function calls the prefunded deposit method to
    ///         create wrapped position tokens held by the contract. It should
    ///         only be called when a transfer has already been made to
    ///         the wrapped position contract of the underlying
    /// @param _destination The address to mint to
    function prefundedDeposit(address _destination)
        public
        override
        returns (uint256)
    {
        // We check that this it is possible to deposit
        require(block.timestamp < unlockTimestamp, "expired");
        // Since the wrapped position contract holds a balance we use the prefunded deposit method
        (
            uint256 shares,
            uint256 usedUnderlying,
            uint256 balanceBefore
        ) = position.prefundedDeposit(address(this));
        // The implied current value of the holding of this contract in underlying
        // is the balanceBefore*(usedUnderlying/shares) since (usedUnderlying/shares)
        // is underlying per share and balanceBefore is the balance of this contract
        // in position tokens before this deposit.
        uint256 holdingsValue = (balanceBefore * usedUnderlying) / shares;
        // This formula is inputUnderlying - inputUnderlying*interestPerUnderlying
        // Accumulated interest has its value in the interest tokens so we have to mint less
        // principal tokens to account for that.
        // NOTE - If a pool has more than 100% interest in the period this will revert on underflow
        //        The user cannot discount the principal token enough to pay for the outstanding interest accrued.
        (uint256 _valueSupplied, uint256 _interestSupply) = (
            uint256(valueSupplied),
            uint256(interestSupply)
        );
        uint256 adjustedAmount;
        // Have to split on the initialization case and negative interest case
        if (_valueSupplied > 0 && holdingsValue > _valueSupplied) {
            adjustedAmount =
                usedUnderlying -
                ((holdingsValue - _valueSupplied) * usedUnderlying) /
                _interestSupply;
        } else {
            adjustedAmount = usedUnderlying;
        }
        // We record the new input of reclaimable underlying
        (valueSupplied, interestSupply) = (
            uint128(_valueSupplied + adjustedAmount),
            uint128(_interestSupply + usedUnderlying)
        );
        // We mint interest token for each underlying provided
        interestToken.mint(_destination, usedUnderlying);
        // We mint principal token discounted by the accumulated interest.
        _mint(_destination, adjustedAmount);
        // We return the number of principal token because it may be useful.
        return adjustedAmount;
    }

    /**
    @notice Burn principal tokens to withdraw underlying tokens.
    @param _amount The number of tokens to burn.
    @param _destination The address to send the underlying too
    @return The number of underlying tokens released
    @dev This method will return 1 underlying for 1 principal except when interest
         is negative, in that case liquidity might run out and some principal token may
         not be redeemable.
         Also note: Redemption has the possibility of at most _SLIPPAGE_BP
         numerical error on each redemption so each principal token may occasionally redeem
         for less than 1 unit of underlying. Max loss defaults to 0.1 BP ie 0.001% loss
     */
    function withdrawPrincipal(uint256 _amount, address _destination)
        external
        override
        returns (uint256)
    {
        // No redemptions before unlock
        require(block.timestamp >= unlockTimestamp, "not expired");
        // Burn from the sender
        _burn(msg.sender, _amount);
        // Remove these principal token from the interest calculations for future interest redemptions
        valueSupplied -= uint128(_amount);
        uint256 minOutput = _amount - (_amount * _SLIPPAGE_BP) / 1e18;
        return position.withdrawUnderlying(_destination, _amount, minOutput);
    }

    /**
    @notice Burn interest tokens to withdraw underlying tokens.
    @param _amount The number of interest tokens to burn.
    @param _destination The address to send the result to
    @return The number of underlying token released
    @dev Due to slippage the redemption may receive up to _SLIPPAGE_BP less
         in output compared to the floating rate.
     */
    function withdrawInterest(uint256 _amount, address _destination)
        external
        override
        returns (uint256)
    {
        require(block.timestamp >= unlockTimestamp, "not expired");
        // Burn tokens from the sender
        interestToken.burn(msg.sender, _amount);
        // Load the underlying value of this contract
        uint256 underlyingValueLocked = position.balanceOfUnderlying(
            address(this)
        );
        // Load a stack variable to avoid future sloads
        (uint256 _valueSupplied, uint256 _interestSupply) = (
            uint256(valueSupplied),
            uint256(interestSupply)
        );
        // Interest is value locked minus current value
        uint256 interest = underlyingValueLocked > _valueSupplied
            ? underlyingValueLocked - _valueSupplied
            : 0;
        // The redemption amount is the interest per token times the amount
        uint256 redemptionAmount = (interest * _amount) / _interestSupply;
        uint256 minRedemption = redemptionAmount -
            (redemptionAmount * _SLIPPAGE_BP) /
            1e18;
        // Store that we reduced the supply
        interestSupply = uint128(_interestSupply - _amount);
        // Redeem position tokens for underlying
        return
            position.withdrawUnderlying(
                _destination,
                redemptionAmount,
                minRedemption
            );
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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/factories/TrancheFactory.sol

// SPDX-License-Identifier: Apache-2.0





pragma solidity ^0.8.0;

/// @author Element Finance
/// @title Tranche Factory
contract TrancheFactory {
    event TrancheCreated(
        address indexed trancheAddress,
        address indexed wpAddress,
        uint256 indexed expiration
    );

    IInterestTokenFactory internal _interestTokenFactory;
    address internal _tempWpAddress;
    uint256 internal _tempExpiration;
    IInterestToken internal _tempInterestToken;
    bytes32 public constant TRANCHE_CREATION_HASH = keccak256(
        type(Tranche).creationCode
    );

    /// @notice Create a new Tranche.
    /// @param _factory Address of the interest token factory.
    constructor(address _factory) {
        _interestTokenFactory = IInterestTokenFactory(_factory);
    }

    /// @notice Deploy a new Tranche contract.
    /// @param _expiration The expiration timestamp for the tranche.
    /// @param _wpAddress Address of the Wrapped Position contract the tranche will use.
    /// @return The deployed Tranche contract.
    function deployTranche(uint256 _expiration, address _wpAddress)
        public
        returns (Tranche)
    {
        _tempWpAddress = _wpAddress;
        _tempExpiration = _expiration;

        IWrappedPosition wpContract = IWrappedPosition(_wpAddress);
        bytes32 salt = keccak256(abi.encodePacked(_wpAddress, _expiration));
        string memory wpSymbol = wpContract.symbol();
        IERC20 underlying = wpContract.token();
        uint8 underlyingDecimals = underlying.decimals();

        // derive the expected tranche address
        address predictedAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            TRANCHE_CREATION_HASH
                        )
                    )
                )
            )
        );

        _tempInterestToken = _interestTokenFactory.deployInterestToken(
            predictedAddress,
            wpSymbol,
            _expiration,
            underlyingDecimals
        );

        Tranche tranche = new Tranche{ salt: salt }();
        emit TrancheCreated(address(tranche), _wpAddress, _expiration);
        require(
            address(tranche) == predictedAddress,
            "CREATE2 address mismatch"
        );

        // set back to 0-value for some gas savings
        delete _tempWpAddress;
        delete _tempExpiration;
        delete _tempInterestToken;

        return tranche;
    }

    /// @notice Callback function called by the Tranche.
    /// @dev This is called by the Tranche contract constructor.
    /// The return data is used for Tranche initialization. Using this, the Tranche avoids
    /// constructor arguments which can make the Tranche bytecode needed for create2 address
    /// derivation non-constant.
    /// @return Wrapped Position contract address, expiration timestamp, and interest token contract
    function getData()
        external
        view
        returns (
            address,
            uint256,
            IInterestToken
        )
    {
        return (_tempWpAddress, _tempExpiration, _tempInterestToken);
    }
}
