// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/lib/SafeMath.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;


/**
 * @title SafeMath
 * @author DODO Breeder
 *
 * @notice Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "MUL_ERROR");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "DIVIDING_ERROR");
        return a / b;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 quotient = div(a, b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_ERROR");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "ADD_ERROR");
        return c;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = x / 2 + 1;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/lib/InitializableOwnable.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @author DODO Breeder
 *
 * @notice Ownership related functions
 */
contract InitializableOwnable {
    address public _OWNER_;
    address public _NEW_OWNER_;
    bool internal _INITIALIZED_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier notInitialized() {
        require(!_INITIALIZED_, "DODO_INITIALIZED");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    function initOwner(address newOwner) public notInitialized {
        _INITIALIZED_ = true;
        _OWNER_ = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() public {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/lib/CloneFactory.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

interface ICloneFactory {
    function clone(address prototype) external returns (address proxy);
}

// introduction of proxy mode design: https://docs.openzeppelin.com/upgrades/2.8/
// minimum implementation of transparent proxy: https://eips.ethereum.org/EIPS/eip-1167

contract CloneFactory is ICloneFactory {
    function clone(address prototype) external override returns (address proxy) {
        bytes20 targetBytes = bytes20(prototype);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            proxy := create(0, clone, 0x37)
        }
        return proxy;
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/lib/ReentrancyGuard.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title ReentrancyGuard
 * @author DODO Breeder
 *
 * @notice Protect functions from Reentrancy Attack
 */
contract ReentrancyGuard {
    // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations
    // zero-state of _ENTERED_ is false
    bool private _ENTERED_;

    modifier preventReentrant() {
        require(!_ENTERED_, "REENTRANT");
        _ENTERED_ = true;
        _;
        _ENTERED_ = false;
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/NFTPool/intf/IFilter.sol

/*

    Copyright 2021 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;

interface IFilter {
    function isNFTValid(address nftCollectionAddress, uint256 nftId) external view returns (bool);

    function _NFT_COLLECTION_() external view returns (address);

    function queryNFTIn(uint256 NFTInAmount)
        external
        view
        returns (uint256 rawReceive, uint256 received);

    function queryNFTTargetOut(uint256 NFTOutAmount)
        external
        view
        returns (uint256 rawPay, uint256 pay);

    function queryNFTRandomOut(uint256 NFTOutAmount)
        external
        view
        returns (uint256 rawPay, uint256 pay);

    function ERC721In(uint256[] memory tokenIds, address to) external returns (uint256 received);

    function ERC721TargetOut(uint256[] memory indexes, address to) external returns (uint256 paid);

    function ERC721RandomOut(uint256 amount, address to) external returns (uint256 paid);

    function ERC1155In(uint256[] memory tokenIds, address to) external returns (uint256 received);

    function ERC1155TargetOut(
        uint256[] memory indexes,
        uint256[] memory amounts,
        address to
    ) external returns (uint256 paid);

    function ERC1155RandomOut(uint256 amount, address to) external returns (uint256 paid);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/NFTPool/intf/IFilterAdmin.sol

/*

    Copyright 2021 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;

interface IFilterAdmin {
    function _OWNER_() external returns (address);

    function _CONTROLLER_() external returns (address);

    function init(
        address owner,
        uint256 initSupply,
        string memory name,
        string memory symbol,
        uint256 feeRate,
        address controller,
        address maintainer,
        address[] memory filters
    ) external;

    function mintFragTo(address to, uint256 rawAmount) external returns (uint256 received);

    function burnFragFrom(address from, uint256 rawAmount) external returns (uint256 paid);

    function queryMintFee(uint256 rawAmount)
        external
        view
        returns (
            uint256 poolFee,
            uint256 mtFee,
            uint256 afterChargedAmount
        );

    function queryBurnFee(uint256 rawAmount)
        external
        view
        returns (
            uint256 poolFee,
            uint256 mtFee,
            uint256 afterChargedAmount
        );
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/intf/IDODONFTApprove.sol

/*

    Copyright 2021 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;

interface IDODONFTApprove {
    function isAllowedProxy(address _proxy) external view returns (bool);

    function claimERC721(address nftContract, address who, address dest, uint256 tokenId) external;

    function claimERC1155(address nftContract, address who, address dest, uint256 tokenId, uint256 amount) external;

    function claimERC1155Batch(address nftContract, address who, address dest, uint256[] memory tokenIds, uint256[] memory amounts) external;
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/intf/IERC20.sol

// This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
// SPDX-License-Identifier: MIT

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

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
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/lib/SafeERC20.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0
    This is a simplified version of OpenZepplin's SafeERC20 library

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-e16ceb038ed6bf070ea75d9359c7ad54e6f3e226/contracts/SmartRoute/proxies/DODONFTPoolProxy.sol

/*
    Copyright 2021 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0
*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;









interface IFilterV1 {
    function init(
        address filterAdmin,
        address nftCollection,
        bool[] memory toggles,
        uint256[] memory numParams,
        uint256[] memory priceRules,
        uint256[] memory spreadIds
    ) external;
}

contract DODONFTPoolProxy is ReentrancyGuard, InitializableOwnable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // ============ Storage ============
    address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    mapping(uint256 => address) public _FILTER_TEMPLATES_;
    address public _FILTER_ADMIN_TEMPLATE_;
    address public _MAINTAINER_;
    address public _CONTROLLER_;
    address public immutable _CLONE_FACTORY_;
    address public immutable _DODO_NFT_APPROVE_;
    address public immutable _DODO_APPROVE_;


    // ============ Event ==============
    event SetFilterTemplate(uint256 idx, address filterTemplate);

    constructor(
        address cloneFactory,
        address filterAdminTemplate,
        address controllerModel,
        address defaultMaintainer,
        address dodoNftApprove,
        address dodoApprove
    ) public {
        _CLONE_FACTORY_ = cloneFactory;
        _FILTER_ADMIN_TEMPLATE_ = filterAdminTemplate;
        _CONTROLLER_ = controllerModel;
        _MAINTAINER_ = defaultMaintainer;
        _DODO_NFT_APPROVE_ = dodoNftApprove;
        _DODO_APPROVE_ = dodoApprove;
    }

    // ================ ERC721 In and Out ===================
    function erc721In(
        address filter,
        address nftCollection,
        uint256[] memory tokenIds,
        address to,
        uint256 minMintAmount
    ) external {
        for(uint256 i = 0; i < tokenIds.length; i++) {
            require(IFilter(filter).isNFTValid(nftCollection,tokenIds[i]), "NOT_REGISTRIED");
            IDODONFTApprove(_DODO_NFT_APPROVE_).claimERC721(nftCollection, msg.sender, filter, tokenIds[i]);
        }
        uint256 received = IFilter(filter).ERC721In(tokenIds, to);
        require(received >= minMintAmount, "MINT_AMOUNT_NOT_ENOUGH");
    }

    function erc721TargetOut(
        address filter,
        uint256[] memory indexes,
        address to,
        uint256 maxBurnAmount 
    ) external {
        uint256 paid = IFilter(filter).ERC721TargetOut(indexes, to);
        require(paid <= maxBurnAmount, "BURN_AMOUNT_EXCEED");
    }

    function erc721RandomOut(
        address filter,
        uint256 amount,
        address to,
        uint256 maxBurnAmount 
    ) external {
        uint256 paid = IFilter(filter).ERC721RandomOut(amount, to);
        require(paid <= maxBurnAmount, "BURN_AMOUNT_EXCEED");
    }

    // ================== ERC1155 In and Out ===================
    function erc1155In(
        address filter,
        address nftCollection,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        address to,
        uint256 minMintAmount
    ) external {
        for(uint256 i = 0; i < tokenIds.length; i++) {
            require(IFilter(filter).isNFTValid(nftCollection,tokenIds[i]), "NOT_REGISTRIED");
        }
        IDODONFTApprove(_DODO_NFT_APPROVE_).claimERC1155Batch(nftCollection, msg.sender, filter, tokenIds, amounts);
        uint256 received = IFilter(filter).ERC1155In(tokenIds, to);
        require(received >= minMintAmount, "MINT_AMOUNT_NOT_ENOUGH");
    }

    function erc1155TargetOut(
        address filter,
        uint256[] memory indexes,
        uint256[] memory amounts,
        address to,
        uint256 maxBurnAmount 
    ) external {
        uint256 paid = IFilter(filter).ERC1155TargetOut(indexes, amounts, to);
        require(paid <= maxBurnAmount, "BURN_AMOUNT_EXCEED");
    }

    function erc1155RandomOut(
        address filter,
        uint256 amount,
        address to,
        uint256 maxBurnAmount 
    ) external {
        uint256 paid = IFilter(filter).ERC1155RandomOut(amount, to);
        require(paid <= maxBurnAmount, "BURN_AMOUNT_EXCEED");
    }


    // ================== Create NFTPool ===================
    function createNewNFTPoolV1(
        address nftCollection,
        uint256 filterKey, //1 => FilterERC721V1, 2 => FilterERC1155V1
        string[] memory tokenInfo, 
        uint256[] memory numParams,//0 - initSupply, 1 - fee
        bool[] memory toggles,
        uint256[] memory filterNumParams, //0 - startId, 1 - endId, 2 - maxAmount, 3 - minAmount
        uint256[] memory priceRules,
        uint256[] memory spreadIds
    ) external returns(address newFilterAdmin) {
        newFilterAdmin = ICloneFactory(_CLONE_FACTORY_).clone(_FILTER_ADMIN_TEMPLATE_);

        address filterV1 = createFilterV1(
            filterKey,
            newFilterAdmin,
            nftCollection,
            toggles,
            filterNumParams,
            priceRules,
            spreadIds
        );

        address[] memory filters = new address[](1);
        filters[0] = filterV1;
        
        IFilterAdmin(newFilterAdmin).init(
            msg.sender, 
            numParams[0],
            tokenInfo[0],
            tokenInfo[1],
            numParams[1],
            _CONTROLLER_,
            _MAINTAINER_,
            filters
        );
    }

    // ================== Create Filter ===================
    function createFilterV1(
        uint256 key,
        address filterAdmin,
        address nftCollection,
        bool[] memory toggles,
        uint256[] memory numParams, //0 - startId, 1 - endId, 2 - maxAmount, 3 - minAmount
        uint256[] memory priceRules,
        uint256[] memory spreadIds
    ) public returns(address newFilterV1) {
        newFilterV1 = ICloneFactory(_CLONE_FACTORY_).clone(_FILTER_TEMPLATES_[key]);
        IFilterV1(newFilterV1).init(
            filterAdmin,
            nftCollection,
            toggles,
            numParams,
            priceRules,
            spreadIds
        );
    }


    // ================== NFT ERC20 Swap ======================
    function erc721ToErc20(
        address filterAdmin,
        address filter,
        address nftContract,
        uint256 tokenId,
        address toToken,
        address dodoProxy,
        bytes memory dodoSwapData
    ) 
        external
        preventReentrant
    {
        IDODONFTApprove(_DODO_NFT_APPROVE_).claimERC721(nftContract, msg.sender, filter, tokenId);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId;

        uint256 receivedFragAmount = IFilter(filter).ERC721In(tokenIds, address(this));

        _generalApproveMax(filterAdmin, _DODO_APPROVE_, receivedFragAmount);

        (bool success, ) = dodoProxy.call(dodoSwapData);
        require(success, "API_SWAP_FAILED");

        uint256 returnAmount = _generalBalanceOf(toToken, address(this));

        _generalTransfer(toToken, msg.sender, returnAmount);
    }
    

    //====================== Ownable ========================
    function changeMaintainer(address newMaintainer) external onlyOwner {
        _MAINTAINER_ = newMaintainer;
    }

    function changeFilterAdminTemplate(address newFilterAdminTemplate) external onlyOwner {
        _FILTER_ADMIN_TEMPLATE_ = newFilterAdminTemplate;
    }

    function changeController(address newControllerModel) external onlyOwner {
        _CONTROLLER_ = newControllerModel;
    }

    function setFilterTemplate(uint256 idx, address newFilterTemplate) external onlyOwner {
        _FILTER_TEMPLATES_[idx] = newFilterTemplate;
        emit SetFilterTemplate(idx, newFilterTemplate);
    }


    //======================= Internal =====================
    function _generalApproveMax(
        address token,
        address to,
        uint256 amount
    ) internal {
        uint256 allowance = IERC20(token).allowance(address(this), to);
        if (allowance < amount) {
            if (allowance > 0) {
                IERC20(token).safeApprove(to, 0);
            }
            IERC20(token).safeApprove(to, uint256(-1));
        }
    }

    function _generalBalanceOf(
        address token, 
        address who
    ) internal view returns (uint256) {
        if (token == _ETH_ADDRESS_) {
            return who.balance;
        } else {
            return IERC20(token).balanceOf(who);
        }
    }

    function _generalTransfer(
        address token,
        address payable to,
        uint256 amount
    ) internal {
        if (amount > 0) {
            if (token == _ETH_ADDRESS_) {
                to.transfer(amount);
            } else {
                IERC20(token).safeTransfer(to, amount);
            }
        }
    }
}
