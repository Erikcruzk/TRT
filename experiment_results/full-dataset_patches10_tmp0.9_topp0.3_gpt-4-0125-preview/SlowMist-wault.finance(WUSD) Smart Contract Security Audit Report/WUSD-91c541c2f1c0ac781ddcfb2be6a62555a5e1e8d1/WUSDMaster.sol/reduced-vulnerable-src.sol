



pragma solidity ^0.8.0;











abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}













abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    


    constructor() {
        _setOwner(_msgSender());
    }

    


    function owner() public view virtual returns (address) {
        return _owner;
    }

    


    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    






    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    



    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}













abstract contract Withdrawable is Context, Ownable {

    




    address private _withdrawer;

    event WithdrawershipTransferred(address indexed previousWithdrawer, address indexed newWithdrawer);

    


    constructor () {
        address msgSender = _msgSender();
        _withdrawer = msgSender;
        emit WithdrawershipTransferred(address(0), msgSender);
    }

    


    function withdrawer() public view returns (address) {
        return _withdrawer;
    }

    


    modifier onlyWithdrawer() {
        require(_withdrawer == _msgSender(), "Withdrawable: caller is not the withdrawer");
        _;
    }

    



    function transferWithdrawership(address newWithdrawer) public virtual onlyOwner {
        require(newWithdrawer != address(0), "Withdrawable: new withdrawer is the zero address");
        
        emit WithdrawershipTransferred(_withdrawer, newWithdrawer);
        _withdrawer = newWithdrawer;
    }
}

















abstract contract ReentrancyGuard {
    
    
    
    
    

    
    
    
    
    
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    






    modifier nonReentrant() {
        
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        
        _status = _ENTERED;

        _;

        
        
        _status = _NOT_ENTERED;
    }
}




interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}




library Address {
    
















    function isContract(address account) internal view returns (bool) {
        
        
        

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    















    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    

















    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    





    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    










    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    





    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    





    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    





    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    





    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    





    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            
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
}










library SafeERC20 {
    using Address for address;

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
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    






    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        
        
        
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    





    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        
        
        

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IWUSD is IERC20 {
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}

interface IWswapRouter {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract WUSDMaster is Ownable, Withdrawable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    
    IWUSD public immutable wusd;
    IERC20 public usdt;
    IERC20 public wex;
    IWswapRouter public immutable wswapRouter;
    address public treasury;
    address public strategist;
    
    address[] public swapPath;
    address[] public swapPathReverse;
    
    uint public wexPermille = 100;
    uint public treasuryPermille = 5;
    uint public feePermille = 2;
    
    uint256 public maxStakeAmount;
    
    mapping(address => uint256) public wusdClaimAmount;
    mapping(address => uint256) public wusdClaimBlock;
    mapping(address => uint256) public usdtClaimAmount;
    mapping(address => uint256) public usdtClaimBlock;
    
    event Stake(address indexed user, uint256 amount);
    event WusdClaim(address indexed user, uint256 amount);
    event Redeem(address indexed user, uint256 amount);
    event UsdtClaim(address indexed user, uint256 amount);
    event UsdtWithdrawn(uint256 amount);
    event WexWithdrawn(uint256 amount);
    event SwapPathChanged(address[] swapPath);
    event WexPermilleChanged(uint256 wexPermille);
    event TreasuryPermilleChanged(uint256 treasuryPermille);
    event FeePermilleChanged(uint256 feePermille);
    event TreasuryAddressChanged(address treasury);
    event StrategistAddressChanged(address strategist);
    event MaxStakeAmountChanged(uint256 maxStakeAmount);
    
    constructor(IWUSD _wusd, IERC20 _usdt, IERC20 _wex, IWswapRouter _wswapRouter, address _treasury, uint256 _maxStakeAmount) {
        require(
            address(_wusd) != address(0) &&
            address(_usdt) != address(0) &&
            address(_wex) != address(0) &&
            address(_wswapRouter) != address(0) &&
            _treasury != address(0),
            "zero address in constructor"
        );
        wusd = _wusd;
        usdt = _usdt;
        wex = _wex;
        wswapRouter = _wswapRouter;
        treasury = _treasury;
        swapPath = [address(usdt), address(wex)];
        swapPathReverse = [address(wex), address(usdt)];
        maxStakeAmount = _maxStakeAmount;
    }
    
    function setSwapPath(address[] calldata _swapPath) external onlyOwner {
        swapPath = _swapPath;
        
        emit SwapPathChanged(swapPath);
    }
    
    function setWexPermille(uint _wexPermille) external onlyOwner {
        require(_wexPermille <= 500, 'wexPermille too high!');
        wexPermille = _wexPermille;
        
        emit WexPermilleChanged(wexPermille);
    }
    
    function setTreasuryPermille(uint _treasuryPermille) external onlyOwner {
        require(_treasuryPermille <= 50, 'treasuryPermille too high!');
        treasuryPermille = _treasuryPermille;
        
        emit TreasuryPermilleChanged(treasuryPermille);
    }
    
    function setFeePermille(uint _feePermille) external onlyOwner {
        require(_feePermille <= 20, 'feePermille too high!');
        feePermille = _feePermille;
        
        emit FeePermilleChanged(feePermille);
    }
    
    function setTreasuryAddress(address _treasury) external onlyOwner {
        treasury = _treasury;
        
        emit TreasuryAddressChanged(treasury);
    }
    
    function setStrategistAddress(address _strategist) external onlyOwner {
        strategist = _strategist;
        
        emit StrategistAddressChanged(strategist);
    }
    
    function setMaxStakeAmount(uint256 _maxStakeAmount) external onlyOwner {
        maxStakeAmount = _maxStakeAmount;
        
        emit MaxStakeAmountChanged(maxStakeAmount);
    }
    
    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, 'amount cant be zero');
        require(wusdClaimAmount[msg.sender] == 0, 'you have to claim first');
        require(amount <= maxStakeAmount, 'amount too high');
        
        usdt.safeTransferFrom(msg.sender, address(this), amount);
        if(feePermille > 0) {
            uint256 feeAmount = amount * feePermille / 1000;
            usdt.safeTransfer(treasury, feeAmount);
            amount = amount - feeAmount;
        }
        uint256 wexAmount = amount * wexPermille / 1000;
        usdt.approve(address(wswapRouter), wexAmount);
        
        wswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            wexAmount,
            0,
            swapPath,
            address(this),
            block.timestamp
        );
        
        wusdClaimAmount[msg.sender] = amount;
        wusdClaimBlock[msg.sender] = block.number;
        
        emit Stake(msg.sender, amount);
    }
    
    function claimWusd() external nonReentrant {
        require(wusdClaimAmount[msg.sender] > 0, 'there is nothing to claim');
        require(wusdClaimBlock[msg.sender] < block.number, 'you cant claim yet');
        
        uint256 amount = wusdClaimAmount[msg.sender];
        wusdClaimAmount[msg.sender] = 0;
        wusd.mint(msg.sender, amount);
        
        emit WusdClaim(msg.sender, amount);
    }
    
    function redeem(uint256 amount) external nonReentrant {
        require(amount > 0, 'amount cant be zero');
        require(usdtClaimAmount[msg.sender] == 0, 'you have to claim first');
        
        wusd.burn(msg.sender, amount);
        usdtClaimAmount[msg.sender] = amount;
        usdtClaimBlock[msg.sender] = block.number;
        
        emit Redeem(msg.sender, amount);
    }
    
    function claimUsdt() external nonReentrant {
        require(usdtClaimAmount[msg.sender] > 0, 'there is nothing to claim');
        require(usdtClaimBlock[msg.sender] < block.number, 'you cant claim yet');
        
        uint256 amount = usdtClaimAmount[msg.sender];
        usdtClaimAmount[msg.sender] = 0;
        
        uint256 usdtTransferAmount = amount * (1000 - wexPermille - treasuryPermille) / 1000;
        uint256 usdtTreasuryAmount = amount * treasuryPermille / 1000;
        uint256 wexTransferAmount = wex.balanceOf(address(this)) * amount / (wusd.totalSupply() + amount);
        usdt.safeTransfer(treasury, usdtTreasuryAmount);
        usdt.safeTransfer(msg.sender, usdtTransferAmount);
        wex.approve(address(wswapRouter), wexTransferAmount);
        wswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            wexTransferAmount,
            0,
            swapPathReverse,
            msg.sender,
            block.timestamp
        );
        
        emit UsdtClaim(msg.sender, amount);
    }
    
    function withdrawUsdt(uint256 amount) external onlyOwner {
        require(strategist != address(0), 'strategist not set');
        usdt.safeTransfer(strategist, amount);
        
        emit UsdtWithdrawn(amount);
    }
    
    function withdrawWex(uint256 amount) external onlyWithdrawer {
        wex.safeTransfer(msg.sender, amount);
        
        emit WexWithdrawn(amount);
    }
}