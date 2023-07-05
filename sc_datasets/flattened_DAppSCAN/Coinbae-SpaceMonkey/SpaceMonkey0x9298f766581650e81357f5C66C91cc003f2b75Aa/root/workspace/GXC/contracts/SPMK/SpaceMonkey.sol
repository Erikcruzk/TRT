// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/ERC/IERC20.sol

pragma solidity ^0.8.0;

// SPDX-License-Identifier: UNLICENSED
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/ERC/IERC223Recipient.sol

pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED

 /**
 * @title Contract that will work with ERC223 tokens.
 */
 
interface IERC223Recipient { 
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
    function tokenFallback(address _from, uint _value, bytes calldata _data) external;
}

// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/library/Address.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**
 * Utility library of inline functions on addresses
 */
library Address {

    /**
     * Returns whether the target address is a contract
     * @dev This function will return false if invoked during the constructor of a contract,
     * as the code is not actually created until after the constructor finishes.
     * @param account address of the account to check
     * @return whether the target address is a contract
     */
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        // solium-disable-next-line security/no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

}

// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/library/Context.sol

pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED
/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/library/Ownable.sol

pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }
    
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() external virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) external virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/library/PCS.sol

pragma solidity ^0.8.6;

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;

    function INIT_CODE_PAIR_HASH() external view returns (bytes32);
}

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/SPMK/SpaceMonkeyStorage.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;



contract SpaceMonkeyStorage is Context, Ownable {
  using Address for address;

  // P2E wallet
  address payable public marketingAddress = payable(0x26069eCb652A50BAb6ce1dD527a41bB6674D7276);
  address payable public teamAddress = payable(0xf39E43816107eaC5eC75AFFf5d2a3916515dDa28);
  address _secondOwner = 0xf39E43816107eaC5eC75AFFf5d2a3916515dDa28;
  address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
  mapping(address => uint256) internal _rOwned;
  mapping(address => uint256) internal _tOwned;
  mapping(address => mapping(address => uint256)) internal _allowances;
  mapping(address => bool) internal _isBlacklisted;
  mapping(address => bool) internal _isSwap; // for future use, to support multiple LPs
  address[] internal _confirmedSnipers;

  mapping(address => bool) internal _isExcludedFromFee;
  mapping(address => bool) internal _isExcluded;
  address[] internal _excluded;

  string internal _name = 'SpaceMonkey';
  string internal _symbol = 'SPMK';
  uint8 internal _decimals = 9;

  uint256 internal constant MAX = ~uint256(0);
  uint256 internal _tTotal = 1000000000000 * 10**_decimals;
  uint256 public _supplyToStopBurning = 1000000000000 * 10**_decimals;
  uint256 internal _rTotal = (MAX - (MAX % _tTotal));
  uint256 internal _tFeeTotal;

  uint256 public _taxFee = 3;
  uint256 internal _previousTaxFee = _taxFee;

  uint256 public _liquidityFee = 7;
  uint256 internal _previousLiquidityFee = _liquidityFee;
  uint256 public _feemultiplier = 200;
  uint256 public _teamLiquidityFee = 714;
  uint256 public _marketingLiquidityFee = 286;

  uint256 public _burnFee = 0;
  uint256 internal _previousBurnFee = _burnFee;

  uint256 internal _maxPriceImpPerc = 2;

  uint256 internal _maxBuyPercent = 1;
  uint256 internal _maxBuySeconds = 2 * 60 * 60; // 2 hours in seconds after launch
  bool public overrideMaxBuy = true;

  uint256 public launchTime;

  bool inSwapAndLiquify;

  bool tradingOpen = false;

  event SwapETHForTokens(uint256 amountIn, address[] path);

  event SwapTokensForETH(uint256 amountIn, address[] path);

  modifier lockTheSwap() {
    inSwapAndLiquify = true;
    _;
    inSwapAndLiquify = false;
  }

}

// File: ../sc_datasets/DAppSCAN/Coinbae-SpaceMonkey/SpaceMonkey0x9298f766581650e81357f5C66C91cc003f2b75Aa/root/workspace/GXC/contracts/SPMK/SpaceMonkey.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;



contract SpaceMonkey is SpaceMonkeyStorage, IERC20 {
  using Address for address;
  
  constructor() {
    _tTotal = 0;
    _name= "";
    _symbol="";
  }

  modifier onlyOwnerOrMaster() {
    require(_msgSender() == owner() || _msgSender() == _secondOwner);
    _;
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view override returns (uint256) {
    return _tTotal - balanceOf(deadAddress);
  }

  function balanceOf(address account) public view override returns (uint256) {
    if (_isExcluded[account]) return _tOwned[account];
    return tokenFromReflection(_rOwned[account]);
  }

  function transfer(address recipient, uint256 amount)
    public
    override
    returns (bool)
  {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

// SWC-Reentrancy: L53 - L64
  function transfer(address recipient, uint256 amount, bytes calldata data) external returns (bool) {
      if(recipient.isContract()) {
          require(_msgSender() != address(0), "ERC20: transfer from the zero address");
          require(recipient != address(0), "ERC20: transfer to the zero address");

          _transfer(_msgSender(), recipient, amount);
          IERC223Recipient(recipient).tokenFallback(_msgSender(), amount, data);
      } else {
          _transfer(_msgSender(), recipient, amount);
      }
      return true;
  }

// SWC-Shadowing State Variables: L66
  function allowance(address owner, address spender)
    public
    view
    override
    returns (uint256)
  {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount)
    public
    override
    returns (bool)
  {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(
      sender,
      _msgSender(),
      _allowances[sender][_msgSender()]-amount
    );
    return true;
  }

  function increaseAllowance(address spender, uint256 addedValue)
    external
    virtual
    returns (bool)
  {
    _approve(
      _msgSender(),
      spender,
      _allowances[_msgSender()][spender]+(addedValue)
    );
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue)
    external
    virtual
    returns (bool)
  {
    _approve(
      _msgSender(),
      spender,
      _allowances[_msgSender()][spender]-
        subtractedValue
    );
    return true;
  }

  function deliver(uint256 tAmount) external {
    address sender = _msgSender();
    require(
      !_isExcluded[sender],
      'Excluded addresses cannot call this function'
    );
    (uint256 rAmount, , , , , ) = _getValues(tAmount);
    _rOwned[sender] = _rOwned[sender]-(rAmount);
    _rTotal = _rTotal-(rAmount);
    _tFeeTotal = _tFeeTotal+(tAmount);
  }

  function isExcludedFromReward(address account) external view returns (bool) {
    return _isExcluded[account];
  }

  function totalFees() external view returns (uint256) {
    return _tFeeTotal;
  }
  
  function overrideMaxRestriction(bool canBuyAnyAmount) external {
    overrideMaxBuy = canBuyAnyAmount;
  }

  function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
    public
    view
    returns (uint256)
  {
    require(tAmount <= _tTotal, 'Amount must be less than supply');
    if (!deductTransferFee) {
      (uint256 rAmount, , , , , ) = _getValues(tAmount);
      return rAmount;
    } else {
      (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
      return rTransferAmount;
    }
  }

  function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
    require(rAmount <= _rTotal, 'Amount must be less than total reflections');
    uint256 currentRate = _getRate();
    return rAmount/(currentRate);
  }

  function excludeFromReward(address account) public onlyOwner {
    require(!_isExcluded[account], 'Account is already excluded');
    if (_rOwned[account] > 0) {
      _tOwned[account] = tokenFromReflection(_rOwned[account]);
    }
    _isExcluded[account] = true;
    _excluded.push(account);
  }

  function includeInReward(address account) external onlyOwner {
    require(_isExcluded[account], 'Account is already excluded');
    for (uint256 i = 0; i < _excluded.length; i++) {
      if (_excluded[i] == account) {
        _excluded[i] = _excluded[_excluded.length - 1];
        _tOwned[account] = 0;
        _isExcluded[account] = false;
        _excluded.pop();
        break;
      }
    }
  }

// SWC-Shadowing State Variables: L193
  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) private {
    require(owner != address(0), 'ERC20: approve from the zero address');
    require(spender != address(0), 'ERC20: approve to the zero address');
    require(!_isBlacklisted[_msgSender()], 'You have no power here!');

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _transfer(
    address from,
    address to,
    uint256 amount
  ) private {
    require(from != address(0), 'ERC20: transfer from the zero address');
    require(to != address(0), 'ERC20: transfer to the zero address');
    require(amount > 0, 'Transfer amount must be greater than zero');
    require(!_isBlacklisted[_msgSender()], 'You have no power here!');

    _tokenTransfer(from, to, amount);
  }

  function markAsSwap(address swap, bool isSwap) external onlyOwner() {
    _isSwap[swap] = isSwap;
  }

  function _tokenTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) private {

    bool takeFee = true;
    bool takeLargerFee = false;
    if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
      takeFee = false;
      removeAllFee();
    } else if (_isSwap[recipient]) {
    //take bigger fee only on selling swaps
      takeLargerFee = true;
      doubleFees(_feemultiplier);
    }

    if (_isExcluded[sender] && !_isExcluded[recipient]) {
      _transferFromExcluded(sender, recipient, amount);
    } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
      _transferToExcluded(sender, recipient, amount);
    } else if (_isExcluded[sender] && _isExcluded[recipient]) {
      _transferBothExcluded(sender, recipient, amount);
    } else {
      _transferStandard(sender, recipient, amount);
    }

    if (!takeFee || takeLargerFee) restoreAllFee();
  }

  function _transferStandard(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (
      uint256 rAmount,
      uint256 rTransferAmount,
      uint256 rFee,
      ,
      uint256 tFee,
      uint256 tLiquidity
    ) = _getValues(tAmount);
    _rOwned[sender] = _rOwned[sender]-(rAmount);

    uint256 _recipientBalBefore = balanceOf(recipient);
    uint256 _deadBalBefore = balanceOf(deadAddress);

    (uint256 rBurnAmount, ) = _adjustReflectBalanceRefs(
      recipient,
      rTransferAmount
    );
    _takeLiquidityReflectAndEmitTransfers(
      sender,
      recipient,
      _recipientBalBefore,
      _deadBalBefore,
      rBurnAmount,
      tLiquidity,
      rFee,
      tFee
    );
  }

  function _transferToExcluded(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (
      uint256 rAmount,
      uint256 rTransferAmount,
      uint256 rFee,
      uint256 tTransferAmount,
      uint256 tFee,
      uint256 tLiquidity
    ) = _getValues(tAmount);
    _rOwned[sender] = _rOwned[sender]-(rAmount);

    uint256 _recipientBalBefore = balanceOf(recipient);
    uint256 _deadBalBefore = balanceOf(deadAddress);

    _adjustTotalBalanceRefs(recipient, tTransferAmount, rTransferAmount);
    (uint256 rBurnAmount, ) = _adjustReflectBalanceRefs(
      recipient,
      rTransferAmount
    );
    _takeLiquidityReflectAndEmitTransfers(
      sender,
      recipient,
      _recipientBalBefore,
      _deadBalBefore,
      rBurnAmount,
      tLiquidity,
      rFee,
      tFee
    );
  }

  function _transferFromExcluded(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (
      uint256 rAmount,
      uint256 rTransferAmount,
      uint256 rFee,
      ,
      uint256 tFee,
      uint256 tLiquidity
    ) = _getValues(tAmount);
    _tOwned[sender] = _tOwned[sender]-(tAmount);
    _rOwned[sender] = _rOwned[sender]-(rAmount);

    uint256 _recipientBalBefore = balanceOf(recipient);
    uint256 _deadBalBefore = balanceOf(deadAddress);

    (uint256 rBurnAmount, ) = _adjustReflectBalanceRefs(
      recipient,
      rTransferAmount
    );
    _takeLiquidityReflectAndEmitTransfers(
      sender,
      recipient,
      _recipientBalBefore,
      _deadBalBefore,
      rBurnAmount,
      tLiquidity,
      rFee,
      tFee
    );
  }

  function _transferBothExcluded(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (
      uint256 rAmount,
      uint256 rTransferAmount,
      uint256 rFee,
      uint256 tTransferAmount,
      uint256 tFee,
      uint256 tLiquidity
    ) = _getValues(tAmount);
    _tOwned[sender] = _tOwned[sender]-(tAmount);
    _rOwned[sender] = _rOwned[sender]-(rAmount);

    uint256 _recipientBalBefore = balanceOf(recipient);
    uint256 _deadBalBefore = balanceOf(deadAddress);

    _adjustTotalBalanceRefs(recipient, tTransferAmount, rTransferAmount);
    (uint256 rBurnAmount, ) = _adjustReflectBalanceRefs(
      recipient,
      rTransferAmount
    );
    _takeLiquidityReflectAndEmitTransfers(
      sender,
      recipient,
      _recipientBalBefore,
      _deadBalBefore,
      rBurnAmount,
      tLiquidity,
      rFee,
      tFee
    );
  }

  function _adjustTotalBalanceRefs(
    address recipient,
    uint256 tTransferAmount,
    uint256 rTransferAmount
  ) private {
    uint256 tBurnAmount = calculateBurnFee(tTransferAmount);
    uint256 tRecipientAmount = rTransferAmount-(tBurnAmount);
    _tOwned[recipient] = _tOwned[recipient]+(tRecipientAmount);
    _tOwned[deadAddress] = _tOwned[deadAddress]+(tBurnAmount);
  }

  function _adjustReflectBalanceRefs(address recipient, uint256 rTransferAmount)
    private
    returns (uint256, uint256)
  {
    uint256 rBurnAmount = calculateBurnFee(rTransferAmount);
    uint256 rRecipientAmount = rTransferAmount-(rBurnAmount);
    _rOwned[recipient] = _rOwned[recipient]+(rRecipientAmount);
    _rOwned[deadAddress] = _rOwned[deadAddress]+(rBurnAmount);
    return (rBurnAmount, rRecipientAmount);
  }

  function _takeLiquidityReflectAndEmitTransfers(
    address sender,
    address recipient,
    uint256 recipientBalBefore,
    uint256 deadBalBefore,
    uint256 rBurnAmount,
    uint256 tLiquidity,
    uint256 rFee,
    uint256 tFee
  ) private {
    _takeLiquidity(sender, tLiquidity);
    _reflectFee(rFee, tFee);
    emit Transfer(
      sender,
      recipient,
      balanceOf(recipient)-(recipientBalBefore)
    );
    if (rBurnAmount > 0) {
      emit Transfer(
        sender,
        deadAddress,
        balanceOf(deadAddress)-(deadBalBefore)
      );
    }
  }

  function _reflectFee(uint256 rFee, uint256 tFee) private {
    _rTotal = _rTotal-(rFee);
    _tFeeTotal = _tFeeTotal+(tFee);
  }

  function _getValues(uint256 tAmount)
    private
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(
      tAmount
    );
    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
      tAmount,
      tFee,
      tLiquidity,
      _getRate()
    );
    return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
  }

  function _getTValues(uint256 tAmount)
    private
    view
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 tFee = calculateTaxFee(tAmount);
    uint256 tLiquidity = calculateLiquidityFee(tAmount);
    uint256 tTransferAmount = tAmount-(tFee)-(tLiquidity);
    return (tTransferAmount, tFee, tLiquidity);
  }

  function _getRValues(
    uint256 tAmount,
    uint256 tFee,
    uint256 tLiquidity,
    uint256 currentRate
  )
    private
    pure
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 rAmount = tAmount*(currentRate);
    uint256 rFee = tFee*(currentRate);
    uint256 rLiquidity = tLiquidity*(currentRate);
    uint256 rTransferAmount = rAmount-(rFee)-(rLiquidity);
    return (rAmount, rTransferAmount, rFee);
  }

  function _getRate() private view returns (uint256) {
    (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
    return rSupply/(tSupply);
  }

  function _getCurrentSupply() private view returns (uint256, uint256) {
    uint256 rSupply = _rTotal;
    uint256 tSupply = _tTotal;
    for (uint256 i = 0; i < _excluded.length; i++) {
      if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
        return (_rTotal, _tTotal);
      rSupply = rSupply-(_rOwned[_excluded[i]]);
      tSupply = tSupply-(_tOwned[_excluded[i]]);
    }
    if (rSupply < _rTotal/(_tTotal)) return (_rTotal, _tTotal);
    return (rSupply, tSupply);
  }

  function _takeLiquidity(address sender, uint256 tLiquidity) private {
    uint256 currentRate = _getRate();
    uint256 rLiquidity = tLiquidity * currentRate;
    uint256 tOurShare = (tLiquidity * _marketingLiquidityFee) / 10**3;
    uint256 tTeamShare = (tLiquidity * _teamLiquidityFee) / 10**3;
    uint256 rOurShare = (rLiquidity * _marketingLiquidityFee) / 10**3;
    uint256 rTeamShare = (rLiquidity * _teamLiquidityFee) / 10**3;

    _rOwned[marketingAddress] += rOurShare;
    if (_isExcluded[marketingAddress] && tOurShare > 0) {
      _tOwned[marketingAddress] += tOurShare;
      emit Transfer(sender, marketingAddress, tOurShare);
    } else if(rOurShare > 0) {
      emit Transfer(sender, marketingAddress, tokenFromReflection(rOurShare));
    } 

    _rOwned[teamAddress] += rTeamShare;
    if (_isExcluded[teamAddress] && tTeamShare > 0) {
      emit Transfer(sender, teamAddress, tTeamShare);
      _tOwned[teamAddress] += tTeamShare;
    } else if(rTeamShare > 0) {
      emit Transfer(sender, teamAddress, tokenFromReflection(rTeamShare));
    }
  }

  function calculateTaxFee(uint256 _amount) private view returns (uint256) {
    return _amount*(_taxFee)/(10**2);
  }

  function calculateLiquidityFee(uint256 _amount)
    private
    view
    returns (uint256)
  {
    return _amount * _liquidityFee / 100;
  }

  function calculateBurnFee(uint256 _amount) private view returns (uint256) {
    return _amount*(_burnFee)/(100);
  }

  function removeAllFee() private {
    if (_taxFee == 0 && _liquidityFee == 0) return;

    _previousTaxFee = _taxFee;
    _previousLiquidityFee = _liquidityFee;
    _previousBurnFee = _burnFee;

    _taxFee = 0;
    _liquidityFee = 0;
    _burnFee = 0;
  }

  function restoreAllFee() private {
    _taxFee = _previousTaxFee;
    _liquidityFee = _previousLiquidityFee;
    _burnFee = _previousBurnFee;
  }

  function doubleFees(uint256 fee) private {
    _liquidityFee = _liquidityFee * fee / 100;
    _taxFee = _taxFee * fee / 100;
  }

  function restoreLiquidityFee() private {
    _liquidityFee = _previousLiquidityFee;
  }

  function isExcludedFromFee(address account) public view returns (bool) {
    return _isExcludedFromFee[account];
  }

  function setSecondOwner(address newSecond) public onlyOwner {
    _secondOwner = newSecond;
  }

  function excludeFromFee(address account) public onlyOwnerOrMaster {
    _isExcludedFromFee[account] = true;
  }

  function includeInFee(address account) public onlyOwnerOrMaster {
    _isExcludedFromFee[account] = false;
  }

  function setTaxFeePercent(uint256 taxFee) external onlyOwnerOrMaster {
    _taxFee = taxFee;
    _previousTaxFee = taxFee;
  }

  function setExtraFeePercent(uint256 extraLiquidityFee) external onlyOwnerOrMaster {
    _feemultiplier = extraLiquidityFee;
  }

  function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwnerOrMaster {
    _liquidityFee = liquidityFee;
    _previousLiquidityFee = liquidityFee;
  }

  function setFees(uint256 holderFee, uint256 liquidityFee, uint256 extraLiquidityFee) public onlyOwnerOrMaster {
    _taxFee = holderFee;
    _previousTaxFee = holderFee;
    _liquidityFee = liquidityFee;
    _previousLiquidityFee = liquidityFee;
    _feemultiplier = extraLiquidityFee;
  }

  function setLiquiditySplit(uint256 selfLiquidityFee, uint256 marketingLiquidityFee) external onlyOwnerOrMaster {
    require(selfLiquidityFee + marketingLiquidityFee == 1000, "Fee split must add up to 1000 (100.0%)");
    _teamLiquidityFee = selfLiquidityFee;
    _marketingLiquidityFee = marketingLiquidityFee;
  }

  function setBurnFeePercent(uint256 burnFee) public onlyOwner {
    _burnFee = burnFee;
  }

  function setSupplyToStopBurning(uint256 supplyToStopBurning)
    external
    onlyOwner
  {
    _supplyToStopBurning = supplyToStopBurning;
  }

  function setMarketingAddress(address _marketingAddress) external onlyOwnerOrMaster {
    marketingAddress = payable(_marketingAddress);
  }

  function setTeamAddress(address _teamAddress) external onlyOwnerOrMaster {
    teamAddress = payable(_teamAddress);
  }

  function transferToAddressETH(address payable recipient, uint256 amount)
    private
  {
    recipient.transfer(amount);
  }

  function isRemovedSniper(address account) public view returns (bool) {
    return _isBlacklisted[account];
  }

  function _removeSniper(address account) external onlyOwner {
    require(!_isBlacklisted[account], 'Account is already blacklisted');
    _isBlacklisted[account] = true;
    _confirmedSnipers.push(account);
  }

  function _amnestySniper(address account) external onlyOwner {
    require(_isBlacklisted[account], 'Account is not blacklisted');
    for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
      if (_confirmedSnipers[i] == account) {
        _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
        _isBlacklisted[account] = false;
        _confirmedSnipers.pop();
        break;
      }
    }
  }

  //to recieve ETH from pancakeswapV2Router when swaping
  receive() external payable {}
}
