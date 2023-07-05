// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/interfaces/IVault.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IVault {
  // call from controller must impl.
  function underlying() external view returns (address);
  function isDuetVault() external view returns (bool);
  function liquidate(address liquidator, address borrower, bytes calldata data) external;
  function userValue(address user, bool dp) external view returns(uint);
  function pendingValue(address user, int pending) external view returns(uint);
  function underlyingAmountValue(uint amount, bool dp) external view returns(uint value);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/interfaces/IController.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IController {
  function dyTokens(address) external view returns (address);
  function getValueConf(address _underlying) external view returns (address oracle, uint16 dr, uint16 pr);
  function getValueConfs(address token0, address token1) external view returns (address oracle0, uint16 dr0, uint16 pr0, address oracle1, uint16 dr1, uint16 pr1);

  function strategies(address) external view returns (address);
  function dyTokenVaults(address) external view returns (address);

  function beforeDeposit(address , address _vault, uint) external view;
  function beforeBorrow(address _borrower, address _vault, uint256 _amount) external view;
  function beforeWithdraw(address _redeemer, address _vault, uint256 _amount) external view;
  function beforeRepay(address _repayer , address _vault, uint256 _amount) external view;

  function joinVault(address _user, bool isDeposit) external;
  function exitVault(address _user, bool isDeposit) external;

  function userValues(address _user, bool _dp) external view returns(uint totalDepositValue, uint totalBorrowValue);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/interfaces/IDYToken.sol

//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0;


interface IDYToken {
  function deposit(uint _amount, address _toVault) external;
  function depositTo(address _to, uint _amount, address _toVault) external;
  function depositCoin(address to, address _toVault) external payable;

  function withdraw(address _to, uint _shares, bool needWETH) external;
  function underlyingTotal() external view returns (uint);

  function underlying() external view returns(address);
  function balanceOfUnderlying(address _user) external view returns (uint);
  function underlyingAmount(uint amount) external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/interfaces/IFeeConf.sol

//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IFeeConf {
  function getConfig(bytes32 _key) external view returns (address, uint); 
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/interfaces/IMintVault.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IMintVault {

  function borrows(address user) external view returns(uint amount);
  function borrow(uint256 amount) external;
  function repay(uint256 amount) external;
  function repayTo(address to, uint256 amount) external;

  function valueToAmount(uint value, bool dp) external view returns(uint amount);

}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/interfaces/IDepositVault.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IDepositVault {

  function deposits(address user) external view returns(uint amount);
  function deposit(address dtoken, uint256 amount) external;
  function depositTo(address dtoken, address to, uint256 amount) external;
  function syncDeposit(address dtoken, uint256 amount, address user) external;

  function withdraw(uint256 amount, bool unpack) external;
  function withdrawTo(address to, uint256 amount, bool unpack) external;

}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/Constants.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract Constants {
  uint public constant PercentBase = 10000;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet/duet-collateral-contracts-92452dad092d6b5f76713484e30159b5fa75ea80/contracts/mock/Reader.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;






contract Reader is Constants {
  IFeeConf private feeConf;
  IController private controller;

  constructor(address _controller, address _feeConf) {
    controller = IController(_controller);
    feeConf = IFeeConf(_feeConf);
  }

  // underlyingAmount : such as lp amount;
  function getVaultPrice(address vault, uint underlyingAmount, bool _dp) external view returns(uint256 value) {
    // calc dytoken amount;
    address dytoken = IVault(vault).underlying();

    uint amount = IERC20(dytoken).totalSupply() * underlyingAmount / IDYToken(dytoken).underlyingTotal();
    value = IVault(vault).underlyingAmountValue(amount, _dp);
  } 

  // 
  function depositVaultValues(address[] memory _vaults, bool _dp) external view returns (uint256[] memory amounts, uint256[] memory values) {
    uint len = _vaults.length;
    values = new uint[](len);
    amounts = new uint[](len);

    for (uint256 i = 0; i < len; i++) {
      address dytoken = IVault(_vaults[i]).underlying();
      require(dytoken != address(0), "no dytoken");

      uint amount = IERC20(dytoken).balanceOf(_vaults[i]);
      if (amount == 0) {
        amounts[i] = 0;
        values[i] = 0;
      } else {
        uint value =  IVault(_vaults[i]).underlyingAmountValue(amount, _dp);
        amounts[i] = amount;
        values[i] = value;
      }
    }
  }

  // 获取用户所有仓位价值:
  function userVaultValues(address _user, address[] memory  _vaults, bool _dp) external view returns (uint256[] memory values) {
    uint len = _vaults.length;
    values = new uint[](len);

    for (uint256 i = 0; i < len; i++) {
      values[i] = IVault(_vaults[i]).userValue(_user, _dp);
    }
  }

  // 获取用户所有仓位数量（dyToken 数量及底层币数量）
  function userVaultDepositAmounts(address _user, address[] memory _vaults) 
    external view returns (uint256[] memory amounts, uint256[] memory underAmounts) {
    uint len = _vaults.length;
    amounts = new uint[](len);
    underAmounts = new uint[](len);

    for (uint256 i = 0; i < len; i++) {
      amounts[i] = IDepositVault(_vaults[i]).deposits(_user);
      address underlying = IVault(_vaults[i]).underlying();
      if (amounts[i] == 0) {
        underAmounts[i] = 0;
      } else {
        underAmounts[i] = IDYToken(underlying).underlyingAmount(amounts[i]);
      }
    }
  }

    // 获取用户所有借款数量
  function userVaultBorrowAmounts(address _user, address[] memory _vaults) external view returns (uint256[] memory amounts) {
    uint len = _vaults.length;
    amounts = new uint[](len);

    for (uint256 i = 0; i < len; i++) {
      amounts[i] = IMintVault(_vaults[i]).borrows(_user);
    }
  }

// 根据输入，预估实际可借和费用
  function pendingBorrow(uint amount) external view returns(uint actualBorrow, uint fee) {
    (, uint borrowFee) = feeConf.getConfig("borrow_fee");

    fee = amount * borrowFee / PercentBase;
    actualBorrow = amount - fee;
  }

// 根据输入，预估实际转换和费用
  function pendingRepay(address borrower, address vault, uint amount) external view returns(uint actualRepay, uint fee) {
    uint256 borrowed = IMintVault(vault).borrows(borrower);
    if(borrowed == 0) {
      return (0, 0);
    }

    (address receiver, uint repayFee) = feeConf.getConfig("repay_fee");
    fee = borrowed * repayFee / PercentBase;
    if (amount > borrowed + fee) {  // repay all.
      actualRepay = borrowed;
    } else {
      actualRepay = amount * PercentBase / (PercentBase + repayFee);
      fee = amount - actualRepay;
    }
  }

  // 获取多个用户的价值
  function usersVaules(address[] memory users, bool dp) external view returns(uint[] memory totalDeposits, uint[] memory totalBorrows) {
    uint len = users.length;
    totalDeposits = new uint[](len);
    totalBorrows = new uint[](len);

    for (uint256 i = 0; i < len; i++) {
      (totalDeposits[i], totalBorrows[i]) = controller.userValues(users[i], dp);
    }
  }

}
