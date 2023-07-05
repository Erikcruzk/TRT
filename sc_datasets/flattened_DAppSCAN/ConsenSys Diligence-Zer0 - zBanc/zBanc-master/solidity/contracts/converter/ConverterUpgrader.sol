// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IOwned.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Owned contract interface
*/
interface IOwned {
    // this function isn't since the compiler emits automatically generated getter functions as external
    function owner() external view returns (address);

    function transferOwnership(address _newOwner) external;
    function acceptOwnership() external;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/interfaces/IConverterAnchor.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Converter Anchor interface
*/
interface IConverterAnchor is IOwned {
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/token/interfaces/IERC20Token.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    ERC20 Standard Token interface
*/
interface IERC20Token {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function allowance(address _owner, address _spender) external view returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IWhitelist.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Whitelist interface
*/
interface IWhitelist {
    function isWhitelisted(address _address) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/interfaces/IConverter.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;




/*
    Converter interface
*/
interface IConverter is IOwned {
    function converterType() external pure returns (uint16);
    function anchor() external view returns (IConverterAnchor);
    function isActive() external view returns (bool);

    function targetAmountAndFee(IERC20Token _sourceToken, IERC20Token _targetToken, uint256 _amount) external view returns (uint256, uint256);
    function convert(IERC20Token _sourceToken,
                     IERC20Token _targetToken,
                     uint256 _amount,
                     address _trader,
                     address payable _beneficiary) external payable returns (uint256);

    function conversionWhitelist() external view returns (IWhitelist);
    function conversionFee() external view returns (uint32);
    function maxConversionFee() external view returns (uint32);
    function reserveBalance(IERC20Token _reserveToken) external view returns (uint256);
    receive() external payable;

    function transferAnchorOwnership(address _newOwner) external;
    function acceptAnchorOwnership() external;
    function setConversionFee(uint32 _conversionFee) external;
    function setConversionWhitelist(IWhitelist _whitelist) external;
    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) external;
    function withdrawETH(address payable _to) external;
    function addReserve(IERC20Token _token, uint32 _ratio) external;

    // deprecated, backward compatibility
    function token() external view returns (IConverterAnchor);
    function transferTokenOwnership(address _newOwner) external;
    function acceptTokenOwnership() external;
    function connectors(IERC20Token _address) external view returns (uint256, uint32, bool, bool, bool);
    function getConnectorBalance(IERC20Token _connectorToken) external view returns (uint256);
    function connectorTokens(uint256 _index) external view returns (IERC20Token);
    function connectorTokenCount() external view returns (uint16);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/interfaces/IConverterUpgrader.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Converter Upgrader interface
*/
interface IConverterUpgrader {
    function upgrade(bytes32 _version) external;
    function upgrade(uint16 _version) external;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/interfaces/ITypedConverterCustomFactory.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Typed Converter Custom Factory interface
*/
interface ITypedConverterCustomFactory {
    function converterType() external pure returns (uint16);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IContractRegistry.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Contract Registry interface
*/
interface IContractRegistry {
    function addressOf(bytes32 _contractName) external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/interfaces/IConverterFactory.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;




/*
    Converter Factory interface
*/
interface IConverterFactory {
    function createAnchor(uint16 _type, string memory _name, string memory _symbol, uint8 _decimals) external returns (IConverterAnchor);
    function createConverter(uint16 _type, IConverterAnchor _anchor, IContractRegistry _registry, uint32 _maxConversionFee) external returns (IConverter);

    function customFactories(uint16 _type) external view returns (ITypedConverterCustomFactory);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/Owned.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Provides support and utilities for contract ownership
*/
contract Owned is IOwned {
    address public override owner;
    address public newOwner;

    /**
      * @dev triggered when the owner is updated
      *
      * @param _prevOwner previous owner
      * @param _newOwner  new owner
    */
    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);

    /**
      * @dev initializes a new Owned instance
    */
    constructor() public {
        owner = msg.sender;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        _ownerOnly();
        _;
    }

    // error message binary size optimization
    function _ownerOnly() internal view {
        require(msg.sender == owner, "ERR_ACCESS_DENIED");
    }

    /**
      * @dev allows transferring the contract ownership
      * the new owner still needs to accept the transfer
      * can only be called by the contract owner
      *
      * @param _newOwner    new contract owner
    */
    function transferOwnership(address _newOwner) public override ownerOnly {
        require(_newOwner != owner, "ERR_SAME_OWNER");
        newOwner = _newOwner;
    }

    /**
      * @dev used by a new owner to accept an ownership transfer
    */
    function acceptOwnership() override public {
        require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/Utils.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Utilities & Common Modifiers
*/
contract Utils {
    // verifies that a value is greater than zero
    modifier greaterThanZero(uint256 _value) {
        _greaterThanZero(_value);
        _;
    }

    // error message binary size optimization
    function _greaterThanZero(uint256 _value) internal pure {
        require(_value > 0, "ERR_ZERO_VALUE");
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        _validAddress(_address);
        _;
    }

    // error message binary size optimization
    function _validAddress(address _address) internal pure {
        require(_address != address(0), "ERR_INVALID_ADDRESS");
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        _notThis(_address);
        _;
    }

    // error message binary size optimization
    function _notThis(address _address) internal view {
        require(_address != address(this), "ERR_ADDRESS_IS_SELF");
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/ContractRegistryClient.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;



/**
  * @dev Base contract for ContractRegistry clients
*/
contract ContractRegistryClient is Owned, Utils {
    bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
    bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
    bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
    bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
    bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
    bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
    bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
    bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
    bytes32 internal constant BNT_TOKEN = "BNTToken";
    bytes32 internal constant BANCOR_X = "BancorX";
    bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
    bytes32 internal constant CHAINLINK_ORACLE_WHITELIST = "ChainlinkOracleWhitelist";

    IContractRegistry public registry;      // address of the current contract-registry
    IContractRegistry public prevRegistry;  // address of the previous contract-registry
    bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry

    /**
      * @dev verifies that the caller is mapped to the given contract name
      *
      * @param _contractName    contract name
    */
    modifier only(bytes32 _contractName) {
        _only(_contractName);
        _;
    }

    // error message binary size optimization
    function _only(bytes32 _contractName) internal view {
        require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
    }

    /**
      * @dev initializes a new ContractRegistryClient instance
      *
      * @param  _registry   address of a contract-registry contract
    */
    constructor(IContractRegistry _registry) internal validAddress(address(_registry)) {
        registry = IContractRegistry(_registry);
        prevRegistry = IContractRegistry(_registry);
    }

    /**
      * @dev updates to the new contract-registry
     */
    function updateRegistry() public {
        // verify that this function is permitted
        require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");

        // get the new contract-registry
        IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));

        // verify that the new contract-registry is different and not zero
        require(newRegistry != registry && address(newRegistry) != address(0), "ERR_INVALID_REGISTRY");

        // verify that the new contract-registry is pointing to a non-zero contract-registry
        require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");

        // save a backup of the current contract-registry before replacing it
        prevRegistry = registry;

        // replace the current contract-registry with the new contract-registry
        registry = newRegistry;
    }

    /**
      * @dev restores the previous contract-registry
    */
    function restoreRegistry() public ownerOnly {
        // restore the previous contract-registry
        registry = prevRegistry;
    }

    /**
      * @dev restricts the permission to update the contract-registry
      *
      * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
    */
    function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
        // change the permission to update the contract-registry
        onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
    }

    /**
      * @dev returns the address associated with the given contract name
      *
      * @param _contractName    contract name
      *
      * @return contract address
    */
    function addressOf(bytes32 _contractName) internal view returns (address) {
        return registry.addressOf(_contractName);
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/token/interfaces/IEtherToken.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Ether Token interface
*/
interface IEtherToken is IERC20Token {
    function deposit() external payable;
    function withdraw(uint256 _amount) external;
    function depositTo(address _to) external payable;
    function withdrawTo(address payable _to, uint256 _amount) external;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IChainlinkPriceOracle.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Chainlink Price Oracle interface
*/
interface IChainlinkPriceOracle {
    function latestAnswer() external view returns (int256);
    function latestTimestamp() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IPriceOracle.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;


/*
    Price Oracle interface
*/
interface IPriceOracle {
    function tokenAOracle() external view returns (IChainlinkPriceOracle);
    function tokenBOracle() external view returns (IChainlinkPriceOracle);

    function latestRate(IERC20Token _tokenA, IERC20Token _tokenB) external view returns (uint256, uint256);
    function lastUpdateTime() external view returns (uint256);
    function latestRateAndUpdateTime(IERC20Token _tokenA, IERC20Token _tokenB) external view returns (uint256, uint256, uint256);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/types/liquidity-pool-v2/interfaces/ILiquidityPoolV2Converter.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;



/*
    Liquidity Pool V2 Converter interface
*/
interface ILiquidityPoolV2Converter is IConverter {
    function reserveStakedBalance(IERC20Token _reserveToken) external view returns (uint256);
    function setReserveStakedBalance(IERC20Token _reserveToken, uint256 _balance) external;

    function primaryReserveToken() external view returns (IERC20Token);

    function priceOracle() external view returns (IPriceOracle);

    function activate(IERC20Token _primaryReserveToken, IChainlinkPriceOracle _primaryReserveOracle, IChainlinkPriceOracle _secondaryReserveOracle) external;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/ConverterUpgrader.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;







/**
  * @dev Converter Upgrader
  *
  * The converter upgrader contract allows upgrading an older converter contract (0.4 and up)
  * to the latest version.
  * To begin the upgrade process, simply execute the 'upgrade' function.
  * At the end of the process, the ownership of the newly upgraded converter will be transferred
  * back to the original owner and the original owner will need to execute the 'acceptOwnership' function.
  *
  * The address of the new converter is available in the ConverterUpgrade event.
  *
  * Note that for older converters that don't yet have the 'upgrade' function, ownership should first
  * be transferred manually to the ConverterUpgrader contract using the 'transferOwnership' function
  * and then the upgrader 'upgrade' function should be executed directly.
*/
contract ConverterUpgrader is IConverterUpgrader, ContractRegistryClient {
    IERC20Token private constant ETH_RESERVE_ADDRESS = IERC20Token(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    IEtherToken public etherToken;

    /**
      * @dev triggered when the contract accept a converter ownership
      *
      * @param _converter   converter address
      * @param _owner       new owner - local upgrader address
    */
    event ConverterOwned(IConverter indexed _converter, address indexed _owner);

    /**
      * @dev triggered when the upgrading process is done
      *
      * @param _oldConverter    old converter address
      * @param _newConverter    new converter address
    */
    event ConverterUpgrade(address indexed _oldConverter, address indexed _newConverter);

    /**
      * @dev initializes a new ConverterUpgrader instance
      *
      * @param _registry    address of a contract registry contract
    */
    constructor(IContractRegistry _registry, IEtherToken _etherToken) ContractRegistryClient(_registry) public {
        etherToken = _etherToken;
    }

    /**
      * @dev upgrades an old converter to the latest version
      * will throw if ownership wasn't transferred to the upgrader before calling this function.
      * ownership of the new converter will be transferred back to the original owner.
      * fires the ConverterUpgrade event upon success.
      * can only be called by a converter
      *
      * @param _version old converter version
    */
    function upgrade(bytes32 _version) public override {
        upgradeOld(IConverter(msg.sender), _version);
    }

    /**
      * @dev upgrades an old converter to the latest version
      * will throw if ownership wasn't transferred to the upgrader before calling this function.
      * ownership of the new converter will be transferred back to the original owner.
      * fires the ConverterUpgrade event upon success.
      * can only be called by a converter
      *
      * @param _version old converter version
    */
    function upgrade(uint16 _version) public override {
        upgradeOld(IConverter(msg.sender), bytes32(uint256(_version)));
    }

    /**
      * @dev upgrades an old converter to the latest version
      * will throw if ownership wasn't transferred to the upgrader before calling this function.
      * ownership of the new converter will be transferred back to the original owner.
      * fires the ConverterUpgrade event upon success.
      *
      * @param _converter   old converter contract address
      * @param _version     old converter version
    */
    function upgradeOld(IConverter _converter, bytes32 _version) public {
        _version;
        IConverter converter = IConverter(_converter);
        address prevOwner = converter.owner();
        acceptConverterOwnership(converter);
        IConverter newConverter = createConverter(converter);
        copyReserves(converter, newConverter);
        copyConversionFee(converter, newConverter);
        transferReserveBalances(converter, newConverter);
        IConverterAnchor anchor = converter.token();

        // get the activation status before it's being invalidated
        bool activate = isV28OrHigherConverter(converter) && converter.isActive();

        if (anchor.owner() == address(converter)) {
            converter.transferTokenOwnership(address(newConverter));
            newConverter.acceptAnchorOwnership();
        }

        handleTypeSpecificData(converter, newConverter, activate);

        converter.transferOwnership(prevOwner);
        newConverter.transferOwnership(prevOwner);

        emit ConverterUpgrade(address(converter), address(newConverter));
    }

    /**
      * @dev the first step when upgrading a converter is to transfer the ownership to the local contract.
      * the upgrader contract then needs to accept the ownership transfer before initiating
      * the upgrade process.
      * fires the ConverterOwned event upon success
      *
      * @param _oldConverter       converter to accept ownership of
    */
    function acceptConverterOwnership(IConverter _oldConverter) private {
        _oldConverter.acceptOwnership();
        emit ConverterOwned(_oldConverter, address(this));
    }

    /**
      * @dev creates a new converter with same basic data as the original old converter
      * the newly created converter will have no reserves at this step.
      *
      * @param _oldConverter    old converter contract address
      *
      * @return the new converter  new converter contract address
    */
    function createConverter(IConverter _oldConverter) private returns (IConverter) {
        IConverterAnchor anchor = _oldConverter.token();
        uint32 maxConversionFee = _oldConverter.maxConversionFee();
        uint16 reserveTokenCount = _oldConverter.connectorTokenCount();

        // determine new converter type
        uint16 newType = 0;
        // new converter - get the type from the converter itself
        if (isV28OrHigherConverter(_oldConverter))
            newType = _oldConverter.converterType();
        // old converter - if it has 1 reserve token, the type is a liquid token, otherwise the type liquidity pool
        else if (reserveTokenCount > 1)
            newType = 1;

        IConverterFactory converterFactory = IConverterFactory(addressOf(CONVERTER_FACTORY));
        IConverter converter = converterFactory.createConverter(newType, anchor, registry, maxConversionFee);

        converter.acceptOwnership();
        return converter;
    }

    /**
      * @dev copies the reserves from the old converter to the new one.
      * note that this will not work for an unlimited number of reserves due to block gas limit constraints.
      *
      * @param _oldConverter    old converter contract address
      * @param _newConverter    new converter contract address
    */
    function copyReserves(IConverter _oldConverter, IConverter _newConverter) private {
        uint16 reserveTokenCount = _oldConverter.connectorTokenCount();

        for (uint16 i = 0; i < reserveTokenCount; i++) {
            IERC20Token reserveAddress = _oldConverter.connectorTokens(i);
            (, uint32 weight, , , ) = _oldConverter.connectors(reserveAddress);

            // Ether reserve
            if (reserveAddress == ETH_RESERVE_ADDRESS) {
                _newConverter.addReserve(ETH_RESERVE_ADDRESS, weight);
            }
            // Ether reserve token
            else if (reserveAddress == etherToken) {
                _newConverter.addReserve(ETH_RESERVE_ADDRESS, weight);
            }
            // ERC20 reserve token
            else {
                _newConverter.addReserve(reserveAddress, weight);
            }
        }
    }

    /**
      * @dev copies the conversion fee from the old converter to the new one
      *
      * @param _oldConverter    old converter contract address
      * @param _newConverter    new converter contract address
    */
    function copyConversionFee(IConverter _oldConverter, IConverter _newConverter) private {
        uint32 conversionFee = _oldConverter.conversionFee();
        _newConverter.setConversionFee(conversionFee);
    }

    /**
      * @dev transfers the balance of each reserve in the old converter to the new one.
      * note that the function assumes that the new converter already has the exact same number of
      * also, this will not work for an unlimited number of reserves due to block gas limit constraints.
      *
      * @param _oldConverter    old converter contract address
      * @param _newConverter    new converter contract address
    */
    function transferReserveBalances(IConverter _oldConverter, IConverter _newConverter) private {
        uint256 reserveBalance;
        uint16 reserveTokenCount = _oldConverter.connectorTokenCount();

        for (uint16 i = 0; i < reserveTokenCount; i++) {
            IERC20Token reserveAddress = _oldConverter.connectorTokens(i);
            // Ether reserve
            if (reserveAddress == ETH_RESERVE_ADDRESS) {
                _oldConverter.withdrawETH(address(_newConverter));
            }
            // Ether reserve token
            else if (reserveAddress == etherToken) {
                reserveBalance = etherToken.balanceOf(address(_oldConverter));
                _oldConverter.withdrawTokens(etherToken, address(this), reserveBalance);
                etherToken.withdrawTo(address(_newConverter), reserveBalance);
            }
            // ERC20 reserve token
            else {
                IERC20Token connector = reserveAddress;
                reserveBalance = connector.balanceOf(address(_oldConverter));
                _oldConverter.withdrawTokens(connector, address(_newConverter), reserveBalance);
            }
        }
    }

    /**
      * @dev handles upgrading custom (type specific) data from the old converter to the new one
      *
      * @param _oldConverter    old converter contract address
      * @param _newConverter    new converter contract address
      * @param _activate        activate the new converter
    */
    function handleTypeSpecificData(IConverter _oldConverter, IConverter _newConverter, bool _activate) private {
        if (!isV28OrHigherConverter(_oldConverter))
            return;

        uint16 converterType = _oldConverter.converterType();
        if (converterType == 2) {
            ILiquidityPoolV2Converter oldConverter = ILiquidityPoolV2Converter(address(_oldConverter));
            ILiquidityPoolV2Converter newConverter = ILiquidityPoolV2Converter(address(_newConverter));

            uint16 reserveTokenCount = oldConverter.connectorTokenCount();
            for (uint16 i = 0; i < reserveTokenCount; i++) {
                // copy reserve staked balance
                IERC20Token reserveTokenAddress = oldConverter.connectorTokens(i);
                uint256 balance = oldConverter.reserveStakedBalance(reserveTokenAddress);
                newConverter.setReserveStakedBalance(reserveTokenAddress, balance);
            }

            if (!_activate) {
                return;
            }

            // get the primary reserve token
            IERC20Token primaryReserveToken = oldConverter.primaryReserveToken();

            // get the chainlink price oracles
            IPriceOracle priceOracle = oldConverter.priceOracle();
            IChainlinkPriceOracle oracleA = priceOracle.tokenAOracle();
            IChainlinkPriceOracle oracleB = priceOracle.tokenBOracle();

            // activate the new converter
            newConverter.activate(primaryReserveToken, oracleA, oracleB);
        }
    }

    bytes4 private constant IS_V28_OR_HIGHER_FUNC_SELECTOR = bytes4(keccak256("isV28OrHigher()"));

    // using a static call to identify converter version
    // can't rely on the version number since the function had a different signature in older converters
    function isV28OrHigherConverter(IConverter _converter) internal view returns (bool) {
        bytes memory data = abi.encodeWithSelector(IS_V28_OR_HIGHER_FUNC_SELECTOR);
        (bool success, bytes memory returnData) = address(_converter).staticcall{ gas: 4000 }(data);

        if (success && returnData.length == 32) {
            return abi.decode(returnData, (bool));
        }

        return false;
    }
}
