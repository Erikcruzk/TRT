// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IERC20Minimal.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.5.0;

interface IERC20Minimal {
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function decimals() external view returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/libraries/TransferHelper.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes("approve(address,uint256)")));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "AF");
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes("transfer(address,uint256)")));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TF");
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TFF");
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, "ETF");
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IVault.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IVault {
    event DepositCollateral(uint256 vaultID, uint256 amount);
    event WithdrawCollateral(uint256 vaultID, uint256 amount);
    event Borrow(uint256 vaultID, uint256 amount);
    event PayBack(uint256 vaultID, uint256 borrow, uint256 paybackFee, uint256 amount);
    event CloseVault(uint256 vaultID, uint256 amount, uint256 closingFee);
    event Liquidated(uint256 vaultID, address collateral, uint256 amount);
    /// Getters
    /// Address of a manager
    function  factory() external view returns (address);
    /// Address of a manager
    function  manager() external view returns (address);
    /// Address of debt;
    function  debt() external view returns (address);
    /// Address of vault ownership registry
    function  v1() external view returns (address);
    /// address of a collateral
    function  collateral() external view returns (address);
    /// Vault global identifier
    function vaultId() external view returns (uint);
    /// borrowed amount 
    function borrow() external view returns (uint256);
    /// created block timestamp
    function createdAt() external view returns (uint256);
    /// address of wrapped eth
    function  WETH() external view returns (address);
    /// Total debt amount with interest
    function getDebt() external returns (uint256);
    /// V2 factory address for liquidation
    function v2Factory() external view returns (address);
    /// Vault status
    function getStatus() external view returns (address collateral, uint256 cBalance, address debt, uint256 dBalance);

    /// Functions
    function liquidate() external;
    function depositCollateralNative() payable external;
    function depositCollateral(uint256 amount_) external;
    function withdrawCollateralNative(uint256 amount_) payable external;
    function withdrawCollateral(uint256 amount_) external;
    function borrowMore(uint256 cAmount_, uint256 dAmount_) external;
    function payDebt(uint256 amount_) external;
    function closeVault(uint256 amount_) external;

}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IVaultManager.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IVaultManager {

    /// View funcs
    /// Stablecoin address
    function stablecoin() external view returns (address);
    /// VaultFactory address
    function factory() external view returns (address);
    /// Address of feeTo
    function feeTo() external view returns (address);
    /// Address of the dividend pool
    function dividend() external view returns (address);
    /// Address of Standard treasury
    function treasury() external view returns (address);
    /// Address of liquidator
    function liquidator() external view returns (address);
    /// Desired of supply of stablecoin to be minted
    function desiredSupply() external view returns (uint256);
    /// Switch to on/off rebase
    function rebaseActive() external view returns (bool);

    /// Getters
    /// Get Config of CDP
    function getCDPConfig(address collateral) external view returns (uint, uint, uint, uint, bool);
    function getCDecimal(address collateral) external view returns(uint);
    function getMCR(address collateral) external view returns(uint);
    function getLFR(address collateral) external view returns(uint);
    function getSFR(address collateral) external view returns(uint);
    function getOpen(address collateral_) external view returns (bool);
    function getAssetPrice(address asset) external returns (uint);
    function getAssetValue(address asset, uint256 amount) external returns (uint256);
    function isValidCDP(address collateral, address debt, uint256 cAmount, uint256 dAmount) external returns (bool);
    function isValidSupply(uint256 issueAmount_) external returns (bool);
    function createCDP(address collateral_, uint cAmount_, uint dAmount_) external returns (bool success);

    /// Event
    event VaultCreated(uint256 vaultId, address collateral, address debt, address creator, address vault, uint256 cAmount, uint256 dAmount);
    event CDPInitialized(address collateral, uint mcr, uint lfr, uint sfr, uint8 cDecimals);
    event RebaseActive(bool set);
    event SetFees(address feeTo, address treasury, address dividend);
    event Rebase(uint256 totalSupply, uint256 desiredSupply);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IERC721Minimal.sol

// SPDX-License-Identifier: Apache-2.0


pragma solidity ^0.8.0;

interface IERC721Minimal {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IV1.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IV1 {
    function mint(address to, uint256 tokenId_) external;
    function burn(uint256 tokenId_) external;
    function burnFromVault(uint vaultId_) external;
    function exists(uint256 tokenId_) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IWETH.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.5.0;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IUniswapV2FactoryMinimal.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.5.0;

interface IUniswapV2FactoryMinimal {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IStablecoin.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IStablecoin {
    function mint(address to, uint256 amount) external;

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;

    function mintFromVault(address factory, uint256 vaultId_, address to, uint256 amount) external;

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/Vault.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;









contract Vault is IVault {
  /// Uniswap v2 factory interface
  address public override v2Factory;
  /// Address of a manager
  address public override manager;
  /// Address of a factory
  address public override factory;
  /// Address of debt;
  address public override debt;
  /// Address of vault ownership registry
  address public override v1;
  /// Address of a collateral
  address public override collateral;
  /// Vault global identifier
  uint256 public override vaultId;
  /// Borrowed amount
  uint256 public override borrow;
  /// Created block timestamp
  uint256 public override createdAt;
  /// Address of wrapped eth
  address public override WETH;

  constructor() public {
    factory = msg.sender;
    createdAt = block.timestamp;
  }

  modifier onlyVaultOwner() {
    require(
      IERC721Minimal(v1).ownerOf(vaultId) == msg.sender,
      "Vault: Vault is not owned by you"
    );
    _;
  }

  // called once by the factory at time of deployment
  function initialize(
    address manager_,
    uint256 vaultId_,
    address collateral_,
    address debt_,
    address v1_,
    uint256 amount_,
    address v2Factory_,
    address weth_
  ) external {
    require(msg.sender == factory, "Vault: FORBIDDEN"); // sufficient check
    vaultId = vaultId_;
    collateral = collateral_;
    debt = debt_;
    v1 = v1_;
    borrow = amount_;
    v2Factory = v2Factory_;
    WETH = weth_;
    manager = manager_;
  }
  // SWC-Shadowing State Variables: L72-89
  function getStatus()
    external
    view
    override
    returns (
      address collateral,
      uint256 cBalance,
      address debt,
      uint256 dBalance
    )
  {
    return (
      collateral,
      IERC20Minimal(collateral).balanceOf(address(this)),
      debt,
      IERC20Minimal(debt).balanceOf(address(this))
    );
  }

  function liquidate() external override {
    require(
      !IVaultManager(manager).isValidCDP(
        collateral,
        debt,
        IERC20Minimal(collateral).balanceOf(address(this)),
        IERC20Minimal(debt).balanceOf(address(this))
      ),
      "Vault: Position is still safe"
    );
    // check the pair if it exists
    address pair = IUniswapV2FactoryMinimal(v2Factory).getPair(
      collateral,
      debt
    );
    require(pair != address(0), "Vault: Liquidating pair not supported");
    uint256 balance = IERC20Minimal(collateral).balanceOf(address(this));
    uint256 lfr = IVaultManager(manager).getLFR(collateral);
    uint256 liquidationFee = (lfr * balance) / 100;
    uint256 left = _sendFee(collateral, balance, liquidationFee);
    // Distribute collaterals
    address liquidator = IVaultManager(manager).liquidator();
    TransferHelper.safeTransfer(collateral, liquidator, left);
    // burn vault nft
    _burnV1FromVault();
    emit Liquidated(vaultId, collateral, balance);
    // self destruct the contract, send remaining balance if collateral is native currency
    selfdestruct(payable(msg.sender));
  }

  function depositCollateralNative() external payable override onlyVaultOwner {
    require(collateral == WETH, "Vault: collateral is not a native asset");
    // wrap deposit
    IWETH(WETH).deposit{ value: msg.value }();
    emit DepositCollateral(vaultId, msg.value);
  }

  function depositCollateral(uint256 amount_) external override onlyVaultOwner {
    TransferHelper.safeTransferFrom(
      collateral,
      msg.sender,
      address(this),
      amount_
    );
    emit DepositCollateral(vaultId, amount_);
  }

  /// Withdraw collateral as native currency
  function withdrawCollateralNative(uint256 amount_)
    external
    payable
    override
    onlyVaultOwner
  {
    require(collateral == WETH, "Vault: collateral is not a native asset");
    if (borrow != 0) {
      require(
        IVaultManager(manager).isValidCDP(
          collateral,
          debt,
          IERC20Minimal(collateral).balanceOf(address(this)) - amount_,
          borrow
        ),
        "Vault: below MCR"
      );
    }
    // unwrap collateral
    IWETH(WETH).withdraw(amount_);
    // send withdrawn native currency
    TransferHelper.safeTransferETH(msg.sender, address(this).balance);
    emit WithdrawCollateral(vaultId, amount_);
  }

  function withdrawCollateral(uint256 amount_)
    external
    override
    onlyVaultOwner
  {
    require(
      IERC20Minimal(collateral).balanceOf(address(this)) >= amount_,
      "Vault: Not enough collateral"
    );
    if (borrow != 0) {
      uint256 test = IERC20Minimal(collateral).balanceOf(address(this)) - amount_;
      require(
        IVaultManager(manager).isValidCDP(collateral,debt,test,borrow) == true,
        "Vault: below MCR"
      );
      
    }
    TransferHelper.safeTransfer(collateral, msg.sender, amount_);
    emit WithdrawCollateral(vaultId, amount_);
  }

  function borrowMore(
    uint256 cAmount_,
    uint256 dAmount_
  ) external override onlyVaultOwner {
    // get vault balance
    uint256 deposits = IERC20Minimal(collateral).balanceOf(address(this));
    // check position
    require(IVaultManager(manager).isValidCDP(collateral, debt, cAmount_+ deposits, dAmount_), "IP"); // Invalid Position
    // check rebased supply of stablecoin
    require(IVaultManager(manager).isValidSupply(dAmount_), "RB"); // Rebase limited mtr borrow
    // transfer collateral to the vault, manage collateral from there
    TransferHelper.safeTransferFrom(collateral, msg.sender, address(this), cAmount_);
    // mint mtr to the sender
    IStablecoin(debt).mintFromVault(factory, vaultId, msg.sender, dAmount_);
  }

  function borrowMoreNative(
    uint256 dAmount_
  ) external payable onlyVaultOwner {
    // get vault balance
    uint256 deposits = IERC20Minimal(WETH).balanceOf(address(this));
    // check position
    require(IVaultManager(manager).isValidCDP(collateral, debt, msg.value + deposits, dAmount_), "IP"); // Invalid Position
    // check rebased supply of stablecoin
    require(IVaultManager(manager).isValidSupply(dAmount_), "RB"); // Rebase limited mtr borrow
    // wrap native currency
    IWETH(WETH).deposit{value: address(this).balance}();
    // mint mtr to the sender
    IStablecoin(debt).mintFromVault(factory, vaultId, msg.sender, dAmount_);
  }

  function payDebt(uint256 amount_) external override onlyVaultOwner {
    // calculate debt with interest
    uint256 fee = _calculateFee();
    require(amount_ != 0, "Vault: amount is zero");
    // send MTR to the vault
    TransferHelper.safeTransferFrom(debt, msg.sender, address(this), amount_);
    uint256 left = _sendFee(debt, amount_, fee);
    _burnMTRFromVault(left);
    borrow -= left;
    emit PayBack(vaultId, borrow, fee, amount_);
  }

  function closeVault(uint256 amount_) external override onlyVaultOwner {
    // calculate debt with interest
    uint256 fee = _calculateFee();
    require(fee + borrow == amount_, "Vault: not enough balance to payback");
    // send MTR to the vault
    TransferHelper.safeTransferFrom(debt, msg.sender, address(this), amount_);
    // send fee to the pool
    uint256 left = _sendFee(debt, amount_, fee);
    // burn mtr debt with interest
    _burnMTRFromVault(left);
    // burn vault nft
    _burnV1FromVault();
    emit CloseVault(vaultId, amount_, fee);
    // self destruct the contract, send remaining balance if collateral is native currency
    selfdestruct(payable(msg.sender));
  }

  function _burnV1FromVault() internal {
    IV1(v1).burnFromVault(vaultId);
  }

  function _burnMTRFromVault(uint256 amount_) internal {
    IStablecoin(debt).burn(amount_);
  }

  function _calculateFee() internal returns (uint256) {
    uint256 assetValue = IVaultManager(manager).getAssetValue(debt, borrow);
    uint256 sfr = IVaultManager(manager).getSFR(collateral);
    /// (sfr * assetValue/100) * (duration in months)
    uint256 sfrTimesV = sfr * assetValue;
    // get duration in months
    uint256 duration = (block.timestamp - createdAt) / 60 / 60 / 24 / 30;
    require(sfrTimesV >= assetValue); // overflow check
    return (sfrTimesV / 100) * duration;
  }

  function getDebt() external override returns (uint256) {
    return _calculateFee() + borrow;
  }

  function _sendFee(
    address asset_,
    uint256 amount_,
    uint256 fee_
  ) internal returns (uint256 left) {
    address dividend = IVaultManager(manager).dividend();
    address feeTo = IVaultManager(manager).feeTo();
    address treasury = IVaultManager(manager).treasury();
    bool feeOn = feeTo != address(0);
    bool treasuryOn = treasury != address(0);
    bool dividendOn = dividend != address(0);
    // send fee to the pool
    if (feeOn) {
      if (dividendOn) {
        uint256 half = fee_ / 2;
        TransferHelper.safeTransfer(asset_, dividend, half);
        TransferHelper.safeTransfer(asset_, feeTo, half);
      } else if (dividendOn && treasuryOn) {
        uint256 third = fee_ / 3;
        TransferHelper.safeTransfer(asset_, dividend, third);
        TransferHelper.safeTransfer(asset_, feeTo, third);
        TransferHelper.safeTransfer(asset_, treasury, third);
      } else {
        TransferHelper.safeTransfer(asset_, feeTo, fee_);
      }
    }
    return amount_ - fee_;
  }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/utils/CalHash.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

contract CallHash {
    // calculates the CREATE2 address for a vault without making any external calls
    function vaultFor(address manager, uint256 vaultId, bytes32 code) internal pure returns (address vault) {
        vault = address(uint160(uint(keccak256(abi.encodePacked(
                hex"ff",
                manager,
                keccak256(abi.encodePacked(vaultId)),
                code // init code hash
            )))));
    }
}
