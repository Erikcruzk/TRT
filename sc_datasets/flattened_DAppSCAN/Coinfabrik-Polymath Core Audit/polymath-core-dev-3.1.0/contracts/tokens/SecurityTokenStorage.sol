// File: ../sc_datasets/DAppSCAN/Coinfabrik-Polymath Core Audit/polymath-core-dev-3.1.0/contracts/interfaces/IDataStore.sol

pragma solidity 0.5.8;

interface IDataStore {
    /**
     * @dev Changes security token atatched to this data store
     * @param _securityToken address of the security token
     */
    function setSecurityToken(address _securityToken) external;

    /**
     * @dev Stores a uint256 data against a key
     * @param _key Unique key to identify the data
     * @param _data Data to be stored against the key
     */
    function setUint256(bytes32 _key, uint256 _data) external;

    function setBytes32(bytes32 _key, bytes32 _data) external;

    function setAddress(bytes32 _key, address _data) external;

    function setString(bytes32 _key, string calldata _data) external;

    function setBytes(bytes32 _key, bytes calldata _data) external;

    function setBool(bytes32 _key, bool _data) external;

    /**
     * @dev Stores a uint256 array against a key
     * @param _key Unique key to identify the array
     * @param _data Array to be stored against the key
     */
    function setUint256Array(bytes32 _key, uint256[] calldata _data) external;

    function setBytes32Array(bytes32 _key, bytes32[] calldata _data) external ;

    function setAddressArray(bytes32 _key, address[] calldata _data) external;

    function setBoolArray(bytes32 _key, bool[] calldata _data) external;

    /**
     * @dev Inserts a uint256 element to the array identified by the key
     * @param _key Unique key to identify the array
     * @param _data Element to push into the array
     */
    function insertUint256(bytes32 _key, uint256 _data) external;

    function insertBytes32(bytes32 _key, bytes32 _data) external;

    function insertAddress(bytes32 _key, address _data) external;

    function insertBool(bytes32 _key, bool _data) external;

    /**
     * @dev Deletes an element from the array identified by the key.
     * When an element is deleted from an Array, last element of that array is moved to the index of deleted element.
     * @param _key Unique key to identify the array
     * @param _index Index of the element to delete
     */
    function deleteUint256(bytes32 _key, uint256 _index) external;

    function deleteBytes32(bytes32 _key, uint256 _index) external;

    function deleteAddress(bytes32 _key, uint256 _index) external;

    function deleteBool(bytes32 _key, uint256 _index) external;

    /**
     * @dev Stores multiple uint256 data against respective keys
     * @param _keys Array of keys to identify the data
     * @param _data Array of data to be stored against the respective keys
     */
    function setUint256Multi(bytes32[] calldata _keys, uint256[] calldata _data) external;

    function setBytes32Multi(bytes32[] calldata _keys, bytes32[] calldata _data) external;

    function setAddressMulti(bytes32[] calldata _keys, address[] calldata _data) external;

    function setBoolMulti(bytes32[] calldata _keys, bool[] calldata _data) external;

    /**
     * @dev Inserts multiple uint256 elements to the array identified by the respective keys
     * @param _keys Array of keys to identify the data
     * @param _data Array of data to be inserted in arrays of the respective keys
     */
    function insertUint256Multi(bytes32[] calldata _keys, uint256[] calldata _data) external;

    function insertBytes32Multi(bytes32[] calldata _keys, bytes32[] calldata _data) external;

    function insertAddressMulti(bytes32[] calldata _keys, address[] calldata _data) external;

    function insertBoolMulti(bytes32[] calldata _keys, bool[] calldata _data) external;

    function getUint256(bytes32 _key) external view returns(uint256);

    function getBytes32(bytes32 _key) external view returns(bytes32);

    function getAddress(bytes32 _key) external view returns(address);

    function getString(bytes32 _key) external view returns(string memory);

    function getBytes(bytes32 _key) external view returns(bytes memory);

    function getBool(bytes32 _key) external view returns(bool);

    function getUint256Array(bytes32 _key) external view returns(uint256[] memory);

    function getBytes32Array(bytes32 _key) external view returns(bytes32[] memory);

    function getAddressArray(bytes32 _key) external view returns(address[] memory);

    function getBoolArray(bytes32 _key) external view returns(bool[] memory);

    function getUint256ArrayLength(bytes32 _key) external view returns(uint256);

    function getBytes32ArrayLength(bytes32 _key) external view returns(uint256);

    function getAddressArrayLength(bytes32 _key) external view returns(uint256);

    function getBoolArrayLength(bytes32 _key) external view returns(uint256);

    function getUint256ArrayElement(bytes32 _key, uint256 _index) external view returns(uint256);

    function getBytes32ArrayElement(bytes32 _key, uint256 _index) external view returns(bytes32);

    function getAddressArrayElement(bytes32 _key, uint256 _index) external view returns(address);

    function getBoolArrayElement(bytes32 _key, uint256 _index) external view returns(bool);

    function getUint256ArrayElements(bytes32 _key, uint256 _startIndex, uint256 _endIndex) external view returns(uint256[] memory);

    function getBytes32ArrayElements(bytes32 _key, uint256 _startIndex, uint256 _endIndex) external view returns(bytes32[] memory);

    function getAddressArrayElements(bytes32 _key, uint256 _startIndex, uint256 _endIndex) external view returns(address[] memory);

    function getBoolArrayElements(bytes32 _key, uint256 _startIndex, uint256 _endIndex) external view returns(bool[] memory);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Polymath Core Audit/polymath-core-dev-3.1.0/contracts/interfaces/IModuleRegistry.sol

pragma solidity 0.5.8;

/**
 * @title Interface for the Polymath Module Registry contract
 */
interface IModuleRegistry {

    ///////////
    // Events
    //////////

    // Emit when network becomes paused
    event Pause(address account);
    // Emit when network becomes unpaused
    event Unpause(address account);
    // Emit when Module is used by the SecurityToken
    event ModuleUsed(address indexed _moduleFactory, address indexed _securityToken);
    // Emit when the Module Factory gets registered on the ModuleRegistry contract
    event ModuleRegistered(address indexed _moduleFactory, address indexed _owner);
    // Emit when the module gets verified by Polymath
    event ModuleVerified(address indexed _moduleFactory);
    // Emit when the module gets unverified by Polymath or the factory owner
    event ModuleUnverified(address indexed _moduleFactory);
    // Emit when a ModuleFactory is removed by Polymath
    event ModuleRemoved(address indexed _moduleFactory, address indexed _decisionMaker);
    // Emit when ownership gets transferred
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @notice Called by a security token (2.x) to notify the registry it is using a module
     * @param _moduleFactory is the address of the relevant module factory
     */
    function useModule(address _moduleFactory) external;

    /**
     * @notice Called by a security token to notify the registry it is using a module
     * @param _moduleFactory is the address of the relevant module factory
     * @param _isUpgrade whether the use is part of an existing module upgrade
     */
    function useModule(address _moduleFactory, bool _isUpgrade) external;

    /**
     * @notice Called by the ModuleFactory owner to register new modules for SecurityToken to use
     * @param _moduleFactory is the address of the module factory to be registered
     */
    function registerModule(address _moduleFactory) external;

    /**
     * @notice Called by the ModuleFactory owner or registry curator to delete a ModuleFactory
     * @param _moduleFactory is the address of the module factory to be deleted
     */
    function removeModule(address _moduleFactory) external;

    /**
     * @notice Check that a module and its factory are compatible
     * @param _moduleFactory is the address of the relevant module factory
     * @param _securityToken is the address of the relevant security token
     * @return bool whether module and token are compatible
     */
    function isCompatibleModule(address _moduleFactory, address _securityToken) external view returns(bool isCompatible);

    /**
    * @notice Called by Polymath to verify modules for SecurityToken to use.
    * @notice A module can not be used by an ST unless first approved/verified by Polymath
    * @notice (The only exception to this is that the author of the module is the owner of the ST - Only if enabled by the FeatureRegistry)
    * @param _moduleFactory is the address of the module factory to be registered
    */
    function verifyModule(address _moduleFactory) external;

    /**
    * @notice Called by Polymath to unverify modules for SecurityToken to use.
    * @notice A module can not be used by an ST unless first approved/verified by Polymath
    * @notice (The only exception to this is that the author of the module is the owner of the ST - Only if enabled by the FeatureRegistry)
    * @param _moduleFactory is the address of the module factory to be registered
    */
    function unverifyModule(address _moduleFactory) external;

    /**
     * @notice Returns the verified status, and reputation of the entered Module Factory
     * @param _factoryAddress is the address of the module factory
     * @return bool indicating whether module factory is verified
     * @return address of the factory owner
     * @return address array which contains the list of securityTokens that use that module factory
     */
    function getFactoryDetails(address _factoryAddress) external view returns(bool isVerified, address factoryOwner, address[] memory usingTokens);

    /**
     * @notice Returns all the tags related to the a module type which are valid for the given token
     * @param _moduleType is the module type
     * @param _securityToken is the token
     * @return list of tags
     * @return corresponding list of module factories
     */
    function getTagsByTypeAndToken(uint8 _moduleType, address _securityToken) external view returns(bytes32[] memory tags, address[] memory factories);

    /**
     * @notice Returns all the tags related to the a module type which are valid for the given token
     * @param _moduleType is the module type
     * @return list of tags
     * @return corresponding list of module factories
     */
    function getTagsByType(uint8 _moduleType) external view returns(bytes32[] memory tags, address[] memory factories);

    /**
     * @notice Returns the list of addresses of all Module Factory of a particular type
     * @param _moduleType Type of Module
     * @return address array that contains the list of addresses of module factory contracts.
     */
    function getAllModulesByType(uint8 _moduleType) external view returns(address[] memory factories);
    /**
     * @notice Returns the list of addresses of Module Factory of a particular type
     * @param _moduleType Type of Module
     * @return address array that contains the list of addresses of module factory contracts.
     */
    function getModulesByType(uint8 _moduleType) external view returns(address[] memory factories);

    /**
     * @notice Returns the list of available Module factory addresses of a particular type for a given token.
     * @param _moduleType is the module type to look for
     * @param _securityToken is the address of SecurityToken
     * @return address array that contains the list of available addresses of module factory contracts.
     */
    function getModulesByTypeAndToken(uint8 _moduleType, address _securityToken) external view returns(address[] memory factories);

    /**
     * @notice Use to get the latest contract address of the regstries
     */
    function updateFromRegistry() external;

    /**
     * @notice Get the owner of the contract
     * @return address owner
     */
    function owner() external view returns(address ownerAddress);

    /**
     * @notice Check whether the contract operations is paused or not
     * @return bool
     */
    function isPaused() external view returns(bool paused);

    /**
     * @notice Reclaims all ERC20Basic compatible tokens
     * @param _tokenContract The address of the token contract
     */
    function reclaimERC20(address _tokenContract) external;

    /**
     * @notice Called by the owner to pause, triggers stopped state
     */
    function pause() external;

    /**
     * @notice Called by the owner to unpause, returns to normal state
     */
    function unpause() external;

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param _newOwner The address to transfer ownership to.
    */
    function transferOwnership(address _newOwner) external;

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Polymath Core Audit/polymath-core-dev-3.1.0/contracts/interfaces/IPolymathRegistry.sol

pragma solidity 0.5.8;

interface IPolymathRegistry {

    event ChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
    
    /**
     * @notice Returns the contract address
     * @param _nameKey is the key for the contract address mapping
     * @return address
     */
    function getAddress(string calldata _nameKey) external view returns(address registryAddress);

    /**
     * @notice Changes the contract address
     * @param _nameKey is the key for the contract address mapping
     * @param _newAddress is the new contract address
     */
    function changeAddress(string calldata _nameKey, address _newAddress) external;

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Polymath Core Audit/polymath-core-dev-3.1.0/contracts/interfaces/ISecurityTokenRegistry.sol

pragma solidity 0.5.8;

/**
 * @title Interface for the Polymath Security Token Registry contract
 */
interface ISecurityTokenRegistry {

    // Emit when network becomes paused
    event Pause(address account);
    // Emit when network becomes unpaused
    event Unpause(address account);
    // Emit when the ticker is removed from the registry
    event TickerRemoved(string _ticker, address _removedBy);
    // Emit when the token ticker expiry is changed
    event ChangeExpiryLimit(uint256 _oldExpiry, uint256 _newExpiry);
    // Emit when changeSecurityLaunchFee is called
    event ChangeSecurityLaunchFee(uint256 _oldFee, uint256 _newFee);
    // Emit when changeTickerRegistrationFee is called
    event ChangeTickerRegistrationFee(uint256 _oldFee, uint256 _newFee);
    // Emit when Fee currency is changed
    event ChangeFeeCurrency(bool _isFeeInPoly);
    // Emit when ownership gets transferred
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    // Emit when ownership of the ticker gets changed
    event ChangeTickerOwnership(string _ticker, address indexed _oldOwner, address indexed _newOwner);
    // Emit at the time of launching a new security token of version 3.0+
    event NewSecurityToken(
        string _ticker,
        string _name,
        address indexed _securityTokenAddress,
        address indexed _owner,
        uint256 _addedAt,
        address _registrant,
        bool _fromAdmin,
        uint256 _usdFee,
        uint256 _polyFee,
        uint256 _protocolVersion
    );
    // Emit at the time of launching a new security token v2.0.
    // _registrationFee is in poly
    event NewSecurityToken(
        string _ticker,
        string _name,
        address indexed _securityTokenAddress,
        address indexed _owner,
        uint256 _addedAt,
        address _registrant,
        bool _fromAdmin,
        uint256 _registrationFee
    );
    // Emit when new ticker get registers
    event RegisterTicker(
        address indexed _owner,
        string _ticker,
        uint256 indexed _registrationDate,
        uint256 indexed _expiryDate,
        bool _fromAdmin,
        uint256 _registrationFeePoly,
        uint256 _registrationFeeUsd
    );
    // Emit after ticker registration
    // _registrationFee is in poly
    // fee in usd is not being emitted to maintain backwards compatibility
    event RegisterTicker(
        address indexed _owner,
        string _ticker,
        string _name,
        uint256 indexed _registrationDate,
        uint256 indexed _expiryDate,
        bool _fromAdmin,
        uint256 _registrationFee
    );
    // Emit at when issuer refreshes exisiting token
    event SecurityTokenRefreshed(
        string _ticker,
        string _name,
        address indexed _securityTokenAddress,
        address indexed _owner,
        uint256 _addedAt,
        address _registrant,
        uint256 _protocolVersion
    );
    event ProtocolFactorySet(address indexed _STFactory, uint8 _major, uint8 _minor, uint8 _patch);
    event LatestVersionSet(uint8 _major, uint8 _minor, uint8 _patch);
    event ProtocolFactoryRemoved(address indexed _STFactory, uint8 _major, uint8 _minor, uint8 _patch);

    /**
     * @notice Deploys an instance of a new Security Token of version 2.0 and records it to the registry
     * @dev this function is for backwards compatibilty with 2.0 dApp.
     * @param _name is the name of the token
     * @param _ticker is the ticker symbol of the security token
     * @param _tokenDetails is the off-chain details of the token
     * @param _divisible is whether or not the token is divisible
     */
    function generateSecurityToken(
        string calldata _name,
        string calldata _ticker,
        string calldata _tokenDetails,
        bool _divisible
    )
        external;

    /**
     * @notice Deploys an instance of a new Security Token and records it to the registry
     * @param _name is the name of the token
     * @param _ticker is the ticker symbol of the security token
     * @param _tokenDetails is the off-chain details of the token
     * @param _divisible is whether or not the token is divisible
     * @param _treasuryWallet Ethereum address which will holds the STs.
     * @param _protocolVersion Version of securityToken contract
     * - `_protocolVersion` is the packed value of uin8[3] array (it will be calculated offchain)
     * - if _protocolVersion == 0 then latest version of securityToken will be generated
     */
    function generateNewSecurityToken(
        string calldata _name,
        string calldata _ticker,
        string calldata _tokenDetails,
        bool _divisible,
        address _treasuryWallet,
        uint256 _protocolVersion
    )
        external;

    /**
     * @notice Deploys an instance of a new Security Token and replaces the old one in the registry
     * This can be used to upgrade from version 2.0 of ST to 3.0 or in case something goes wrong with earlier ST
     * @dev This function needs to be in STR 3.0. Defined public to avoid stack overflow
     * @param _name is the name of the token
     * @param _ticker is the ticker symbol of the security token
     * @param _tokenDetails is the off-chain details of the token
     * @param _divisible is whether or not the token is divisible
     */
    function refreshSecurityToken(
        string calldata _name,
        string calldata _ticker,
        string calldata _tokenDetails,
        bool _divisible,
        address _treasuryWallet
    )
        external returns (address securityToken);

    /**
     * @notice Adds a new custom Security Token and saves it to the registry. (Token should follow the ISecurityToken interface)
     * @param _name Name of the token
     * @param _ticker Ticker of the security token
     * @param _owner Owner of the token
     * @param _securityToken Address of the securityToken
     * @param _tokenDetails Off-chain details of the token
     * @param _deployedAt Timestamp at which security token comes deployed on the ethereum blockchain
     */
    function modifySecurityToken(
        string calldata _name,
        string calldata _ticker,
        address _owner,
        address _securityToken,
        string calldata _tokenDetails,
        uint256 _deployedAt
    )
    external;

    /**
     * @notice Adds a new custom Security Token and saves it to the registry. (Token should follow the ISecurityToken interface)
     * @param _ticker is the ticker symbol of the security token
     * @param _owner is the owner of the token
     * @param _securityToken is the address of the securityToken
     * @param _tokenDetails is the off-chain details of the token
     * @param _deployedAt is the timestamp at which the security token is deployed
     */
    function modifyExistingSecurityToken(
        string calldata _ticker,
        address _owner,
        address _securityToken,
        string calldata _tokenDetails,
        uint256 _deployedAt
    )
        external;

    /**
     * @notice Modifies the ticker details. Only Polymath has the ability to do so.
     * @notice Only allowed to modify the tickers which are not yet deployed.
     * @param _owner is the owner of the token
     * @param _ticker is the token ticker
     * @param _registrationDate is the date at which ticker is registered
     * @param _expiryDate is the expiry date for the ticker
     * @param _status is the token deployment status
     */
    function modifyExistingTicker(
        address _owner,
        string calldata _ticker,
        uint256 _registrationDate,
        uint256 _expiryDate,
        bool _status
    )
        external;

    /**
     * @notice Registers the token ticker for its particular owner
     * @notice once the token ticker is registered to its owner then no other issuer can claim
     * @notice its ownership. If the ticker expires and its issuer hasn't used it, then someone else can take it.
     * @param _owner Address of the owner of the token
     * @param _ticker Token ticker
     * @param _tokenName Name of the token
     */
    function registerTicker(address _owner, string calldata _ticker, string calldata _tokenName) external;

    /**
     * @notice Registers the token ticker to the selected owner
     * @notice Once the token ticker is registered to its owner then no other issuer can claim
     * @notice its ownership. If the ticker expires and its issuer hasn't used it, then someone else can take it.
     * @param _owner is address of the owner of the token
     * @param _ticker is unique token ticker
     */
    function registerNewTicker(address _owner, string calldata _ticker) external;

    /**
    * @notice Check that Security Token is registered
    * @param _securityToken Address of the Scurity token
    * @return bool
    */
    function isSecurityToken(address _securityToken) external view returns(bool isValid);

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param _newOwner The address to transfer ownership to.
    */
    function transferOwnership(address _newOwner) external;

    /**
     * @notice Get security token address by ticker name
     * @param _ticker Symbol of the Scurity token
     * @return address
     */
    function getSecurityTokenAddress(string calldata _ticker) external view returns(address tokenAddress);

    /**
    * @notice Returns the security token data by address
    * @param _securityToken is the address of the security token.
    * @return string is the ticker of the security Token.
    * @return address is the issuer of the security Token.
    * @return string is the details of the security token.
    * @return uint256 is the timestamp at which security Token was deployed.
    */
    function getSecurityTokenData(address _securityToken) external view returns (
        string memory tokenSymbol,
        address tokenAddress,
        string memory tokenDetails,
        uint256 tokenTime
    );

    /**
     * @notice Get the current STFactory Address
     */
    function getSTFactoryAddress() external view returns(address stFactoryAddress);

    /**
     * @notice Returns the STFactory Address of a particular version
     * @param _protocolVersion Packed protocol version
     */
    function getSTFactoryAddressOfVersion(uint256 _protocolVersion) external view returns(address stFactory);

    /**
     * @notice Get Protocol version
     */
    function getLatestProtocolVersion() external view returns(uint8[] memory protocolVersion);

    /**
     * @notice Used to get the ticker list as per the owner
     * @param _owner Address which owns the list of tickers
     */
    function getTickersByOwner(address _owner) external view returns(bytes32[] memory tickers);

    /**
     * @notice Returns the list of tokens owned by the selected address
     * @param _owner is the address which owns the list of tickers
     * @dev Intention is that this is called off-chain so block gas limit is not relevant
     */
    function getTokensByOwner(address _owner) external view returns(address[] memory tokens);

    /**
     * @notice Returns the list of all tokens
     * @dev Intention is that this is called off-chain so block gas limit is not relevant
     */
    function getTokens() external view returns(address[] memory tokens);

    /**
     * @notice Returns the owner and timestamp for a given ticker
     * @param _ticker ticker
     * @return address
     * @return uint256
     * @return uint256
     * @return string
     * @return bool
     */
    function getTickerDetails(string calldata _ticker) external view returns(address tickerOwner, uint256 tickerRegistration, uint256 tickerExpiry, string memory tokenName, bool tickerStatus);

    /**
     * @notice Modifies the ticker details. Only polymath account has the ability
     * to do so. Only allowed to modify the tickers which are not yet deployed
     * @param _owner Owner of the token
     * @param _ticker Token ticker
     * @param _tokenName Name of the token
     * @param _registrationDate Date on which ticker get registered
     * @param _expiryDate Expiry date of the ticker
     * @param _status Token deployed status
     */
    function modifyTicker(
        address _owner,
        string calldata _ticker,
        string calldata _tokenName,
        uint256 _registrationDate,
        uint256 _expiryDate,
        bool _status
    )
    external;

    /**
     * @notice Removes the ticker details and associated ownership & security token mapping
     * @param _ticker Token ticker
     */
    function removeTicker(string calldata _ticker) external;

    /**
     * @notice Transfers the ownership of the ticker
     * @dev _newOwner Address whom ownership to transfer
     * @dev _ticker Ticker
     */
    function transferTickerOwnership(address _newOwner, string calldata _ticker) external;

    /**
     * @notice Changes the expiry time for the token ticker
     * @param _newExpiry New time period for token ticker expiry
     */
    function changeExpiryLimit(uint256 _newExpiry) external;

   /**
    * @notice Sets the ticker registration fee in USD tokens. Only Polymath.
    * @param _tickerRegFee is the registration fee in USD tokens (base 18 decimals)
    */
    function changeTickerRegistrationFee(uint256 _tickerRegFee) external;

    /**
    * @notice Sets the ticker registration fee in USD tokens. Only Polymath.
    * @param _stLaunchFee is the registration fee in USD tokens (base 18 decimals)
    */
    function changeSecurityLaunchFee(uint256 _stLaunchFee) external;

    /**
    * @notice Sets the ticker registration and ST launch fee amount and currency
    * @param _tickerRegFee is the ticker registration fee (base 18 decimals)
    * @param _stLaunchFee is the st generation fee (base 18 decimals)
    * @param _isFeeInPoly defines if the fee is in poly or usd
    */
    function changeFeesAmountAndCurrency(uint256 _tickerRegFee, uint256 _stLaunchFee, bool _isFeeInPoly) external;

    /**
    * @notice Changes the SecurityToken contract for a particular factory version
    * @notice Used only by Polymath to upgrade the SecurityToken contract and add more functionalities to future versions
    * @notice Changing versions does not affect existing tokens.
    * @param _STFactoryAddress is the address of the proxy.
    * @param _major Major version of the proxy.
    * @param _minor Minor version of the proxy.
    * @param _patch Patch version of the proxy
    */
    function setProtocolFactory(address _STFactoryAddress, uint8 _major, uint8 _minor, uint8 _patch) external;

    /**
    * @notice Removes a STFactory
    * @param _major Major version of the proxy.
    * @param _minor Minor version of the proxy.
    * @param _patch Patch version of the proxy
    */
    function removeProtocolFactory(uint8 _major, uint8 _minor, uint8 _patch) external;

    /**
    * @notice Changes the default protocol version
    * @notice Used only by Polymath to upgrade the SecurityToken contract and add more functionalities to future versions
    * @notice Changing versions does not affect existing tokens.
    * @param _major Major version of the proxy.
    * @param _minor Minor version of the proxy.
    * @param _patch Patch version of the proxy
    */
    function setLatestVersion(uint8 _major, uint8 _minor, uint8 _patch) external;

    /**
     * @notice Changes the PolyToken address. Only Polymath.
     * @param _newAddress is the address of the polytoken.
     */
    function updatePolyTokenAddress(address _newAddress) external;

    /**
     * @notice Used to update the polyToken contract address
     */
    function updateFromRegistry() external;

    /**
     * @notice Gets the security token launch fee
     * @return Fee amount
     */
    function getSecurityTokenLaunchFee() external returns(uint256 fee);

    /**
     * @notice Gets the ticker registration fee
     * @return Fee amount
     */
    function getTickerRegistrationFee() external returns(uint256 fee);

    /**
     * @notice Set the getter contract address
     * @param _getterContract Address of the contract
     */
    function setGetterRegistry(address _getterContract) external;

    /**
     * @notice Returns the usd & poly fee for a particular feetype
     * @param _feeType Key corresponding to fee type
     */
    function getFees(bytes32 _feeType) external returns (uint256 usdFee, uint256 polyFee);

    /**
     * @notice Returns the list of tokens to which the delegate has some access
     * @param _delegate is the address for the delegate
     * @dev Intention is that this is called off-chain so block gas limit is not relevant
     */
    function getTokensByDelegate(address _delegate) external view returns(address[] memory tokens);

    /**
     * @notice Gets the expiry limit
     * @return Expiry limit
     */
    function getExpiryLimit() external view returns(uint256 expiry);

    /**
     * @notice Gets the status of the ticker
     * @param _ticker Ticker whose status need to determine
     * @return bool
     */
    function getTickerStatus(string calldata _ticker) external view returns(bool status);

    /**
     * @notice Gets the fee currency
     * @return true = poly, false = usd
     */
    function getIsFeeInPoly() external view returns(bool isInPoly);

    /**
     * @notice Gets the owner of the ticker
     * @param _ticker Ticker whose owner need to determine
     * @return address Address of the owner
     */
    function getTickerOwner(string calldata _ticker) external view returns(address owner);

    /**
     * @notice Checks whether the registry is paused or not
     * @return bool
     */
    function isPaused() external view returns(bool paused);

    /**
    * @notice Called by the owner to pause, triggers stopped state
    */
    function pause() external;

    /**
     * @notice Called by the owner to unpause, returns to normal state
     */
    function unpause() external;

    /**
     * @notice Reclaims all ERC20Basic compatible tokens
     * @param _tokenContract is the address of the token contract
     */
    function reclaimERC20(address _tokenContract) external;

    /**
     * @notice Gets the owner of the contract
     * @return address owner
     */
    function owner() external view returns(address ownerAddress);

    /**
     * @notice Checks if the entered ticker is registered and has not expired
     * @param _ticker is the token ticker
     * @return bool
     */
    function tickerAvailable(string calldata _ticker) external view returns(bool);

}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Polymath Core Audit/polymath-core-dev-3.1.0/contracts/tokens/SecurityTokenStorage.sol

pragma solidity 0.5.8;





contract SecurityTokenStorage {

    uint8 internal constant PERMISSION_KEY = 1;
    uint8 internal constant TRANSFER_KEY = 2;
    uint8 internal constant MINT_KEY = 3;
    uint8 internal constant CHECKPOINT_KEY = 4;
    uint8 internal constant BURN_KEY = 5;
    uint8 internal constant DATA_KEY = 6;
    uint8 internal constant WALLET_KEY = 7;

    bytes32 internal constant INVESTORSKEY = 0xdf3a8dd24acdd05addfc6aeffef7574d2de3f844535ec91e8e0f3e45dba96731; //keccak256(abi.encodePacked("INVESTORS"))
    bytes32 internal constant TREASURY = 0xaae8817359f3dcb67d050f44f3e49f982e0359d90ca4b5f18569926304aaece6; //keccak256(abi.encodePacked("TREASURY_WALLET"))
    bytes32 internal constant LOCKED = "LOCKED";
    bytes32 internal constant UNLOCKED = "UNLOCKED";

    //////////////////////////
    /// Document datastructure
    //////////////////////////

    struct Document {
        bytes32 docHash; // Hash of the document
        uint256 lastModified; // Timestamp at which document details was last modified
        string uri; // URI of the document that exist off-chain
    }

    // Used to hold the semantic version data
    struct SemanticVersion {
        uint8 major;
        uint8 minor;
        uint8 patch;
    }

    // Struct for module data
    struct ModuleData {
        bytes32 name;
        address module;
        address moduleFactory;
        bool isArchived;
        uint8[] moduleTypes;
        uint256[] moduleIndexes;
        uint256 nameIndex;
        bytes32 label;
    }

    // Structures to maintain checkpoints of balances for governance / dividends
    struct Checkpoint {
        uint256 checkpointId;
        uint256 value;
    }

    //Naming scheme to match Ownable
    address internal _owner;
    address public tokenFactory;
    bool public initialized;

    // ERC20 Details
    string public name;
    string public symbol;
    uint8 public decimals;

    // Address of the controller which is a delegated entity
    // set by the issuer/owner of the token
    address public controller;

    IPolymathRegistry public polymathRegistry;
    IModuleRegistry public moduleRegistry;
    ISecurityTokenRegistry public securityTokenRegistry;
    IERC20 public polyToken;
    address public getterDelegate;
    // Address of the data store used to store shared data
    IDataStore public dataStore;

    uint256 public granularity;

    // Value of current checkpoint
    uint256 public currentCheckpointId;

    // off-chain data
    string public tokenDetails;

    // Used to permanently halt controller actions
    bool public controllerDisabled = false;

    // Used to temporarily halt all transactions
    bool public transfersFrozen;

    // Number of investors with non-zero balance
    uint256 public holderCount;

    // Variable which tells whether issuance is ON or OFF forever
    // Implementers need to implement one more function to reset the value of `issuance` variable
    // to false. That function is not a part of the standard (EIP-1594) as it is depend on the various factors
    // issuer, followed compliance rules etc. So issuers have the choice how they want to close the issuance.
    bool internal issuance = true;

    // Array use to store all the document name present in the contracts
    bytes32[] _docNames;

    // Times at which each checkpoint was created
    uint256[] checkpointTimes;

    SemanticVersion securityTokenVersion;

    // Records added modules - module list should be order agnostic!
    mapping(uint8 => address[]) modules;

    // Records information about the module
    mapping(address => ModuleData) modulesToData;

    // Records added module names - module list should be order agnostic!
    mapping(bytes32 => address[]) names;

    // Mapping of checkpoints that relate to total supply
    mapping (uint256 => uint256) checkpointTotalSupply;

    // Map each investor to a series of checkpoints
    mapping(address => Checkpoint[]) checkpointBalances;

    // mapping to store the documents details in the document
    mapping(bytes32 => Document) internal _documents;
    // mapping to store the document name indexes
    mapping(bytes32 => uint256) internal _docIndexes;
    // Mapping from (investor, partition, operator) to approved status
    mapping (address => mapping (bytes32 => mapping (address => bool))) partitionApprovals;

}
