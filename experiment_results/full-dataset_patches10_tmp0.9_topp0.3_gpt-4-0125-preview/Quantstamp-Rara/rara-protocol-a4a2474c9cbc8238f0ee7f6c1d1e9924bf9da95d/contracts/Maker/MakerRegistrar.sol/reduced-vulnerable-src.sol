




pragma solidity ^0.8.1;




library AddressUpgradeable {
    





























    function isContract(address account) internal view returns (bool) {
        
        
        

        return account.code.length > 0;
    }

    















    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    

















    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    





    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    










    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    





    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    





    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    





    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    





    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    





    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    





    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                
                
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    





    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        
        if (returndata.length > 0) {
            
            
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}






pragma solidity ^0.8.2;



















































abstract contract Initializable {
    



    uint8 private _initialized;

    


    bool private _initializing;

    


    event Initialized(uint8 version);

    








    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    

















    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    



    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    







    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized != type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    


    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    


    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}






pragma solidity ^0.8.0;










interface IERC165Upgradeable {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}






pragma solidity ^0.8.0;







interface IERC1155Upgradeable is IERC165Upgradeable {
    


    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    



    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    



    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    






    event URI(string value, uint256 indexed id);

    






    function balanceOf(address account, uint256 id) external view returns (uint256);

    






    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    








    function setApprovalForAll(address operator, bool approved) external;

    




    function isApprovedForAll(address account, address operator) external view returns (bool);

    












    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    










    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}




pragma solidity 0.8.9;

interface IRoleManager {
    
    
    function isAdmin(address potentialAddress) external view returns (bool);

    
    
    function isAddressManagerAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isParameterManagerAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isReactionNftAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isCuratorVaultPurchaser(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isCuratorTokenAdmin(address potentialAddress)
        external
        view
        returns (bool);
}




pragma solidity 0.8.9;


interface IMakerRegistrar {
    
    struct NftDetails {
        bool registered;
        address owner;
        address creator;
        uint256 creatorSaleBasisPoints;
    }

    function transformToSourceLookup(uint256 metaId) external returns (uint256);

    function deriveSourceId(
        uint256 nftChainId,
        address nftAddress,
        uint256 nftId
    ) external returns (uint256);

    
    function sourceToDetailsLookup(uint256)
        external
        returns (
            bool,
            address,
            address,
            uint256
        );

    function verifyOwnership(
        address nftContractAddress,
        uint256 nftId,
        address potentialOwner
    ) external returns (bool);

    function registerNftFromBridge(
        address owner,
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId,
        address creatorAddress,
        uint256 creatorSaleBasisPoints,
        uint256 optionBits
    ) external;

    function deRegisterNftFromBridge(
        address owner,
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId
    ) external;
}






pragma solidity ^0.8.0;




interface IERC20Upgradeable {
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);

    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address to, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}




pragma solidity 0.8.9;


interface IParameterManager {
    struct SigmoidCurveParameters {
        uint256 a;
        uint256 b;
        uint256 c;
    }

    
    function paymentToken() external returns (IERC20Upgradeable);

    
    function setPaymentToken(IERC20Upgradeable _paymentToken) external;

    
    function reactionPrice() external returns (uint256);

    
    function setReactionPrice(uint256 _reactionPrice) external;

    
    function saleCuratorLiabilityBasisPoints() external returns (uint256);

    
    function setSaleCuratorLiabilityBasisPoints(
        uint256 _saleCuratorLiabilityBasisPoints
    ) external;

    
    function saleReferrerBasisPoints() external returns (uint256);

    
    function setSaleReferrerBasisPoints(uint256 _saleReferrerBasisPoints)
        external;

    
    function spendTakerBasisPoints() external returns (uint256);

    
    function setSpendTakerBasisPoints(uint256 _spendTakerBasisPoints) external;

    
    function spendReferrerBasisPoints() external returns (uint256);

    
    function setSpendReferrerBasisPoints(uint256 _spendReferrerBasisPoints)
        external;

    
    function approvedCuratorVaults(address potentialVault)
        external
        returns (bool);

    
    function setApprovedCuratorVaults(address vault, bool approved) external;

    
    function bondingCurveParams() external returns(uint256, uint256, uint256);

    
    function setBondingCurveParams(uint256 a, uint256 b, uint256 c) external;
}




pragma solidity 0.8.9;


interface IStandard1155 {
    
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external;

    function burn(
        address from,
        uint256 id,
        uint256 amount
    ) external;
}




pragma solidity 0.8.9;


interface IReactionVault {
    struct ReactionPriceDetails {
        IERC20Upgradeable paymentToken;
        uint256 reactionPrice;
        uint256 saleCuratorLiabilityBasisPoints;
    }
}






pragma solidity ^0.8.0;









interface IERC20PermitUpgradeable {
    




















    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    






    function nonces(address owner) external view returns (uint256);

    


    
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}






pragma solidity ^0.8.0;












library SafeERC20Upgradeable {
    using AddressUpgradeable for address;

    



    function safeTransfer(IERC20Upgradeable token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    



    function safeTransferFrom(IERC20Upgradeable token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    






    function safeApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
        
        
        
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    



    function safeIncreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
    }

    



    function safeDecreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
        }
    }

    




    function forceApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
            _callOptionalReturn(token, approvalCall);
        }
    }

    



    function safePermit(
        IERC20PermitUpgradeable token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    





    function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
        
        
        

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    







    function _callOptionalReturnBool(IERC20Upgradeable token, bytes memory data) private returns (bool) {
        
        
        

        (bool success, bytes memory returndata) = address(token).call(data);
        return
            success && (returndata.length == 0 || abi.decode(returndata, (bool))) && AddressUpgradeable.isContract(address(token));
    }
}




pragma solidity 0.8.9;



interface ICuratorVault {
    function getTokenId(
        uint256 nftChainId,
        address nftAddress,
        uint256 nftId,
        IERC20Upgradeable paymentToken
    ) external returns (uint256);

    function buyCuratorTokens(
        uint256 nftChainId,
        address nftAddress,
        uint256 nftId,
        IERC20Upgradeable paymentToken,
        uint256 paymentAmount,
        address mintToAddress,
        bool isTakerPosition
    ) external returns (uint256);

    function sellCuratorTokens(
        uint256 nftChainId,
        address nftAddress,
        uint256 nftId,
        IERC20Upgradeable paymentToken,
        uint256 tokensToBurn,
        address refundToAddress
    ) external returns (uint256);

    function curatorTokens() external returns (IStandard1155);
}




pragma solidity 0.8.9;






interface IAddressManager {
    
    function roleManager() external returns (IRoleManager);

    
    function setRoleManager(IRoleManager _roleManager) external;

    
    function parameterManager() external returns (IParameterManager);

    
    function setParameterManager(IParameterManager _parameterManager) external;

    
    function makerRegistrar() external returns (IMakerRegistrar);

    
    function setMakerRegistrar(IMakerRegistrar _makerRegistrar) external;

    
    function reactionNftContract() external returns (IStandard1155);

    
    function setReactionNftContract(IStandard1155 _reactionNftContract)
        external;

    
    function defaultCuratorVault() external returns (ICuratorVault);

    
    function setDefaultCuratorVault(ICuratorVault _defaultCuratorVault)
        external;

    
    function childRegistrar() external returns (address);

    
    function setChildRegistrar(address _childRegistrar) external;
}




pragma solidity 0.8.9;







abstract contract MakerRegistrarStorageV1 is IMakerRegistrar {
    
    IAddressManager public addressManager;

    
    string public constant MAKER_META_PREFIX = "MAKER";

    
    mapping(uint256 => uint256) public override transformToSourceLookup;

    
    mapping(uint256 => IMakerRegistrar.NftDetails)
        public
        override sourceToDetailsLookup;
}












pragma solidity 0.8.9;




library NftOwnership {
    
    function _verifyOwnership(
        address nftContractAddress,
        uint256 nftId,
        address potentialOwner
    ) internal view returns (bool) {
        
        (bool success, bytes memory result) = nftContractAddress.staticcall(
            abi.encodeWithSignature(
                "balanceOf(address,uint256)",
                potentialOwner,
                nftId
            )
        );

        
        if (success) {
            uint256 balance = abi.decode(result, (uint256));
            return balance > 0;
        }

        
        (success, result) = nftContractAddress.staticcall(
            abi.encodeWithSignature("ownerOf(uint256)", nftId)
        );

        
        if (success) {
            address foundOwner = abi.decode(result, (address));
            return foundOwner == potentialOwner;
        }

        
        (success, result) = nftContractAddress.staticcall(
            abi.encodeWithSignature("punkIndexToAddress(uint256)", nftId)
        );

        
        if (success) {
            address foundOwner = abi.decode(result, (address));
            return foundOwner == potentialOwner;
        }

        return false;
    }
}




pragma solidity 0.8.9;












contract MakerRegistrar is Initializable, MakerRegistrarStorageV1 {
    
    event Registered(
        uint256 nftChainId,
        address indexed nftContractAddress,
        uint256 indexed nftId,
        address indexed nftOwnerAddress,
        address nftCreatorAddress,
        uint256 creatorSaleBasisPoints,
        uint256 optionBits,
        uint256 sourceId,
        uint256 transformId
    );

    
    event Deregistered(
        uint256 nftChainId,
        address indexed nftContractAddress,
        uint256 indexed nftId,
        address indexed nftOwnerAddress,
        uint256 sourceId
    );

    
    function initialize(IAddressManager _addressManager) public initializer {
        addressManager = _addressManager;
    }

    function deriveSourceId(
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId
    ) external pure returns (uint256) {
        return _deriveSourceId(chainId, nftContractAddress, nftId);
    }

    function _deriveSourceId(
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId
    ) internal pure returns (uint256) {
        return
            uint256(keccak256(abi.encode(chainId, nftContractAddress, nftId)));
    }

    
    function verifyOwnership(
        address nftContractAddress,
        uint256 nftId,
        address potentialOwner
    ) public view returns (bool) {
        return
            NftOwnership._verifyOwnership(
                nftContractAddress,
                nftId,
                potentialOwner
            );
    }

    
    
    function registerNft(
        address nftContractAddress,
        uint256 nftId,
        address creatorAddress,
        uint256 creatorSaleBasisPoints,
        uint256 optionBits
    ) external {
        
        require(
            verifyOwnership(nftContractAddress, nftId, msg.sender),
            "NFT not owned"
        );

        _registerForOwner(
            msg.sender,
            block.chainid, 
            nftContractAddress,
            nftId,
            creatorAddress,
            creatorSaleBasisPoints,
            optionBits
        );
    }

    function registerNftFromBridge(
        address owner,
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId,
        address creatorAddress,
        uint256 creatorSaleBasisPoints,
        uint256 optionBits
    ) external {
        
        require(msg.sender == addressManager.childRegistrar(), "Not Bridge");

        _registerForOwner(
            owner,
            chainId,
            nftContractAddress,
            nftId,
            creatorAddress,
            creatorSaleBasisPoints,
            optionBits
        );
    }

    
    
    
    
    
    
    
    
    
    
    
    function _registerForOwner(
        address owner,
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId,
        address creatorAddress,
        uint256 creatorSaleBasisPoints,
        uint256 optionBits
    ) internal {
        

        
        require(creatorSaleBasisPoints <= 10_000, "Invalid creator bp");

        
        
        
        
        
        
        
        
        
        
        
        
        
        uint256 sourceId = _deriveSourceId(chainId, nftContractAddress, nftId);
        
        sourceToDetailsLookup[sourceId] = NftDetails(
            true,
            owner,
            creatorAddress,
            creatorSaleBasisPoints
        );

        
        
        
        
        
        
        

        
        uint256 transformId = uint256(
            keccak256(abi.encode(MAKER_META_PREFIX, sourceId, optionBits))
        );
        
        transformToSourceLookup[transformId] = sourceId;

        
        emit Registered(
            chainId,
            nftContractAddress,
            nftId,
            owner,
            creatorAddress,
            creatorSaleBasisPoints,
            optionBits,
            sourceId,
            transformId
        );
    }

    
    
    function deregisterNft(address nftContractAddress, uint256 nftId) external {
        
        require(
            verifyOwnership(nftContractAddress, nftId, msg.sender),
            "NFT not owned"
        );

        _deregisterNftForOwner(
            msg.sender,
            block.chainid,
            nftContractAddress,
            nftId
        );
    }

    function deRegisterNftFromBridge(
        address owner,
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId
    ) external {
        
        require(msg.sender == addressManager.childRegistrar(), "Not Bridge");

        _deregisterNftForOwner(owner, chainId, nftContractAddress, nftId);
    }

    function _deregisterNftForOwner(
        address owner,
        uint256 chainId,
        address nftContractAddress,
        uint256 nftId
    ) internal {
        
        uint256 sourceId = _deriveSourceId(chainId, nftContractAddress, nftId);

        
        NftDetails storage details = sourceToDetailsLookup[sourceId];
        require(details.registered, "NFT not registered");

        
        details.registered = false;

        emit Deregistered(chainId, nftContractAddress, nftId, owner, sourceId);
    }
}