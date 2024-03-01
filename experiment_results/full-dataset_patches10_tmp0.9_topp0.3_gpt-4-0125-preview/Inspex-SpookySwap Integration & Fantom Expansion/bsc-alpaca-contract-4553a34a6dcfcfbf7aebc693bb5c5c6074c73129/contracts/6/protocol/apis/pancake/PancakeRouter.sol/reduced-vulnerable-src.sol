

pragma solidity ^0.6.0;




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



pragma solidity >=0.5.0;

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
}
















pragma solidity >=0.5.0;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint256 value) external returns (bool);
    function withdraw(uint256) external;
}



pragma solidity ^0.6.0;














library SafeMath {
    








    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    








    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    








    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    








    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    










    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    










    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    










    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    










    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}



pragma solidity >=0.5.0;

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



pragma solidity >=0.5.0;


library PancakeLibrary {
  using SafeMath for uint;

  
  function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
    require(tokenA != tokenB, "PancakeLibrary: IDENTICAL_ADDRESSES");
    (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    require(token0 != address(0), "PancakeLibrary: ZERO_ADDRESS");
  }

  
  function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
    return IPancakeFactory(factory).getPair(tokenA, tokenB); 
  }

  
  function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
    (address token0,) = sortTokens(tokenA, tokenB);
    pairFor(factory, tokenA, tokenB);
    (uint reserve0, uint reserve1,) = IPancakePair(pairFor(factory, tokenA, tokenB)).getReserves();
    (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
  }

  
  function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
    require(amountA > 0, "PancakeLibrary: INSUFFICIENT_AMOUNT");
    require(reserveA > 0 && reserveB > 0, "PancakeLibrary: INSUFFICIENT_LIQUIDITY");
    amountB = amountA.mul(reserveB) / reserveA;
  }

  
  function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
    require(amountIn > 0, "PancakeLibrary: INSUFFICIENT_INPUT_AMOUNT");
    require(reserveIn > 0 && reserveOut > 0, "PancakeLibrary: INSUFFICIENT_LIQUIDITY");
    uint amountInWithFee = amountIn.mul(998);
    uint numerator = amountInWithFee.mul(reserveOut);
    uint denominator = reserveIn.mul(1000).add(amountInWithFee);
    amountOut = numerator / denominator;
  }

  
  function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
    require(amountOut > 0, "PancakeLibrary: INSUFFICIENT_OUTPUT_AMOUNT");
    require(reserveIn > 0 && reserveOut > 0, "PancakeLibrary: INSUFFICIENT_LIQUIDITY");
    uint numerator = reserveIn.mul(amountOut).mul(1000);
    uint denominator = reserveOut.sub(amountOut).mul(998);
    amountIn = (numerator / denominator).add(1);
  }

  
  function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
    require(path.length >= 2, "PancakeLibrary: INVALID_PATH");
    amounts = new uint[](path.length);
    amounts[0] = amountIn;
    for (uint i; i < path.length - 1; i++) {
      (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
      amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
    }
  }

  
  function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
    require(path.length >= 2, "PancakeLibrary: INVALID_PATH");
    amounts = new uint[](path.length);
    amounts[amounts.length - 1] = amountOut;
    for (uint i = path.length - 1; i > 0; i--) {
      (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
      amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
    }
  }
}



pragma solidity >=0.5.0;

interface IPancakeRouter02 {
  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  )
    external
    returns (
      uint256 amountA,
      uint256 amountB,
      uint256 liquidity
    );

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  )
    external
    payable
    returns (
      uint256 amountToken,
      uint256 amountETH,
      uint256 liquidity
    );

  function removeLiquidity(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETH(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountToken, uint256 amountETH);

  function removeLiquidityWithPermit(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETHWithPermit(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountToken, uint256 amountETH);

  function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactETHForTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function swapTokensForExactETH(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactTokensForETH(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapETHForExactTokens(
    uint256 amountOut,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function quote(
    uint256 amountA,
    uint256 reserveA,
    uint256 reserveB
  ) external pure returns (uint256 amountB);

  function getAmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountOut);

  function getAmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountIn);

  function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

  function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

  function removeLiquidityETHSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountETH);

  function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountETH);

  function swapExactTokensForTokensSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;

  function swapExactETHForTokensSupportingFeeOnTransferTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable;

  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;
}
















pragma solidity 0.6.6;

interface ERC20Interface {
  function balanceOf(address user) external view returns (uint256);
}

library SafeToken {
  function myBalance(address token) internal view returns (uint256) {
    return ERC20Interface(token).balanceOf(address(this));
  }

  function balanceOf(address token, address user) internal view returns (uint256) {
    return ERC20Interface(token).balanceOf(user);
  }

  function safeApprove(address token, address to, uint256 value) internal {
    
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
  }

  function safeTransfer(address token, address to, uint256 value) internal {
    
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
  }

  function safeTransferFrom(address token, address from, address to, uint256 value) internal {
    
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
  }

  function safeTransferETH(address to, uint256 value) internal {
    
    (bool success, ) = to.call{value: value}(new bytes(0));
    require(success, "!safeTransferETH");
  }
}



pragma solidity 0.6.6;




contract PancakeRouter is IPancakeRouter02 {
  using SafeMath for uint;

  address public immutable override factory;
  address public immutable override WETH;

  modifier ensure(uint deadline) {
    require(deadline >= block.timestamp, 'PancakeRouter: EXPIRED');
    _;
  }

  constructor(address _factory, address _WETH) public {
    factory = _factory;
    WETH = _WETH;
  }

  receive() external payable {
    assert(msg.sender == WETH); 
  }

  
  function _addLiquidity(
      address tokenA,
      address tokenB,
      uint amountADesired,
      uint amountBDesired,
      uint amountAMin,
      uint amountBMin
  ) internal virtual returns (uint amountA, uint amountB) {
    
    if (IPancakeFactory(factory).getPair(tokenA, tokenB) == address(0)) {
      IPancakeFactory(factory).createPair(tokenA, tokenB);
    }
    (uint reserveA, uint reserveB) = PancakeLibrary.getReserves(factory, tokenA, tokenB);
    if (reserveA == 0 && reserveB == 0) {
      (amountA, amountB) = (amountADesired, amountBDesired);
    } else {
      uint amountBOptimal = PancakeLibrary.quote(amountADesired, reserveA, reserveB);
      if (amountBOptimal <= amountBDesired) {
          require(amountBOptimal >= amountBMin, 'PancakeRouter: INSUFFICIENT_B_AMOUNT');
          (amountA, amountB) = (amountADesired, amountBOptimal);
      } else {
          uint amountAOptimal = PancakeLibrary.quote(amountBDesired, reserveB, reserveA);
          assert(amountAOptimal <= amountADesired);
          require(amountAOptimal >= amountAMin, 'PancakeRouter: INSUFFICIENT_A_AMOUNT');
          (amountA, amountB) = (amountAOptimal, amountBDesired);
      }
    }
  }

  function addLiquidity(
      address tokenA,
      address tokenB,
      uint amountADesired,
      uint amountBDesired,
      uint amountAMin,
      uint amountBMin,
      address to,
      uint deadline
  ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
    (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
    address pair = PancakeLibrary.pairFor(factory, tokenA, tokenB);
    SafeToken.safeTransferFrom(tokenA, msg.sender, pair, amountA);
    SafeToken.safeTransferFrom(tokenB, msg.sender, pair, amountB);
    liquidity = IPancakePair(pair).mint(to);
  }

  function addLiquidityETH(
    address token,
    uint amountTokenDesired,
    uint amountTokenMin,
    uint amountETHMin,
    address to,
    uint deadline
  ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
    (amountToken, amountETH) = _addLiquidity(
      token,
      WETH,
      amountTokenDesired,
      msg.value,
      amountTokenMin,
      amountETHMin
    );
    address pair = PancakeLibrary.pairFor(factory, token, WETH);
    SafeToken.safeTransferFrom(token, msg.sender, pair, amountToken);
    IWETH(WETH).deposit{value: amountETH}();
    assert(IWETH(WETH).transfer(pair, amountETH));
    liquidity = IPancakePair(pair).mint(to);
    
    if (msg.value > amountETH) SafeToken.safeTransferETH(msg.sender, msg.value - amountETH);
  }

  
  function removeLiquidity(
    address tokenA,
    address tokenB,
    uint liquidity,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
  ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
    address pair = PancakeLibrary.pairFor(factory, tokenA, tokenB);
    IPancakePair(pair).transferFrom(msg.sender, pair, liquidity); 
    (uint amount0, uint amount1) = IPancakePair(pair).burn(to);
    (address token0,) = PancakeLibrary.sortTokens(tokenA, tokenB);
    (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
    require(amountA >= amountAMin, 'PancakeRouter: INSUFFICIENT_A_AMOUNT');
    require(amountB >= amountBMin, 'PancakeRouter: INSUFFICIENT_B_AMOUNT');
  }

  function removeLiquidityETH(
    address token,
    uint liquidity,
    uint amountTokenMin,
    uint amountETHMin,
    address to,
    uint deadline
  ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
    (amountToken, amountETH) = removeLiquidity(
      token,
      WETH,
      liquidity,
      amountTokenMin,
      amountETHMin,
      address(this),
      deadline
    );
    SafeToken.safeTransfer(token, to, amountToken);
    IWETH(WETH).withdraw(amountETH);
    SafeToken.safeTransferETH(to, amountETH);
  }

  function removeLiquidityWithPermit(
    address tokenA,
    address tokenB,
    uint liquidity,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline,
    bool approveMax, uint8 v, bytes32 r, bytes32 s
  ) external virtual override returns (uint amountA, uint amountB) {
    address pair = PancakeLibrary.pairFor(factory, tokenA, tokenB);
    uint value = approveMax ? uint(-1) : liquidity;
    IPancakePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
    (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
  }

  function removeLiquidityETHWithPermit(
    address token,
    uint liquidity,
    uint amountTokenMin,
    uint amountETHMin,
    address to,
    uint deadline,
    bool approveMax, uint8 v, bytes32 r, bytes32 s
  ) external virtual override returns (uint amountToken, uint amountETH) {
    address pair = PancakeLibrary.pairFor(factory, token, WETH);
    uint value = approveMax ? uint(-1) : liquidity;
    IPancakePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
    (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
  }

  
  function removeLiquidityETHSupportingFeeOnTransferTokens(
    address token,
    uint liquidity,
    uint amountTokenMin,
    uint amountETHMin,
    address to,
    uint deadline
  ) public virtual override ensure(deadline) returns (uint amountETH) {
    (, amountETH) = removeLiquidity(
      token,
      WETH,
      liquidity,
      amountTokenMin,
      amountETHMin,
      address(this),
      deadline
    );
    SafeToken.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
    IWETH(WETH).withdraw(amountETH);
    SafeToken.safeTransferETH(to, amountETH);
  }

  function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
    address token,
    uint liquidity,
    uint amountTokenMin,
    uint amountETHMin,
    address to,
    uint deadline,
    bool approveMax, uint8 v, bytes32 r, bytes32 s
  ) external virtual override returns (uint amountETH) {
    address pair = PancakeLibrary.pairFor(factory, token, WETH);
    uint value = approveMax ? uint(-1) : liquidity;
    IPancakePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
    amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
      token, liquidity, amountTokenMin, amountETHMin, to, deadline
    );
  }

  
  
  function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
    for (uint i; i < path.length - 1; i++) {
      (address input, address output) = (path[i], path[i + 1]);
      (address token0,) = PancakeLibrary.sortTokens(input, output);
      uint amountOut = amounts[i + 1];
      (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
      address to = i < path.length - 2 ? PancakeLibrary.pairFor(factory, output, path[i + 2]) : _to;
      IPancakePair(PancakeLibrary.pairFor(factory, input, output)).swap(
        amount0Out, amount1Out, to, new bytes(0)
      );
    }
  }

  function swapExactTokensForTokens(
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
  ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
    amounts = PancakeLibrary.getAmountsOut(factory, amountIn, path);
    require(amounts[amounts.length - 1] >= amountOutMin, 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
    SafeToken.safeTransferFrom(
      path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
    );
    _swap(amounts, path, to);
  }

  function swapTokensForExactTokens(
      uint amountOut,
      uint amountInMax,
      address[] calldata path,
      address to,
      uint deadline
  ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
    amounts = PancakeLibrary.getAmountsIn(factory, amountOut, path);
    require(amounts[0] <= amountInMax, 'PancakeRouter: EXCESSIVE_INPUT_AMOUNT');
    SafeToken.safeTransferFrom(
        path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
    );
    _swap(amounts, path, to);
  }

  function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    virtual
    override
    payable
    ensure(deadline)
    returns (uint[] memory amounts)
  {
    require(path[0] == WETH, 'PancakeRouter: INVALID_PATH');
    amounts = PancakeLibrary.getAmountsOut(factory, msg.value, path);
    require(amounts[amounts.length - 1] >= amountOutMin, 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
    IWETH(WETH).deposit{value: amounts[0]}();
    assert(IWETH(WETH).transfer(PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
    _swap(amounts, path, to);
  }

  function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    virtual
    override
    ensure(deadline)
    returns (uint[] memory amounts)
  {
    require(path[path.length - 1] == WETH, 'PancakeRouter: INVALID_PATH');
    amounts = PancakeLibrary.getAmountsIn(factory, amountOut, path);
    require(amounts[0] <= amountInMax, 'PancakeRouter: EXCESSIVE_INPUT_AMOUNT');
    SafeToken.safeTransferFrom(
        path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
    );
    _swap(amounts, path, address(this));
    IWETH(WETH).withdraw(amounts[amounts.length - 1]);
    SafeToken.safeTransferETH(to, amounts[amounts.length - 1]);
  }

  function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    virtual
    override
    ensure(deadline)
    returns (uint[] memory amounts)
  {
    require(path[path.length - 1] == WETH, 'PancakeRouter: INVALID_PATH');
    amounts = PancakeLibrary.getAmountsOut(factory, amountIn, path);
    require(amounts[amounts.length - 1] >= amountOutMin, 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
    SafeToken.safeTransferFrom(
        path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
    );
    _swap(amounts, path, address(this));
    IWETH(WETH).withdraw(amounts[amounts.length - 1]);
    SafeToken.safeTransferETH(to, amounts[amounts.length - 1]);
  }

  function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    virtual
    override
    payable
    ensure(deadline)
    returns (uint[] memory amounts)
  {
    require(path[0] == WETH, 'PancakeRouter: INVALID_PATH');
    amounts = PancakeLibrary.getAmountsIn(factory, amountOut, path);
    require(amounts[0] <= msg.value, 'PancakeRouter: EXCESSIVE_INPUT_AMOUNT');
    IWETH(WETH).deposit{value: amounts[0]}();
    assert(IWETH(WETH).transfer(PancakeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
    _swap(amounts, path, to);
    
    if (msg.value > amounts[0]) SafeToken.safeTransferETH(msg.sender, msg.value - amounts[0]);
  }

  
  
  function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
    for (uint i; i < path.length - 1; i++) {
      (address input, address output) = (path[i], path[i + 1]);
      (address token0,) = PancakeLibrary.sortTokens(input, output);
      IPancakePair pair = IPancakePair(PancakeLibrary.pairFor(factory, input, output));
      uint amountInput;
      uint amountOutput;
      { 
        (uint reserve0, uint reserve1,) = pair.getReserves();
        (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
        amountOutput = PancakeLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
      }
      (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
      address to = i < path.length - 2 ? PancakeLibrary.pairFor(factory, output, path[i + 2]) : _to;
      pair.swap(amount0Out, amount1Out, to, new bytes(0));
    }
  }

  function swapExactTokensForTokensSupportingFeeOnTransferTokens(
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
  ) external virtual override ensure(deadline) {
    SafeToken.safeTransferFrom(
      path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amountIn
    );
    uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
    _swapSupportingFeeOnTransferTokens(path, to);
    require(
      IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
      'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT'
    );
  }

  function swapExactETHForTokensSupportingFeeOnTransferTokens(
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
  )
    external
    virtual
    override
    payable
    ensure(deadline)
  {
    require(path[0] == WETH, 'PancakeRouter: INVALID_PATH');
    uint amountIn = msg.value;
    IWETH(WETH).deposit{value: amountIn}();
    assert(IWETH(WETH).transfer(PancakeLibrary.pairFor(factory, path[0], path[1]), amountIn));
    uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
    _swapSupportingFeeOnTransferTokens(path, to);
    require(
      IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
      'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT'
    );
  }

  function swapExactTokensForETHSupportingFeeOnTransferTokens(
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
  )
      external
      virtual
      override
      ensure(deadline)
  {
    require(path[path.length - 1] == WETH, 'PancakeRouter: INVALID_PATH');
    SafeToken.safeTransferFrom(
        path[0], msg.sender, PancakeLibrary.pairFor(factory, path[0], path[1]), amountIn
    );
    _swapSupportingFeeOnTransferTokens(path, address(this));
    uint amountOut = IERC20(WETH).balanceOf(address(this));
    require(amountOut >= amountOutMin, 'PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT');
    IWETH(WETH).withdraw(amountOut);
    SafeToken.safeTransferETH(to, amountOut);
  }

  
  function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
    return PancakeLibrary.quote(amountA, reserveA, reserveB);
  }

  function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
    public
    pure
    virtual
    override
    returns (uint amountOut)
  {
    return PancakeLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
  }

  function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
    public
    pure
    virtual
    override
    returns (uint amountIn)
  {
    return PancakeLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
  }

  function getAmountsOut(uint amountIn, address[] memory path)
    public
    view
    virtual
    override
    returns (uint[] memory amounts)
  {
    return PancakeLibrary.getAmountsOut(factory, amountIn, path);
  }

  function getAmountsIn(uint amountOut, address[] memory path)
    public
    view
    virtual
    override
    returns (uint[] memory amounts)
  {
    return PancakeLibrary.getAmountsIn(factory, amountOut, path);
  }
}