// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_uniswap/v2-core/contracts/libraries/UQ112x112.sol

// SPDX-License-Identifier: ISC

pragma solidity =0.7.6;

// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))

// range: [0, 2**112 - 1]
// resolution: 1 / 2**112

library UQ112x112 {
    uint224 constant Q112 = 2**112;

    // encode a uint112 as a UQ112x112
    function encode(uint112 y) internal pure returns (uint224 z) {
        z = uint224(y) * Q112; // never overflows
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
        z = x / uint224(y);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol

// SPDX-License-Identifier: GNU

pragma solidity =0.7.6;

interface IUniswapV2Pair {
//    event Approval(address indexed owner, address indexed spender, uint value);
//    event Transfer(address indexed from, address indexed to, uint value);

//    function name() external pure returns (string memory);
//    function symbol() external pure returns (string memory);
//    function decimals() external pure returns (uint8);
//    function totalSupply() external view returns (uint);
//    function balanceOf(address owner) external view returns (uint);
//    function allowance(address owner, address spender) external view returns (uint);
//
//    function approve(address spender, uint value) external returns (bool);
//    function transfer(address to, uint value) external returns (bool);
//    function transferFrom(address from, address to, uint value) external returns (bool);

//    function DOMAIN_SEPARATOR() external view returns (bytes32);
//    function PERMIT_TYPEHASH() external pure returns (bytes32);
//    function nonces(address owner) external view returns (uint);
//
//    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
//
//    event Mint(address indexed sender, uint amount0, uint amount1);
//    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
//    event Swap(
//        address indexed sender,
//        uint amount0In,
//        uint amount1In,
//        uint amount0Out,
//        uint amount1Out,
//        address indexed to
//    );
    event Sync(uint112 reserve0, uint112 reserve1);

//    function MINIMUM_LIQUIDITY() external pure returns (uint);
//    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
//    function kLast() external view returns (uint);
//
//    function mint(address to) external returns (uint liquidity);
//    function burn(address to) external returns (uint amount0, uint amount1);
//    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
//    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol

// SPDX-License-Identifier: GNU

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
//    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

//    function feeTo() external view returns (address);
//    function feeToSetter() external view returns (address);
//
//    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_uniswap/v2-core/contracts/libraries/UniSafeMath.sol

// SPDX-License-Identifier: ISC

pragma solidity =0.7.6;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library UniSafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_openzeppelin/token/ERC20/IERC20.sol

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_uniswap/v2-core/contracts/UniswapV2Pair.sol

// SPDX-License-Identifier: ISC

pragma solidity =0.7.6;





contract UniswapV2Pair is IUniswapV2Pair {
    using UniSafeMath  for uint;
    using UQ112x112 for uint224;

    uint public constant MINIMUM_LIQUIDITY = 10 ** 3;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    address public factory;
    address public _token0;
    address public _token1;

    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves
    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves

    uint public _price0CumulativeLast;
    uint public _price1CumulativeLast;
    uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

    constructor() {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(address __token0, address __token1) override external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN');
        // sufficient check
        _token0 = __token0;
        _token1 = __token1;
    }

    function getReserves() override public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    function token0() override external view returns (address){
        return _token0;
    }
    function token1() override external view returns (address){
        return _token1;
    }

    function price0CumulativeLast() override external view returns (uint){
        return _price0CumulativeLast;
    }
    function price1CumulativeLast() override external view returns (uint){
        return _price1CumulativeLast;
    }

    // update reserves and, on the first call per block, price accumulators
    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            // * never overflows, and + overflow is desired
            _price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
            _price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        emit Sync(reserve0, reserve1);
    }

    // force reserves to match balances
    function sync() override external {
        _update(IERC20(_token0).balanceOf(address(this)), IERC20(_token1).balanceOf(address(this)), reserve0, reserve1);
    }
}
