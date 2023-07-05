// File: ../sc_datasets/DAppSCAN/QuillAudits-GearBox Protocol-GearBox Protocol/gearbox-contracts-0ac33ba87212ce056ac6b6357ad74161d417158a/contracts/interfaces/app/IAppAddressProvider.sol

// SPDX-License-Identifier: BSL-1.1
// Gearbox. Generalized leverage protocol that allows to take leverage and then use it across other DeFi protocols and platforms in a composable way.
// (c) Gearbox.fi, 2021
pragma solidity ^0.7.4;

/// @title Optimised for front-end Address Provider interface
interface IAppAddressProvider {
    function getDataCompressor() external view returns (address);

    function getGearToken() external view returns (address);

    function getWethToken() external view returns (address);

    function getWETHGateway() external view returns (address);

    function getPriceOracle() external view returns (address);
}

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

// File: ../sc_datasets/DAppSCAN/QuillAudits-GearBox Protocol-GearBox Protocol/gearbox-contracts-0ac33ba87212ce056ac6b6357ad74161d417158a/contracts/libraries/helpers/Errors.sol

// SPDX-License-Identifier: BSL-1.1
// Gearbox. Generalized leverage protocol that allows to take leverage and then use it across other DeFi protocols and platforms in a composable way.
// (c) Gearbox.fi, 2021
pragma solidity ^0.7.4;

/**
 * @title Errors library
 *
 * @notice Defines the error messages emitted by the different contracts of the Aave protocol
 * @dev Error messages prefix glossary:
 * - MATH = Math libraries
 * - POOL = Pool service
 * - CM_ = Credit Manager
 * - AF = Account factory
 * - AM = Account miner
 * - AS = Address storage
 * - PR = Pool Registry
 * - VF = Credit Manager Filter
 */
library Errors {
    string public constant ZERO_ADDRESS_IS_NOT_ALLOWED = "Z0";
    // "0x0 address is not allowed";

    string public constant IMMUTABLE_CONFIG_CHANGES_FORBIDDEN = "I0"; //"Immutable config: changes forbidden";
    string public constant NOT_IMPLEMENTED = "NN"; //"Not implemented";

    //
    // MATH
    //

    string public constant MATH_MULTIPLICATION_OVERFLOW = "M1";
    // "Math: multiplication overflow";
    string public constant MATH_ADDITION_OVERFLOW = "M2";
    // "Math: addition overflow";

    string public constant MATH_DIVISION_BY_ZERO = "M3";
    // "Math: division by zero";

    //
    // POOL
    //

    string public constant POOL_CREDIT_MANAGERS_ONLY = "P0";
    // "Pool: Access forbidden, for credit Managers contract only"

    string public constant POOL_INCOMPATIBLE_CREDIT_ACCOUNT_MANAGER = "P1";
    // "Pool: incompatible vir"

    string public constant POOL_MORE_THAN_EXPECTED_LIQUIDITY_LIMIT = "P2";
    // "Pool: imore than expected liquidity limit"

    string public constant POOL_INCORRECT_WITHDRAW_FEE = "P3";

    string public constant POOL_CANT_ADD_CREDIT_MANAGER_TWICE = "P4";

    //
    // Credit Manager
    //

    string public constant CM_NO_OPEN_ACCOUNT = "V1";
    // "CM_: trader has no opened account";

    string public constant CM_YOU_HAVE_ALREADY_OPEN_CREDIT_ACCOUNT = "V2";
    // "CM_: You have already opened credit account";

    string public constant CM_INCORRECT_AMOUNT = "V3";
    // "CM_: amount less than minimal";

    string public constant CM_INCORRECT_LEVERAGE_FACTOR = "V4";
    // "CM_: incorrect leverage factor";

    string public constant CM_DEFAULT_SWAP_CONTRACT_ISNT_ALLOWED = "V5";
    // "CM_: default swap contract is not allowed";

    string public constant CM_SWAP_CONTRACT_IS_NOT_ALLOWED = "V6";
    // "CM_: swap contract is not allowed";

    string public constant CM_NON_IMMUTABLE_CONFIG_IS_FORBIDDEN = "V7";
    // "CM_: non-immutable config is forbidden";

    string public constant CM_CANT_DEPOSIT_ETH_ON_NON_ETH_POOL = "V8";
    // "CM_: cant deposit eth on non-eth pool";

    string public constant CM_CAN_LIQUIDATE_WITH_SUCH_HEALTH_FACTOR = "V9";
    // "CM_: cant liquidate with health factor > 1";

    string public constant CM_CAN_UPDATE_WITH_SUCH_HEALTH_FACTOR = "VA";
    // "CM_: cant update borrowed amount with this health factor";

    string public constant CM_WETH_GATEWAY_ONLY = "VG";
    // "CM_: cant update borrowed amount with this health factor";

    string public constant CM_INCORRECT_LIMITS = "VL";
    // "CM_: incorrect minAmount or maxAmount";

    string public constant CM_INCORRECT_FEES = "VF";
    // "CM_: incorrect fees";

    string public constant CM_MAX_LEVERAGE_IS_TOO_HIGH = "VM";
    // "CM_: max leverage factor is too high";

    string public constant CM_CANT_CLOSE_WITH_LOSS = "VC";
    // "CM_: cant close with loss";

    string public constant CM_UNDERLYING_IS_NOT_IN_STABLE_POOL = "VU";
    // "CM_: underlying token is not in list of stable pool";

    string public constant CM_TARGET_CONTRACT_iS_NOT_ALLOWED = "VDC";

    string public constant CM_TRANSFER_FAILED = "VT";

    string public constant CM_INCORRECT_NEW_OWNER = "VO";

    // Account Factory

    string public constant AF_CANT_CLOSE_CREDIT_ACCOUNT_IN_THE_SAME_BLOCK =
        "F1";

    string public constant AF_MINING_IS_FINISHED = "F2";

    string public constant AF_CANT_TAKE_LAST_ACCOUNT = "F3";
    // "AccountFactory: cant take the last account";
    string public constant AF_CREDIT_ACCOUNT_NOT_IN_STOCK = "F4";

    // Account Miner
    string public constant AM_ACCOUNT_FACTORY_ONLY = "F3";
    // "AccountMiner: for account factory only";

    string public constant AM_ACCOUNT_FACTORY_ALREADY_EXISTS = "F4";
    // "AccountMiner: account factory already exists";

    string public constant AM_NO_BIDS_WERE_MADE = "F6";
    // "AccountMiner: can't mine new va, no bids were made";

    string public constant AM_BID_LOWER_THAN_MINIMAL = "F7";
    // "AccountMinter: your bid is low than minimal available";

    string public constant AM_USER_ALREADY_HAS_BID = "F8";
    // "AccountMinter: you've already place a bid";

    string public constant AM_USER_HAS_NO_BIDS = "F9";
    // "AccountMiner: user has no bid";

    //
    // ADDRESS PROVIDER
    //

    string public constant AS_ADDRESS_NOT_FOUND = "S1";
    // "AddressStorage: Address not found";

    //
    // CONTRACTS REGISTER
    //

    string public constant CR_CREDIT_ACCOUNT_MANAGERS_ONLY = "R1";
    // "ContractsRegister: allowed for credit Managers only";

    string public constant CR_POOL_ALREADY_ADDED = "R2";
    // "ContractsRegister: pool already added";

    string public constant CR_CREDIT_MANAGER_ALREADY_ADDED = "R3";
    // "ContractsRegister: credit Manager is already set";

    //
    // CREDIT_FILTER
    //
    string public constant CF_UNDERLYING_TOKEN_FILTER_CONFLICT = "C0";
    // "CM_: underlying token in creditFilter is different";

    string public constant CF_INCORRECT_LIQUIDATION_THRESHOLD = "C1";
    // "CreditFilter: incorrect liquidation threshold";

    string public constant CF_TOKEN_IS_NOT_ALLOWED = "C2";
    // "CreditFilter: token is not allowed";

    string public constant CF_CREDIT_MANAGERS_ONLY = "C3";
    // "CF: called by non-credit Manager";

    string public constant CF_ADAPTERS_ONLY = "C4";
    // "CF: called by adapters only";

    string public constant CF_OPERATION_LOW_HEALTH_FACTOR = "C5";
    // "CF: low health factor operation";

    string public constant CF_TOO_MUCH_ALLOWED_TOKENS = "C6";
    // "CF: you cant allo more than 256 tokens";

    string public constant CF_INCORRECT_CHI_THRESHOLD = "C7";
    // "CF: incorrect chi threshold:"

    string public constant CF_INCORRECT_FAST_CHECK = "C8";
    // "CF: incorrect chi threshold:"

    string public constant CF_NON_TOKEN_CONTRACT = "C9";
    // "CF: token contract doesn't support balance method";

    string public constant CF_CONTRACT_IS_NOT_IN_ALLOWED_LIST = "CA";
    // "CF: target contract is not in allowed list"

    string public constant CF_FAST_CHECK_NOT_COVERED_COLLATERAL_DROP = "CB";

    string public constant CF_SOME_LIQUIDATION_THRESHOLD_MORE_THAN_NEW_ONE =
        "CC";

    string public constant CF_POOLS_ONLY = "CP";

    //
    // CREDIT ACCOUNT
    //

    string public constant CA_CREDIT_MANAGER_ONLY = "A1";
    // "CA: called by non-credit Manager";
    string public constant CA_FACTORY_ONLY = "A2";
    //
    // PRICE ORACLE
    //

    string public constant PO_PRICE_FEED_DOESNT_EXIST = "P0";
    // "Price Oracle: price feed doesn't exists";

    string public constant PO_TOKENS_WITH_DECIMALS_MORE_18_ISNT_ALLOWED = "P1";
    // "Price Oracle: tokens with decimals >18 is not allowed";

    //
    // ACL
    //

    string public constant ACL_CALLER_NOT_PAUSABLE_ADMIN = "L1";
    // "ACL: Access forbidden, for pausable admin only";
    string public constant ACL_ADMIN_IS_ALREADY_ADDED = "L2";
    // "ACL: Pausable admin is already set";
    string public constant ACL_CALLER_NOT_CONFIGURATOR = "L3";

    //
    // WETH Gateway
    //

    string public constant WG_DESTINATION_IS_NOT_WETH_COMPATIBLE = "W1";
    // "WETH Gateway: Destination is not WETH compatible";

    string public constant WG_DESTINATION_IS_NOT_POOL = "W2";
    // "WETH Gateway: Destination is not pool";

    string public constant WG_DESTINATION_IS_NOT_CREDIT_MANAGER = "W3";
    // "WETH Gateway: Destination is not credit Manager";

    string public constant WG_RECEIVE_IS_NOT_ALLOWED = "W4";
    // "WETH Gateway: Receive is not allowed";

    string public constant WG_FALLBACK_IS_NOT_ALLOWED = "W5";
    // "WETH Gateway: Fallback is not allowed";

    string public constant LA_INCORRECT_VALUE = "I1";
    // Leveraged Actions: "Incorrect value");
    string public constant LA_INCORRECT_MSG = "I2";
    // "Incorrect msg.value for token operation");

    string public constant LA_UNKNOWN_SWAP_INTERFACE = "I3";

    string public constant LA_UNKNOWN_LP_INTERFACE = "I3";
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-GearBox Protocol-GearBox Protocol/gearbox-contracts-0ac33ba87212ce056ac6b6357ad74161d417158a/contracts/core/AddressProvider.sol

// SPDX-License-Identifier: BSL-1.1
// Gearbox. Generalized leverage protocol that allows to take leverage and then use it across other DeFi protocols and platforms in a composable way.
// (c) Gearbox.fi, 2021
pragma solidity ^0.7.4;



/// @title AddressRepository
/// @notice Stores addresses of deployed contracts
contract AddressProvider is Ownable, IAppAddressProvider {
    // Mapping which keeps all addresses
    mapping(bytes32 => address) public addresses;

    // Emits each time when new address is set
    event AddressSet(bytes32 indexed service, address indexed newAddress);

    // Repositories & services
    bytes32 public constant CONTRACTS_REGISTER = "CONTRACTS_REGISTER";
    bytes32 public constant ACL = "ACL";
    bytes32 public constant PRICE_ORACLE = "PRICE_ORACLE";
    bytes32 public constant ACCOUNT_FACTORY = "ACCOUNT_FACTORY";
    bytes32 public constant DATA_COMPRESSOR = "DATA_COMPRESSOR";
    bytes32 public constant TREASURY_CONTRACT = "TREASURY_CONTRACT";
    bytes32 public constant GEAR_TOKEN = "GEAR_TOKEN";
    bytes32 public constant WETH_TOKEN = "WETH_TOKEN";
    bytes32 public constant WETH_GATEWAY = "WETH_GATEWAY";
    bytes32 public constant LEVERAGED_ACTIONS = "LEVERAGED_ACTIONS";

    constructor() {
        // @dev Emits first event for contract discovery
        emit AddressSet("ADDRESS_PROVIDER", address(this));
    }

    /// @return Address of ACL contract
    function getACL() external view returns (address) {
        return _getAddress(ACL); // T:[AP-3]
    }

    /// @dev Sets address of ACL contract
    /// @param _address Address of ACL contract
    function setACL(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(ACL, _address); // T:[AP-3]
    }

    /// @return Address of ContractsRegister
    function getContractsRegister() external view returns (address) {
        return _getAddress(CONTRACTS_REGISTER); // T:[AP-4]
    }

    /// @dev Sets address of ContractsRegister
    /// @param _address Address of ContractsRegister
    function setContractsRegister(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(CONTRACTS_REGISTER, _address); // T:[AP-4]
    }

    /// @return Address of PriceOracle
    function getPriceOracle() external view override returns (address) {
        return _getAddress(PRICE_ORACLE); // T:[AP-5]
    }

    /// @dev Sets address of PriceOracle
    /// @param _address Address of PriceOracle
    function setPriceOracle(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(PRICE_ORACLE, _address); // T:[AP-5]
    }

    /// @return Address of AccountFactory
    function getAccountFactory() external view returns (address) {
        return _getAddress(ACCOUNT_FACTORY); // T:[AP-6]
    }

    /// @dev Sets address of AccountFactory
    /// @param _address Address of AccountFactory
    function setAccountFactory(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(ACCOUNT_FACTORY, _address); // T:[AP-7]
    }

    /// @return Address of AccountFactory
    function getDataCompressor() external view override returns (address) {
        return _getAddress(DATA_COMPRESSOR); // T:[AP-8]
    }

    /// @dev Sets address of AccountFactory
    /// @param _address Address of AccountFactory
    function setDataCompressor(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(DATA_COMPRESSOR, _address); // T:[AP-8]
    }

    /// @return Address of Treasury contract
    function getTreasuryContract() external view returns (address) {
        return _getAddress(TREASURY_CONTRACT); //T:[AP-11]
    }

    /// @dev Sets address of Treasury Contract
    /// @param _address Address of Treasury Contract
    function setTreasuryContract(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(TREASURY_CONTRACT, _address); //T:[AP-11]
    }

    /// @return Address of GEAR token
    function getGearToken() external view override returns (address) {
        return _getAddress(GEAR_TOKEN); // T:[AP-12]
    }

    /// @dev Sets address of GEAR token
    /// @param _address Address of GEAR token
    function setGearToken(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(GEAR_TOKEN, _address); // T:[AP-12]
    }

    /// @return Address of WETH token
    function getWethToken() external view override returns (address) {
        return _getAddress(WETH_TOKEN); // T:[AP-13]
    }

    /// @dev Sets address of WETH token
    /// @param _address Address of WETH token
    function setWethToken(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(WETH_TOKEN, _address); // T:[AP-13]
    }

    /// @return Address of WETH token
    function getWETHGateway() external view override returns (address) {
        return _getAddress(WETH_GATEWAY); // T:[AP-14]
    }

    /// @dev Sets address of WETH token
    /// @param _address Address of WETH token
    function setWETHGateway(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(WETH_GATEWAY, _address); // T:[AP-14]
    }

    /// @return Address of WETH token
    function getLeveragedActions() external view returns (address) {
        return _getAddress(LEVERAGED_ACTIONS); // T:[AP-7]
    }

    /// @dev Sets address of WETH token
    /// @param _address Address of WETH token
    function setLeveragedActions(address _address)
        external
        onlyOwner // T:[AP-15]
    {
        _setAddress(LEVERAGED_ACTIONS, _address); // T:[AP-7]
    }

    /// @return Address of key, reverts if key doesn't exist
    function _getAddress(bytes32 key) internal view returns (address) {
        address result = addresses[key];
        require(result != address(0), Errors.AS_ADDRESS_NOT_FOUND); // T:[AP-1]
        return result; // T:[AP-3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    }

    /// @dev Sets address to map by its key
    /// @param key Key in string format
    /// @param value Address
    function _setAddress(bytes32 key, address value) internal {
        addresses[key] = value; // T:[AP-3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
        emit AddressSet(key, value); // T:[AP-2]
    }
}
