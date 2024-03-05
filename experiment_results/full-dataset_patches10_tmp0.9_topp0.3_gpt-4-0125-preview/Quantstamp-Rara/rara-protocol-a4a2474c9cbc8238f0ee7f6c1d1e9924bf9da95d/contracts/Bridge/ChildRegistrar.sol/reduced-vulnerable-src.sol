


pragma solidity ^0.8.0;


interface IFxMessageProcessor {
    function processMessageFromRoot(
        uint256 stateId,
        address rootMessageSender,
        bytes calldata data
    ) external;
}




abstract contract FxBaseChildTunnel is IFxMessageProcessor {
    
    event MessageSent(bytes message);

    
    address public fxChild;

    
    address public fxRootTunnel;

    constructor(address _fxChild) {
        fxChild = _fxChild;
    }

    
    modifier validateSender(address sender) {
        require(sender == fxRootTunnel, "FxBaseChildTunnel: INVALID_SENDER_FROM_ROOT");
        _;
    }

    
    function setFxRootTunnel(address _fxRootTunnel) external virtual {
        require(fxRootTunnel == address(0x0), "FxBaseChildTunnel: ROOT_TUNNEL_ALREADY_SET");
        fxRootTunnel = _fxRootTunnel;
    }

    function processMessageFromRoot(
        uint256 stateId,
        address rootMessageSender,
        bytes calldata data
    ) external override {
        require(msg.sender == fxChild, "FxBaseChildTunnel: INVALID_SENDER");
        _processMessageFromRoot(stateId, rootMessageSender, data);
    }

    








    function _sendMessageToRoot(bytes memory message) internal {
        emit MessageSent(message);
    }

    








    function _processMessageFromRoot(
        uint256 stateId,
        address sender,
        bytes memory message
    ) internal virtual;
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





contract ChildRegistrar is FxBaseChildTunnel {
    bytes32 public constant REGISTER = keccak256("REGISTER");
    bytes32 public constant DE_REGISTER = keccak256("DE_REGISTER");

    
    IAddressManager public addressManager;

    
    
    
    
    constructor(address _fxChild, IAddressManager _addressManager)
        FxBaseChildTunnel(_fxChild)
    {
        addressManager = _addressManager;
    }

    
    
    
    function _processMessageFromRoot(
        uint256, 
        address sender,
        bytes memory data
    ) internal override validateSender(sender) {
        
        (bytes32 syncType, bytes memory syncData) = abi.decode(
            data,
            (bytes32, bytes)
        );

        if (syncType == REGISTER) {
            _registerNft(syncData);
        } else if (syncType == DE_REGISTER) {
            _deRegisterNft(syncData);
        } else {
            revert("ERR MSG");
        }
    }

    
    function _registerNft(bytes memory syncData) internal {
        
        (
            address owner,
            uint256 chainId,
            address nftContractAddress,
            uint256 nftId,
            address creatorAddress,
            uint256 creatorSaleBasisPoints,
            uint256 optionBits
        ) = abi.decode(
                syncData,
                (address, uint256, address, uint256, address, uint256, uint256)
            );

        
        addressManager.makerRegistrar().registerNftFromBridge(
            owner,
            chainId,
            nftContractAddress,
            nftId,
            creatorAddress,
            creatorSaleBasisPoints,
            optionBits
        );
    }

    
    function _deRegisterNft(bytes memory syncData) internal {
        
        (
            address owner,
            uint256 chainId,
            address nftContractAddress,
            uint256 nftId
        ) = abi.decode(syncData, (address, uint256, address, uint256));

        addressManager.makerRegistrar().deRegisterNftFromBridge(
            owner,
            chainId,
            nftContractAddress,
            nftId
        );
    }
}