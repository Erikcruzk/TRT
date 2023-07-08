// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/InterestRate/InterestRateModel.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  * @title InterestRateModel Interface
  * @author Amplify
  */
abstract contract InterestRateModel {
	bool public isInterestRateModel = true;

    struct GracePeriod {
        uint256 fee;
        uint256 start;
        uint256 end;
    }

    /**
     * @notice Calculates the utilization rate of the market: `borrows / (cash + borrows)`
     * @param cash The amount of cash in the pool
     * @param borrows The amount of borrows in the pool
     * @return The utilization rate as a mantissa between [0, 1e18]
     */
    function utilizationRate(uint256 cash, uint256 borrows) external virtual pure returns (uint256);

    /**
     * @notice Calculates the borrow rate for a given interest rate and GracePeriod length
     * @param interestRate The interest rate as a percentage number between [0, 100]
     * @return The borrow rate as a mantissa between  [0, 1e18]
     */
    function getBorrowRate(uint256 interestRate) external virtual view returns (uint256);

    /**
     * @notice Calculates the penalty fee for a given days range
     * @param index The index of the grace period record
     * @return The penalty fee as a mantissa between [0, 1e18]
     */
    function getPenaltyFee(uint8 index) external virtual view returns (uint256);

    /**
     * @notice Returns the penalty stages array
     */
    function getGracePeriod() external virtual view returns (GracePeriod[] memory);
    function getGracePeriodSnapshot() external virtual view returns (GracePeriod[] memory, uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC721/IERC721.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);

    function balanceOf(address owner) external view returns (uint balance);
    function ownerOf(uint tokenId) external view returns (address owner);
    
    function transferFrom(address from, address to, uint tokenId) external;
    function approve(address to, uint tokenId) external;
}

interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint tokenId) external view returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Asset/AssetInterface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract AssetInterface is IERC721 {
    bool public isAssetsFactory = true;

    function getTokenInfo(uint256 _tokenId) external virtual view returns (uint256, uint256, uint256, uint256, string memory, string memory, address, bool);
    function markAsRedeemed(uint256 tokenId) external virtual;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/LossProvisionPool/LossProvisionInterface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract LossProvisionInterface {
    bool public isLossProvision = true;

    /**
     * @notice Calculates the percentage of the loan's principal that is paid as fee: `(lossProvisionFee + buyBackProvisionFee)`
     * @return The total fees percentage as a mantissa between [0, 1e18]
     */
    function getFeesPercent() external virtual view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20Base {
    function balanceOf(address owner) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address src, address dst, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
}

interface IERC20 is IERC20Base {
    function totalSupply() external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);

    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

interface IERC20Burnable is IERC20 {
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Controller/ControllerStorage.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




abstract contract ControllerStorage {
    uint256 public amptDepositAmount = 10e18;

    LossProvisionInterface public provisionPool;
    InterestRateModel public interestRateModel;
    IERC20 public amptToken;
    AssetInterface public assetsFactory;

    struct Borrower {
        uint256 debtCeiling;
        uint256 ratingMantissa;
        bool whitelisted;
        bool created;
    }
    mapping(address => Borrower) public borrowers;

    struct Application {
        address lender;
        uint256 depositAmount;
        uint256 mapIndex;
        bool created;
        bool whitelisted;
    }

    struct PoolInfo {
        address owner;
        bool isActive;
    }

    mapping(address => PoolInfo) public pools;
    mapping(address => mapping(address => Application)) internal poolApplicationsByLender;

    mapping(address => Application[]) public poolApplications;


    mapping(address => address[]) internal borrowerPools;
    mapping(address => address[]) internal lenderJoinedPools;
    mapping(address => mapping(address => bool)) internal lenderJoinedPoolsMap;
    mapping(address => mapping(address => bool)) public borrowerWhitelists;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/CarefulMath.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract CarefulMath {

    enum MathError {
        NO_ERROR,
        DIVISION_BY_ZERO,
        INTEGER_OVERFLOW,
        INTEGER_UNDERFLOW
    }

    function mulUInt(uint a, uint b) internal pure returns(MathError, uint) {
        if (a == 0) {
            return (MathError.NO_ERROR, 0);
        }

        uint c = a * b;

        if (c / a != b) {
            return (MathError.INTEGER_OVERFLOW, 0);
        } else {
            return (MathError.NO_ERROR, c);
        }
    }

    function mulThenAddUInt(uint a, uint b, uint c) internal pure returns(MathError, uint) {
        (MathError err, uint mul) = mulUInt(a, b);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return addUInt(mul, c);
    }

    function divUInt(uint a, uint b) internal pure returns(MathError, uint) {
        if (b == 0) {
            return (MathError.DIVISION_BY_ZERO, 0);
        }

        return (MathError.NO_ERROR, a / b);
    }

    function subUInt(uint a, uint b) internal pure returns(MathError, uint) {
        if (b <= a) {
            return (MathError.NO_ERROR, a - b);
        } else {
            return (MathError.INTEGER_UNDERFLOW, 0);
        }
    }

    function subThenDivUInt(uint a, uint b, uint c) internal pure returns(MathError, uint) {
        (MathError err, uint sub) = subUInt(a, b);

        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return divUInt(sub, c);
    }

    function addUInt(uint a, uint b) internal pure returns(MathError, uint) {
        uint c = a + b;

        if (c >= a) {
            return (MathError.NO_ERROR, c);
        } else {
            return (MathError.INTEGER_OVERFLOW, 0);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/ExponentialDouble.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract ExponentialDouble is CarefulMath {
    uint constant expScale = 1e18;
    uint constant doubleScale = 1e36;

    struct Exp {
        uint mantissa;
    }

    struct Double {
        uint mantissa;
    }
    function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(uint a, uint b) pure internal returns (uint) {
        return add_(a, b, "addition overflow");
    }

    function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        uint c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(uint a, uint b) pure internal returns (uint) {
        return sub_(a, b, "subtraction underflow");
    }

    function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
    }

    function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Exp memory b) pure internal returns (uint) {
        return mul_(a, b.mantissa) / expScale;
    }

    function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
    }

    function mul_(Double memory a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Double memory b) pure internal returns (uint) {
        return mul_(a, b.mantissa) / doubleScale;
    }

    function mul_(uint a, uint b) pure internal returns (uint) {
        return mul_(a, b, "multiplication overflow");
    }

    function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        if (a == 0 || b == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, errorMessage);
        return c;
    }

    function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
    }

    function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
        return Exp({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Exp memory b) pure internal returns (uint) {
        return div_(mul_(a, expScale), b.mantissa);
    }

    function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
    }

    function div_(Double memory a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Double memory b) pure internal returns (uint) {
        return div_(mul_(a, doubleScale), b.mantissa);
    }

    function div_(uint a, uint b) pure internal returns (uint) {
        return div_(a, b, "divide by zero");
    }

    function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function fraction(uint a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: div_(mul_(a, doubleScale), b)});
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Controller/Rewards.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Rewards is ExponentialDouble {
    struct Reward {
        uint index;
        uint accrued;
    }

    struct PoolState {
        bool isCreated;
        uint supplyIndex;
        uint borrowIndex;
        uint supplyBlockNumber;
        uint borrowBlockNumber;
    }

    mapping(address => mapping(address => Reward)) public borrowerState;
    mapping(address => mapping(address => Reward)) public supplierState;
    mapping(address => PoolState) public rewardsState;
    mapping(address => uint) public amptPoolSpeeds;
    address[] public rewardPools;

    function getTotalBorrowReward(address account) external view returns (uint256) {
        uint256 totalAmount;
        for(uint256 i=0; i< rewardPools.length; i++) {
            totalAmount += this.getBorrowReward(account, rewardPools[i]);
        }
        return totalAmount;
    }

    function getBorrowReward(address account, address pool) external view returns (uint256) {
        uint256 poolIndex = getNewBorrowIndex(pool);
        return getBorrowerAccruedAmount(pool, account, poolIndex);
    }

    function getTotalSupplyReward(address account) external view returns (uint256) {
        uint256 totalAmount;
        for(uint256 i=0; i< rewardPools.length; i++) {
            totalAmount += this.getSupplyReward(account, rewardPools[i]);
        }
        return totalAmount;
    }

    function getSupplyReward(address account, address pool) external view returns (uint256) {
        uint256 poolIndex = getNewSupplyIndex(pool);
        return getSupplierAccruedAmount(pool, account, poolIndex);
    }

    function claimAMPT(address holder) public {
        require(holder == msg.sender, "Only holder can claim reward");
        claimAMPT(holder, rewardPools);
    }

    function claimAMPT(address holder, address[] memory poolsList) public {
        address[] memory holders = new address[](1);
        holders[0] = holder;
        claimAMPT(holders, poolsList, true, true);
    }

    function claimAMPT(address[] memory holders, address[] memory poolsList, bool borrowers, bool suppliers) public {
        for (uint8 i = 0; i < poolsList.length; i++) {
            address pool = poolsList[i];
            if (borrowers == true) {
                updateBorrowIndexInternal(pool);
                for (uint8 j = 0; j < holders.length; j++) {
                    distributeBorrowerTokens(pool, holders[j]);
                    borrowerState[holders[j]][pool].accrued = grantRewardInternal(holders[j], borrowerState[holders[j]][pool].accrued);
                }
            }
            if (suppliers == true) {
                updateSupplyIndexInternal(pool);
                for (uint8 j = 0; j < holders.length; j++) {
                    distributeSupplierTokens(pool, holders[j]);
                    supplierState[holders[j]][pool].accrued = grantRewardInternal(holders[j], supplierState[holders[j]][pool].accrued);
                }
            }
        }
    }

    function updateBorrowIndexInternal(address pool) internal {
        rewardsState[pool].borrowIndex = getNewBorrowIndex(pool);
        rewardsState[pool].borrowBlockNumber = getBlockNumber();
    }

    struct BorrowIndexLocalVars {
        uint256 speed;
        uint256 totalPrincipal;
        uint256 blockNumber;
        uint256 deltaBlocks;
        uint256 tokensAccrued;
        Double ratio;
        Double index;
    }
    function getNewBorrowIndex(address pool) internal view returns (uint256) {
        BorrowIndexLocalVars memory vars;
        PoolState storage poolState = rewardsState[pool];

        vars.speed = amptPoolSpeeds[pool];
        (, vars.totalPrincipal) = getPoolInfo(pool);
        vars.blockNumber = getBlockNumber();
        vars.deltaBlocks = sub_(vars.blockNumber, poolState.borrowBlockNumber);
        if (vars.deltaBlocks > 0 && vars.speed > 0) {
            vars.tokensAccrued = mul_(vars.deltaBlocks, vars.speed / 2); 
            vars.ratio = vars.totalPrincipal > 0 ? fraction(vars.tokensAccrued, vars.totalPrincipal) : Double({mantissa: 0});
            vars.index = add_(Double({mantissa: poolState.borrowIndex }), vars.ratio);
            return vars.index.mantissa;
        } else {
            return poolState.borrowIndex;
        }

    }

    function updateSupplyIndexInternal(address pool) internal {
        rewardsState[pool].supplyIndex = getNewSupplyIndex(pool);
        rewardsState[pool].supplyBlockNumber = getBlockNumber();
    }

    struct SupplyIndexLocalVars {
        uint256 speed;
        uint256 totalSupply;
        uint256 blockNumber;
        uint256 deltaBlocks;
        uint256 tokensAccrued;
        Double ratio;
        Double index;
    }  
    function getNewSupplyIndex(address pool) internal view returns (uint256) {
        SupplyIndexLocalVars memory vars;
        PoolState storage poolState = rewardsState[pool];

        vars.speed = amptPoolSpeeds[pool];
        (vars.totalSupply, ) = getPoolInfo(pool);
        vars.blockNumber = getBlockNumber();
        vars.deltaBlocks = sub_(vars.blockNumber, poolState.supplyBlockNumber);
        if (vars.deltaBlocks > 0 && vars.speed > 0) {
            vars.tokensAccrued = mul_(vars.deltaBlocks, vars.speed / 2); 
            vars.ratio = vars.totalSupply > 0 ? fraction(vars.tokensAccrued, vars.totalSupply) : Double({mantissa: 0});
            vars.index = add_(Double({mantissa: poolState.supplyIndex }), vars.ratio);
            
            return vars.index.mantissa;
        }

        return poolState.supplyIndex;
    }

    function distributeBorrowerTokens(address pool, address holder) internal {
        PoolState storage borrowState = rewardsState[pool];

        borrowerState[holder][pool] = Reward({
            index: borrowState.borrowIndex,
            accrued: getBorrowerAccruedAmount(pool, holder, borrowState.borrowIndex)
        });
    }

    struct BorrowerAccruedLocalVars {
        uint256 borrowerAmount;
        uint256 borrowerDelta;
        uint256 borrowerAccrued;
        Double deltaIndex;
    }
    function getBorrowerAccruedAmount(address pool, address holder, uint poolIndex) internal view returns (uint256) {
        BorrowerAccruedLocalVars memory vars;
        Reward storage poolState = borrowerState[holder][pool];

        vars.deltaIndex = sub_(Double({mantissa: poolIndex }), Double({mantissa: poolState.index}));
        vars.borrowerAmount = getBorrowerTotalPrincipal(pool, holder);
        vars.borrowerDelta = mul_(vars.borrowerAmount, vars.deltaIndex);
        vars.borrowerAccrued = add_(poolState.accrued, vars.borrowerDelta);

        return vars.borrowerAccrued;
    }

    function distributeSupplierTokens(address pool, address holder) internal {
        PoolState storage supplyState = rewardsState[pool];

        supplierState[holder][pool] = Reward({
            index: supplyState.supplyIndex,
            accrued: getSupplierAccruedAmount(pool, holder, supplyState.supplyIndex)
        });
    }

    struct SupplierAccruedLocalVars {
        uint256 supplierBalance;
        uint256 supplierDelta;
        uint256 supplierAccrued;
        Double deltaIndex;
    }
    function getSupplierAccruedAmount(address pool, address holder, uint poolIndex) internal view returns (uint) {
        SupplierAccruedLocalVars memory vars;
        Reward storage state = supplierState[holder][pool];

        vars.deltaIndex = sub_(Double({mantissa: poolIndex }), Double({mantissa: state.index}));
        vars.supplierBalance = getSupplierBalance(pool, holder);
        vars.supplierDelta = mul_(vars.supplierBalance, vars.deltaIndex);
        vars.supplierAccrued = add_(state.accrued, vars.supplierDelta);
        return vars.supplierAccrued;
    }

    function getBorrowerTotalPrincipal(address pool, address holder) internal virtual view returns (uint256);
    
    function getSupplierBalance(address pool, address holder) internal virtual view returns (uint256);

    function getPoolInfo(address pool) internal virtual view returns (uint256, uint256);

    function grantRewardInternal(address account, uint256 amount) internal virtual returns (uint256);

    function getBlockNumber() public virtual view returns(uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Controller/StableCoin.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library StableCoin {
    struct Data {
        mapping(address => bool) flags;
        mapping(address => uint) addressIndex;
        address [] addresses;
        uint id;
    }

    function insert(Data storage self, address stableCoin) public returns (bool) {
        if (self.flags[stableCoin]) {
             return false;
        }

        self.flags[stableCoin] = true;
        self.addresses.push(stableCoin);
        self.addressIndex[stableCoin] = self.id;
        self.id++;
        return true;
    }

    function remove(Data storage self, address stableCoin) public returns (bool) {
        if (!self.flags[stableCoin]) {
            return false;
        }
        self.flags[stableCoin] = false;
        delete self.addresses[self.addressIndex[stableCoin]];
        delete self.addressIndex[stableCoin];
        return true;
    }

    function contains(Data storage self, address stableCoin) public view returns (bool) {
        return self.flags[stableCoin];
    }

    function getList(Data storage self) public view returns (address[] memory) {
        return self.addresses;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 is IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

     function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

// SWC-Transaction Order Dependence: L63 - L66
    function approve(address spender, uint amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC20/ERC20Burnable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract ERC20Burnable is ERC20 {
    function burn(uint256 amount) public virtual {
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public virtual {
        uint256 currentAllowance = allowance(account, msg.sender);
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        unchecked {
            _approve(account, msg.sender, currentAllowance - amount);
        }
        _burn(account, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC20/ERC20Mintable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract ERC20Mintable is ERC20Burnable {
    address internal _admin;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _admin = msg.sender;
    }

    function mint(address to, uint256 amount) public virtual {
        require(msg.sender == _admin, "ERC20: must have admin role to mint");
        _mint(to, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Liquidity/PoolToken.sol

// SPDX-License-Identifier: MIT
/// @dev size: 2.947 Kbytes
pragma solidity ^0.8.0;

contract PoolToken is ERC20Mintable {
    /**
    * @dev Prefix for token symbol
    */
    string internal constant prefix = "lp";
    
    constructor(
        string memory name, 
        string memory underlyingSymbol
        ) ERC20Mintable(name, createPoolTokenSymbol(underlyingSymbol)) {}

    function createPoolTokenSymbol(string memory symbol) internal pure returns (string memory){
        return string(abi.encodePacked(prefix, symbol));
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/NonZeroAddressGuard.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract NonZeroAddressGuard {

    modifier nonZeroAddress(address _address) {
        require(_address != address(0), "Address must be non-zero");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/ErrorReporter.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenErrorReporter {
    enum Error {
        NO_ERROR,
        C_LEND_REJECTION,
        C_REDEEM_REJECTION,
        C_BORRROW_REJECTION,
        C_REPAY_REJECTION,
        C_CREATE_REJECTION,
        INSUFFICIENT_FUNDS,
        AMOUNT_LOWER_THAN_0,
        AMOUNT_HIGHER,
        AMOUNT_LOWER_THAN_MIN_DEPOSIT,
        NOT_ENOUGH_CASH,
        LOAN_HAS_DEBT,
        LOAN_IS_OVERDUE,
        LOAN_IS_NOT_CLOSED,
        LOAN_ASSET_ALREADY_USED,
        LOAN_IS_ALREADY_CLOSED,
        LOAN_PENALTY_NOT_PAYED,
        WRONG_BORROWER,
        TRANSFER_FAILED,
        LPP_TRANSFER_FAILED,
        POOL_NOT_FOUND
    }

    event Failure(uint256 error, uint256 detail);

    function fail(Error err, uint256 info) internal returns (uint256) {
        emit Failure(uint256(err), info);

        return uint256(err);
    }

    function toString(Error err) internal pure returns (string memory) {
        return ErrorReporter.uint2str(uint256(err));
    }
}

contract ControllerErrorReporter {
    enum Error {
        NO_ERROR,
        POOL_NOT_ACTIVE,
        BORROW_CAP_EXCEEDED,
        NOT_ALLOWED_TO_CREATE_CREDIT_LINE,
        BORROWER_NOT_CREATED,
        BORROWER_IS_WHITELISTED,
        BORROWER_NOT_WHITELISTED,
        ALREADY_WHITELISTED,
        INVALID_OWNER,
        MATURITY_DATE_EXPIRED,
        ASSET_REDEEMED,
        AMPT_TOKEN_TRANSFER_FAILED,
        LENDER_NOT_WHITELISTED,
        BORROWER_NOT_MEMBER,
        LENDER_NOT_CREATED
    }

    event Failure(uint256 error, uint256 detail);

    function fail(Error err) internal returns (uint256) {
        emit Failure(uint256(err), 0);

        return uint256(err);
    }

    function toString(Error err) internal pure returns (string memory) {
        return ErrorReporter.uint2str(uint256(err));
    }
}

library ErrorReporter {
    function check(uint256 err) internal pure {
        require(err == 0, uint2str(uint256(err)));
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/Exponential.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Exponential is CarefulMath {
    uint constant expScale = 1e18;
    uint constant halfScale = expScale / 2;
    uint constant mantissaOne = expScale;

    struct Exp {
        uint mantissa;
    }

    function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: rational}));
    }

    function truncate(Exp memory exp) pure internal returns(uint) {
        return exp.mantissa / expScale;
    }

     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
    }

    function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(product));
    }

    function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }
        return addUInt(truncate(product), addend);
    }

    function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
    }

    function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint numerator) = mulUInt(expScale, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        return getExp(numerator, divisor.mantissa);
    }

    function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
        (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(fraction));
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Liquidity/Lender.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




abstract contract Lendable is ReentrancyGuard, NonZeroAddressGuard, Exponential, TokenErrorReporter {
    uint256 internal constant initialExchangeRate = 2e16;
    uint256 public minDeposit;

    PoolToken public lpToken;

    event Lend(address indexed account, uint256 amount, uint256 tokensAmount);
    event Redeem(address indexed account, uint256 amount, uint256 tokensAmount);

    struct LendLocalVars {
        MathError mathErr;
        uint256 exchangeRateMantissa;
        uint256 mintedTokens;
    }

    function lendInternal(address payer, address lender, uint256 amount) internal nonReentrant nonZeroAddress(lender) returns(uint256) {
        require(amount >= minDeposit, toString(Error.AMOUNT_LOWER_THAN_MIN_DEPOSIT));
        uint256 allowed = lendAllowed(address(this), lender, amount);
        require(allowed == 0, ErrorReporter.uint2str(allowed));

        LendLocalVars memory vars;

        (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateInternal();
        ErrorReporter.check(uint256(vars.mathErr));

        require(_transferTokens(payer, address(this), amount));

        (vars.mathErr, vars.mintedTokens) = divScalarByExpTruncate(amount, Exp({mantissa: vars.exchangeRateMantissa}));
        ErrorReporter.check(uint256(vars.mathErr));
        
        lpToken.mint(lender, vars.mintedTokens);

        emit Lend(lender, amount, vars.mintedTokens);
        return uint256(Error.NO_ERROR);
    }

    struct RedeemLocalVars {
        MathError mathErr;
        uint256 exchangeRateMantissa;
        uint256 redeemTokens;
        uint256 redeemAmount;
    }

    function redeemInternal(address redeemer, uint256 _amount, uint256 _tokenAmount) internal nonReentrant returns(uint256) {
        require(_amount == 0 || _tokenAmount == 0, "one of _amount or _tokenAmount must be zero");

        RedeemLocalVars memory vars;

        (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateInternal();
        ErrorReporter.check(uint256(vars.mathErr));


        if (_tokenAmount > 0) {
            vars.redeemTokens = _tokenAmount;

            (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), _tokenAmount);
            ErrorReporter.check(uint256(vars.mathErr));
        } else {
            (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(_amount, Exp({mantissa: vars.exchangeRateMantissa}));
            ErrorReporter.check(uint256(vars.mathErr));

            vars.redeemAmount = _amount;
        }

        uint256 allowed = redeemAllowed(address(this), redeemer, vars.redeemTokens);
        require(allowed == 0, ErrorReporter.uint2str(allowed));

        require(balanceOf(redeemer) >= vars.redeemTokens, toString(Error.AMOUNT_HIGHER));
        require(this.getCash() >= vars.redeemAmount, toString(Error.NOT_ENOUGH_CASH));

        lpToken.burnFrom(redeemer, vars.redeemTokens);
        _transferTokens(address(this), redeemer, vars.redeemAmount);

        emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
        return uint256(Error.NO_ERROR);
    }

    function exchangeRate() public view returns (uint256) {
        (MathError err, uint256 result) = exchangeRateInternal();
        ErrorReporter.check(uint256(err));
        return result;
    }

    function exchangeRateInternal() internal view returns (MathError, uint256) {
        uint256 _totalSupply = totalSupply();
        if (_totalSupply == 0) {
            return (MathError.NO_ERROR, initialExchangeRate);
        } else {
            Exp memory _exchangeRate;

            uint256 totalCash = getCash();
            uint256 totalBorrowed = getTotalBorrowBalance();

            (MathError mathErr, uint256 cashPlusBorrows) = addUInt(totalCash, totalBorrowed);
            if (mathErr != MathError.NO_ERROR) {
                return (mathErr, 0);
            }
            
            (mathErr, _exchangeRate) = getExp(cashPlusBorrows, _totalSupply);
            if (mathErr != MathError.NO_ERROR) {
                return (mathErr, 0);
            }

            return (MathError.NO_ERROR, _exchangeRate.mantissa);
        }
    }

    function balanceOf(address account) public view returns (uint256) {
        return lpToken.balanceOf(account);
    }

    function balanceOfUnderlying(address owner) external view returns (uint256) {
        Exp memory _exchangeRate = Exp({ mantissa: exchangeRate() });
        (MathError mErr, uint balance) = mulScalarTruncate(_exchangeRate, balanceOf(owner));
        ErrorReporter.check(uint256(mErr));
        return balance;
    }

    function totalSupply() public virtual view returns (uint256) {
        return lpToken.totalSupply();
    }

    function getCash() public virtual view returns (uint256);
    function getTotalBorrowBalance() public virtual view returns (uint256);

    function _transferTokens(address from, address to, uint256 amount) internal virtual returns (bool);

    function lendAllowed(address _pool, address _lender, uint256 _amount) internal virtual returns (uint256);
    function redeemAllowed(address _pool, address _redeemer, uint256 _tokenAmount) internal virtual returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/utils/Counters.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Liquidity/Borrower.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




abstract contract Borrowable is ReentrancyGuard, NonZeroAddressGuard, Exponential, TokenErrorReporter {
    using Counters for Counters.Counter;

    Counters.Counter private _loanIds;

    struct CreditLine {
        address borrower;
        uint256 borrowCap;
        uint256 borrowIndex;
        uint256 principal;
        uint256 lockedAsset;
        uint256 interestRate;
        uint256 accrualBlockNumber;
        bool isClosed;
    }

    struct PenaltyInfo {
        uint256 maturity;
        uint256 index;
        uint256 timestamp;
        bool isOpened;
    }

    CreditLine[] public creditLines;
    mapping(uint256 => PenaltyInfo) public penaltyInfo;

    mapping(uint256 => bool) public lockedAssetsIds;
    mapping(address => uint256[]) internal loansIdsByAddress;

    event CreditLineOpened(uint256 indexed loanId, uint256 indexed tokenId, address borrower, uint256 amount, uint256 maturity, uint256 interestRate);
    event CreditLineClosed(uint256 indexed loanId);
    event Borrowed(uint256 indexed loanId, uint256 _amount);
    event Repayed(uint256 indexed loanId, uint256 _amount, uint256 penaltyAmount);
    event AssetUnlocked(uint256 indexed tokenId);

    modifier onlyIfActive(uint256 _loanId, address borrower_) {
        _isActive(_loanId, borrower_);
        _;
    }

    function _isActive(uint256 _loanId, address borrower_) internal view {
        require(creditLines[_loanId].isClosed == false, toString(Error.LOAN_IS_ALREADY_CLOSED));
        require(creditLines[_loanId].borrower == borrower_, toString(Error.WRONG_BORROWER));
    }

    function totalPrincipal() public virtual view returns (uint256) {
        uint256 total = 0;
        for (uint8 i = 0; i < creditLines.length; i++) {
            total += creditLines[i].principal;
        }
        return total;
    }

    function totalInterestRate() public virtual view returns (uint256) {
        uint256 total = 0;
        for (uint8 i = 0; i < creditLines.length; i++) {
            total += creditLines[i].interestRate;
        }
        if (total != 0){
            return total / creditLines.length;
        }
        return total;
    }

    /** @dev used by rewards contract */
    function getBorrowerTotalPrincipal(address _borrower) external view returns (uint256) {
        uint256 balance;

        for(uint8 i=0; i < loansIdsByAddress[_borrower].length; i++) {
            uint256 loanId = loansIdsByAddress[_borrower][i];

            uint256 principal = creditLines[loanId].principal;
            bool penaltyStarted = penaltyInfo[loanId].isOpened;
            balance += penaltyStarted ? 0 : principal;
        }
        return balance;
    }

    function getBorrowerBalance(address _borrower) external view returns (uint256) {
        uint256 balance;

        for(uint8 i=0; i < loansIdsByAddress[_borrower].length; i++) {
            balance += borrowBalanceSnapshot(loansIdsByAddress[_borrower][i]);
        }
        return balance;
    }

    function borrowerSnapshot(uint256 loanId) external view returns (uint256, uint256) {
        (,uint256 penaltyAmount) = getPenaltyIndexAndFee(loanId);
        return (borrowBalanceSnapshot(loanId), penaltyAmount);
    }

    function getBorrowerLoans(address _borrower) external view returns(uint256[] memory) {
        return loansIdsByAddress[_borrower];
    }

    function createCreditLineInternal(address borrower, uint256 tokenId, uint256 borrowCap, uint256 interestRate, uint256 maturity) internal returns (uint256) {
        require(lockedAssetsIds[tokenId] == false, toString(Error.LOAN_ASSET_ALREADY_USED));
        uint256 loanId = _loanIds.current();
        _loanIds;

        lockedAssetsIds[tokenId] = true;
        loansIdsByAddress[borrower].push(loanId);

        creditLines.push(CreditLine({
            borrower: borrower,
            borrowCap: borrowCap,
            borrowIndex: mantissaOne,
            principal: 0,
            lockedAsset: tokenId,
            interestRate: interestRate,
            accrualBlockNumber: getBlockNumber(),
            isClosed: false
        }));

        penaltyInfo[loanId] = PenaltyInfo({
            maturity: maturity,
            index: mantissaOne,
            timestamp: maturity + 30 days,
            isOpened: false
        });

        emit CreditLineOpened(loanId, tokenId, borrower, borrowCap, maturity, interestRate);

        _loanIds.increment();
        return uint256(Error.NO_ERROR);
    }

    function closeCreditLineInternal(address borrower, uint256 loanId) internal onlyIfActive(loanId, borrower) returns (uint256) {
        CreditLine storage creditLine = creditLines[loanId];
        require(creditLine.principal == 0, "Debt should be 0");

        lockedAssetsIds[creditLine.lockedAsset] = false;
        creditLine.isClosed = true;
        delete penaltyInfo[loanId];

        emit CreditLineClosed(loanId);
        return redeemAsset(creditLine.lockedAsset);
    }

    function unlockAssetInternal(address borrower, uint256 loanId) internal returns (MathError, uint256) {
        CreditLine storage creditLine = creditLines[loanId];

        require(creditLine.borrower == borrower, toString(Error.WRONG_BORROWER));
        require(creditLine.isClosed == true, toString(Error.LOAN_IS_NOT_CLOSED));

        uint256 lockedAsset = creditLine.lockedAsset;
        // remove loan from the list
        delete creditLines[loanId];
        delete penaltyInfo[loanId];

        emit AssetUnlocked(lockedAsset);
        return (MathError.NO_ERROR, lockedAsset);
    }

    struct BorrowLocalVars {
        MathError mathErr;
        uint256 availableAmount;
        uint256 currentBorrowBalance;
        uint256 newBorrowIndex;
        uint256 newPrincipal;
        uint256 currentTimestamp;
    }
    function borrowInternal(uint256 loanId, address borrower, uint256 amount) internal nonReentrant onlyIfActive(loanId, borrower) returns (uint256) {
        uint256 allowed = borrowAllowed(address(this), borrower, amount);
        require(allowed == 0, ErrorReporter.uint2str(allowed));
        
        CreditLine storage creditLine = creditLines[loanId];
        BorrowLocalVars memory vars;

        vars.currentTimestamp = getBlockTimestamp();
        require(vars.currentTimestamp < penaltyInfo[loanId].maturity, toString(Error.LOAN_IS_OVERDUE));

        (vars.mathErr, vars.availableAmount) = subUInt(creditLine.borrowCap, creditLine.principal);
        ErrorReporter.check(uint256(vars.mathErr));
        require(vars.availableAmount >= amount, toString(Error.INSUFFICIENT_FUNDS));

        vars.currentBorrowBalance = borrowBalanceSnapshot(loanId);
        vars.newBorrowIndex = getBorrowIndex(loanId);

        (vars.mathErr, vars.newPrincipal) = addUInt(vars.currentBorrowBalance, amount);
        require(vars.mathErr == MathError.NO_ERROR, "borrow: principal failed");

        creditLine.principal = vars.newPrincipal;
        creditLine.borrowIndex = vars.newBorrowIndex;
        creditLine.accrualBlockNumber = getBlockNumber();

        assert(_transferTokensOnBorrow(address(this), borrower, amount));
        emit Borrowed(loanId, amount);

        return uint256(Error.NO_ERROR);
    }

    struct RepayLocalVars {
        MathError mathErr;
        uint256 currentBorrowBalance;
        uint256 actualRepayAmount;
        uint256 penaltyIndex;
        uint256 penaltyAmount;
    }
    function repayInternal(uint256 loanId, address payer, address borrower, uint256 amount) internal onlyIfActive(loanId, borrower) nonReentrant returns (uint256) {
        uint256 allowed = repayAllowed(address(this), payer, borrower, amount);
        require(allowed == 0, toString(Error.C_REPAY_REJECTION));

        CreditLine storage creditLine = creditLines[loanId];
        PenaltyInfo storage _penaltyInfo = penaltyInfo[loanId];
        RepayLocalVars memory vars;

        vars.currentBorrowBalance = borrowBalanceSnapshot(loanId);
        (vars.penaltyIndex, vars.penaltyAmount) = getPenaltyIndexAndFee(loanId);

        if (vars.penaltyIndex - 1e18 > 1) {
            if (!_penaltyInfo.isOpened) {
                _penaltyInfo.isOpened = true;
            }
            _penaltyInfo.timestamp = getBlockTimestamp();
            (vars.mathErr, vars.actualRepayAmount) = addUInt(vars.currentBorrowBalance, vars.penaltyAmount);
            require(vars.mathErr == MathError.NO_ERROR, "repay: penalty amount failed");
        } else {
            vars.actualRepayAmount = vars.currentBorrowBalance;
        }

        if (amount == type(uint256).max) {
            amount = vars.actualRepayAmount;
        }
        require(vars.actualRepayAmount >= amount, toString(Error.AMOUNT_HIGHER));

        (vars.mathErr, creditLine.principal) = subUInt(vars.actualRepayAmount, amount);
        require(vars.mathErr == MathError.NO_ERROR, "repay: principal failed");
        
        creditLine.borrowIndex = getBorrowIndex(loanId);
        creditLine.accrualBlockNumber = getBlockNumber();
        _penaltyInfo.index = vars.penaltyIndex;

        assert(_transferTokensOnRepay(payer, address(this), amount, vars.penaltyAmount));
        
        emit Repayed(loanId, amount, vars.penaltyAmount);
        if (creditLine.principal == 0) {
            require(closeCreditLineInternal(borrower, loanId) == 0, "close failed");
        }

        return uint256(Error.NO_ERROR);
    }
    
    struct BorrowBalanceLocalVars {
        MathError mathErr;
        uint256 principalTimesIndex;
        uint256 borrowBalance;
        uint256 borrowIndex;
    }
    function borrowBalanceSnapshot(uint256 loanId) internal view returns (uint256) {
        CreditLine storage creditLine = creditLines[loanId];
        if(creditLine.principal == 0) {
            return 0;
        }

        BorrowBalanceLocalVars memory vars;

        vars.borrowIndex = getBorrowIndex(loanId);
        (vars.mathErr, vars.principalTimesIndex) = mulUInt(creditLine.principal, vars.borrowIndex);
        require(vars.mathErr == MathError.NO_ERROR, "principal times failed");

        (vars.mathErr, vars.borrowBalance) = divUInt(vars.principalTimesIndex, creditLine.borrowIndex);
        require(vars.mathErr == MathError.NO_ERROR, "borrowBalance failed");

        return vars.borrowBalance;
    }

    function _transferTokensOnBorrow(address from, address to, uint256 amount) internal virtual returns (bool);
    function _transferTokensOnRepay(address from, address to, uint256 amount, uint256 penaltyAmount) internal virtual returns (bool);

    function borrowAllowed(address _pool, address _borrower, uint256 _amount) internal virtual returns (uint256);
    function repayAllowed(address _pool, address _payer, address _borrower, uint256 _amount) internal virtual returns (uint256);
    function redeemAsset(uint256 tokenId) internal virtual returns (uint256);

    function getBorrowIndex(uint256 loanId) public virtual view returns (uint256);
    function getTotalBorrowBalance() public virtual view returns (uint256);
    function getPenaltyIndexAndFee(uint256 loanId) public virtual view returns (uint256, uint256);
    function getBlockNumber() public virtual returns(uint256);
    function getBlockTimestamp() public virtual returns(uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/security/Ownable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Ownable {

    /// @notice owner address set on construction
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Transfers ownership role
     * @notice Changes the owner of this contract to a new address
     * @dev Only owner
     * @param _newOwner beneficiary to vest remaining tokens to
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Address must be non-zero");
        
        address currentOwner = owner;
        require(_newOwner != currentOwner, "New owner cannot be the current owner");

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Controller/ControllerInterface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




abstract contract ControllerInterface {
    // Policy hooks
    function lendAllowed(address pool, address lender, uint256 amount) external virtual returns (uint256);
    function redeemAllowed(address pool, address redeemer, uint256 tokens) external virtual returns (uint256);
    function borrowAllowed(address pool, address borrower, uint256 amount) external virtual returns (uint256);
    function repayAllowed(address pool, address payer, address borrower, uint256 amount) external virtual returns (uint256);
    function createCreditLineAllowed(address pool, address borrower, uint256 collateralAsset) external virtual returns (uint256, uint256, uint256, uint256, uint256);


    function provisionPool() external virtual view returns (LossProvisionInterface);
    function interestRateModel() external virtual view returns (InterestRateModel);
    function assetsFactory() external virtual view returns (AssetInterface);
    function amptToken() external virtual view returns (IERC20);
    
    function containsStableCoin(address _stableCoin) external virtual view returns (bool);
    function getStableCoins() external virtual view returns (address[] memory);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Liquidity/Pool.sol

// SPDX-License-Identifier: MIT
/// @dev size: 24.033 Kbytes
pragma solidity ^0.8.0;





contract Pool is Ownable, Lendable, Borrowable {
    bool public isInitialized;
    string public name;

    ControllerInterface public controller;
    IERC20Metadata public stableCoin;

    enum Access {
        Public,
        Private
    }
    uint8 public access;

    event AccessChanged(uint8 newAccess);

    function initialize(address _admin, address _stableCoin, string memory _name, uint256 _minDeposit, Access _access) external {
        _initialize(_admin, _stableCoin, _name, _minDeposit, _access);
    }

    function _initialize(address _admin, address _stableCoin, string memory _name, uint256 _minDeposit, Access _access) internal nonReentrant {
        require(!isInitialized, "already initialized");
        isInitialized = true;

        name = _name;
        minDeposit = _minDeposit;
        access = uint8(_access);

        // Set the admin address
        owner = _admin;

        // set the controller
        controller = ControllerInterface(msg.sender);

        // Set the stable coin contract
        stableCoin = IERC20Metadata(_stableCoin);

        lpToken = new PoolToken("PoolToken", stableCoin.symbol());
    }

    function changeAccess(Access _access) external onlyOwner {
        access = uint8(_access);
        emit AccessChanged(access);
    }

    /// lender override methods
    function lend(uint256 amount) external returns (uint256) {
        return lendInternal(msg.sender, msg.sender, amount);
    }
    /// @dev Controller based function for whitelisted lenders
    function _lend(uint256 amount, address lender) external returns (uint256) {
        require(msg.sender == address(controller), "wrong address");
        return lendInternal(msg.sender, lender, amount);
    }

    function redeem(uint256 tokens) external returns (uint256) {
        return redeemInternal(msg.sender, 0, tokens);
    }

    function redeemUnderlying(uint256 amount) external returns (uint256) {
        return redeemInternal(msg.sender, amount, 0);
    }

    function _transferTokens(address from, address to, uint256 amount) internal override returns (bool) {
        require(stableCoin.balanceOf(from) >= amount, toString(Error.INSUFFICIENT_FUNDS));
        if (from == address(this)) {
            require(stableCoin.transfer(to, amount), toString(Error.TRANSFER_FAILED));
        } else {
            require(stableCoin.transferFrom(from, to, amount), toString(Error.TRANSFER_FAILED));
        }
        return true;
    }

    function getCash() public override virtual view returns (uint256) {
        return stableCoin.balanceOf(address(this));
    }

    function lendAllowed(address _pool, address _lender, uint256 _amount) internal override returns (uint256) {
        return controller.lendAllowed(_pool, _lender, _amount);
    }

    function redeemAllowed(address _pool, address _redeemer, uint256 _tokenAmount) internal override returns (uint256) {
        return controller.redeemAllowed(_pool, _redeemer, _tokenAmount);
    }

    // borrower override methods
    struct CreditLineLocalVars {
        uint256 allowed;
        uint256 assetValue;
        uint256 borrowCap;
        uint256 interestRate;
        uint256 advanceRate;
        uint256 maturity;
    }
    function createCreditLine(uint256 tokenId) external nonReentrant returns (uint256) {
        CreditLineLocalVars memory vars;
        (
            vars.allowed, 
            vars.assetValue, 
            vars.maturity, 
            vars.interestRate, 
            vars.advanceRate
        ) = controller.createCreditLineAllowed(address(this), msg.sender, tokenId);
        if (vars.allowed != 0) {
            return uint256(Error.C_CREATE_REJECTION);
        }

        vars.borrowCap = vars.assetValue * vars.advanceRate / 100;
        return createCreditLineInternal(msg.sender, tokenId, vars.borrowCap, vars.interestRate, vars.maturity);
    }

    function closeCreditLine(uint256 loanId) external nonReentrant returns (uint256) {
        return closeCreditLineInternal(msg.sender, loanId);
    }

    function redeemAsset(uint256 tokenId) internal override returns (uint256) {
        controller.assetsFactory().markAsRedeemed(tokenId);
        return uint256(Error.NO_ERROR);
    }

    struct UnlockLocalVars {
        MathError mathErr;
        uint256 lockedAsset;
    }
    function unlockAsset(uint256 loanId) external nonReentrant returns (uint256) {
        UnlockLocalVars memory vars;

        (vars.mathErr, vars.lockedAsset) = unlockAssetInternal(msg.sender, loanId);
        ErrorReporter.check((uint256(vars.mathErr)));

        controller.assetsFactory().transferFrom(address(this), msg.sender, vars.lockedAsset);
        return uint256(Error.NO_ERROR);
    }

    function borrow(uint256 loanId, uint256 amount) external returns (uint256) {
        return borrowInternal(loanId, msg.sender, amount);
    }

    function repay(uint256 loanId, uint256 amount) external returns (uint256) {
        return repayInternal(loanId, msg.sender, msg.sender, amount);
    }

    function repayBehalf(address borrower, uint256 loanId, uint256 amount) external returns (uint256) {
        return repayInternal(loanId, msg.sender, borrower, amount);
    }

    function getTotalBorrowBalance() public virtual override(Lendable, Borrowable) view returns (uint256) {
        uint256 total;
        for (uint8 i = 0; i < creditLines.length; i++) {
            total += borrowBalanceSnapshot(i);
        }
        return total;
    }

    struct BorrowIndexLocalVars {
        MathError mathErr;
        uint256 blockNumber;
        uint256 accrualBlockNumber;
        uint256 priorBorrowIndex;
        uint256 newBorrowIndex;
        uint256 borrowRateMantissa;
        uint256 blockDelta;
        Exp interestFactor;
    }
    function getBorrowIndex(uint256 loanId) public override view returns (uint256) {
        CreditLine storage creditLine = creditLines[loanId];
        BorrowIndexLocalVars memory vars;

        vars.accrualBlockNumber = creditLine.accrualBlockNumber;
        vars.priorBorrowIndex = creditLine.borrowIndex;
        vars.blockNumber = getBlockNumber();

        /* Short-circuit accumulating 0 interest */
        if (vars.accrualBlockNumber == vars.blockNumber || vars.accrualBlockNumber == 0) {
            return vars.priorBorrowIndex;
        }

        vars.borrowRateMantissa = controller.interestRateModel().getBorrowRate(creditLine.interestRate);
        (vars.mathErr, vars.blockDelta) = subUInt(vars.blockNumber, vars.accrualBlockNumber);
        ErrorReporter.check((uint256(vars.mathErr)));

        (vars.mathErr, vars.interestFactor) = mulScalar(Exp({mantissa: vars.borrowRateMantissa}), vars.blockDelta);
        ErrorReporter.check((uint256(vars.mathErr)));

        (vars.mathErr, vars.newBorrowIndex) = mulScalarTruncateAddUInt(vars.interestFactor, vars.priorBorrowIndex, vars.priorBorrowIndex);
        ErrorReporter.check((uint256(vars.mathErr)));

        return vars.newBorrowIndex;
    }

    struct PenaltyIndexLocalVars {
        MathError mathErr;
        uint256 fee;
        uint256 principal;
        uint256 daysDelta;
        uint256 interestBlocksPerYear;
        uint256 penaltyIndex;
        uint256 penaltyAmount;
        uint256 accrualTimestamp;
        uint256 timestamp;
    }
    function getPenaltyIndexAndFee(uint256 loanId) public override view returns(uint256, uint256) {
        PenaltyInfo storage _penaltyInfo = penaltyInfo[loanId];

        if (creditLines[loanId].isClosed) {
            return (0, 0);
        }

        PenaltyIndexLocalVars memory vars;
        InterestRateModel.GracePeriod[] memory _gracePeriod;

        uint256 day = 24 * 60 * 60;
        vars.principal = creditLines[loanId].principal;
        vars.accrualTimestamp = _penaltyInfo.timestamp;
        vars.penaltyIndex = _penaltyInfo.index;
        vars.timestamp = getBlockTimestamp();

        (_gracePeriod, vars.interestBlocksPerYear) = controller.interestRateModel().getGracePeriodSnapshot();
        for(uint8 i=0; i < _gracePeriod.length; i++) {
            uint256 _start = _gracePeriod[i].start * day + _penaltyInfo.maturity;
            uint256 _end = _gracePeriod[i].end * day + _penaltyInfo.maturity;

            if (vars.timestamp >= _start) {
                if(vars.timestamp > _end) {
                    vars.daysDelta = _calculateDaysDelta(_end, vars.accrualTimestamp, _start, day);
                } else {
                    vars.daysDelta = _calculateDaysDelta(vars.timestamp, vars.accrualTimestamp, _start, day);
                }

                vars.penaltyIndex = calculatePenaltyIndexPerPeriod(_gracePeriod[i].fee, vars.interestBlocksPerYear, vars.daysDelta, vars.penaltyIndex);
                (vars.mathErr, vars.fee) = mulScalarTruncateAddUInt(Exp({mantissa: vars.penaltyIndex }), vars.principal, vars.fee);
                ErrorReporter.check((uint256(vars.mathErr)));
            }
        }

        if (vars.fee > 0) {
            (vars.mathErr, vars.penaltyAmount) = subUInt(vars.fee, vars.principal);
            ErrorReporter.check((uint256(vars.mathErr)));
        }
        return (vars.penaltyIndex, vars.penaltyAmount);
    }

    function _calculateDaysDelta(uint256 timestamp, uint256 acrrualTimestamp, uint256 _start, uint256 day) internal pure returns (uint256) {
        MathError mathErr;
        uint256 daysDelta;
        if (acrrualTimestamp > _start) {
            (mathErr, daysDelta) = subThenDivUInt(timestamp, acrrualTimestamp, day);
            ErrorReporter.check((uint256(mathErr)));
        } else {
            (mathErr, daysDelta) = subThenDivUInt(timestamp, _start, day);
            ErrorReporter.check((uint256(mathErr)));
        }
        return daysDelta;
    }

    function calculatePenaltyIndexPerPeriod(uint fee, uint256 blockPerYear, uint256 daysDelta, uint256 currentPenaltyIndex) internal pure returns (uint256) {
        Exp memory simpleInterestFactor;
        MathError mathErr;
        uint256 penaltyIndex;

        (mathErr, simpleInterestFactor) = mulScalar(Exp({mantissa: fee / blockPerYear }), daysDelta);
        ErrorReporter.check((uint256(mathErr)));

        (mathErr, penaltyIndex) = mulScalarTruncateAddUInt(simpleInterestFactor, currentPenaltyIndex, currentPenaltyIndex);
        ErrorReporter.check((uint256(mathErr)));

        return penaltyIndex;
    }

    struct TransferLocalVars {
        MathError mathError;
        uint256 feesMantissa;
        uint256 feesAmount;
        uint256 amountWithoutFees;
    }
    function _transferTokensOnBorrow(address from, address to, uint256 amount) internal override returns (bool) {
        require(stableCoin.balanceOf(from) >= amount, toString(Error.INSUFFICIENT_FUNDS));

        TransferLocalVars memory vars;

        vars.feesMantissa = controller.provisionPool().getFeesPercent();

        (vars.mathError, vars.feesAmount) = mulScalarTruncate(Exp({ mantissa: vars.feesMantissa }), amount);
        ErrorReporter.check(uint256(vars.mathError));

        (vars.mathError, vars.amountWithoutFees) = subUInt(amount, vars.feesAmount);
        ErrorReporter.check(uint256(vars.mathError));

        require(stableCoin.transfer(to, vars.amountWithoutFees), toString(Error.TRANSFER_FAILED));
        require(stableCoin.transfer(controller.provisionPool.address, vars.feesAmount), toString(Error.LPP_TRANSFER_FAILED));
        return true;
    }

    function _transferTokensOnRepay(address from, address to, uint256 amount, uint256 penaltyAmount) internal override returns (bool) {
        require(_transferTokens(from, to, amount), toString(Error.TRANSFER_FAILED));

        if (penaltyAmount > 0) {
            return _transferTokens(to, controller.provisionPool.address, penaltyAmount);
        }
        return true;
    }

    function borrowAllowed(address _pool, address _lender, uint256 _amount) internal override returns (uint256) {
        return controller.borrowAllowed(_pool, _lender, _amount);
    }

    function repayAllowed(address _pool, address _payer, address _borrower, uint256 _amount) internal override returns (uint256) {
        return controller.repayAllowed(_pool, _payer, _borrower, _amount);
    }

    function getBlockNumber() public virtual override view returns(uint256) {
        return block.number;
    }

    function getBlockTimestamp() public virtual override view returns(uint256) {
        // SWC-Block values as a proxy for time： L330
        return block.timestamp;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/proxy/Clones.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//solhint-disable max-line-length
//solhint-disable no-inline-assembly
/**
 * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
 * deploying minimal proxy contracts, also known as "clones".
 *
 * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
 * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
 *_
 */
library Clones {

  function createClone(address target) internal returns (address result) {
    bytes20 targetBytes = bytes20(target);

    assembly {
        let clone := mload(0x40)
        mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
        mstore(add(clone, 0x14), targetBytes)
        mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
        result := create(0, clone, 0x37)
    }

    require(result != address(0), "ERC1167: create failed");
  }

  function isClone(address target, address query) internal view returns (bool result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
        let clone := mload(0x40)
        mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
        mstore(add(clone, 0xa), targetBytes)
        mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

        let other := add(clone, 0x40)
        extcodecopy(query, other, 0, 0x2d)
        result := and(
            eq(mload(clone), mload(other)),
            eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
        )
    }
  }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Controller/Controller.sol

// SPDX-License-Identifier: MIT
/// @dev size: 21.942 Kbytes
pragma solidity ^0.8.0;






contract Controller is ControllerStorage, Rewards, ControllerErrorReporter, Ownable, ReentrancyGuard, NonZeroAddressGuard {
    using StableCoin for StableCoin.Data;
    
    StableCoin.Data private _stableCoins;
    address internal _poolLibrary;

    event PoolCreated(address indexed pool, address indexed owner, address stableCoin, string name, uint256 minDeposit, uint8 access);
    
    event NewProvisionPool(LossProvisionInterface oldProvisionPool, LossProvisionInterface newProvisionPool);
    event NewInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
    event NewAssetsFactory(AssetInterface oldAssetsFactory, AssetInterface newAssetsFactory);
    event NewAmptContract(IERC20 oldAmptToken, IERC20 newAmptToken);

    event AmptPoolSpeedChanged(address pool, uint oldSpeed, uint newSpeed);
    event AmptDepositAmountChanged(uint oldAmount, uint newAmount);

    event BorrowerCreated(address borrower);
    event BorrowerWhitelisted(address borrower);
    event BorrowerBlacklisted(address borrower);

    event LenderCreated(address lender, address pool, uint256 amount);
    event LenderWhitelisted(address lender, address borrower);
    event LenderBlacklisted(address lender, address borrower);
    event LenderDepositWithdrawn(address lender, address pool, uint256 amount);
    
    event DebtCeilingChanged(address borrower, uint newCeiling);
    event RatingChanged(address borrower, uint newRating);

    constructor() {
        _deployPoolLibrary();
    }

    function _deployPoolLibrary() internal virtual {
        _poolLibrary = address(new Pool());
    }

    function getBorrowerPools(address _borrower) external view returns(address[] memory) {
        return borrowerPools[_borrower];
    }


    function submitBorrower() external returns (uint256) {
        transferAMPTDeposit(msg.sender);

        if(!borrowers[msg.sender].created) {
            borrowers[msg.sender] = Borrower(
                0,
                0,
                false,
                true
            );
            emit BorrowerCreated(msg.sender);
        }
        return uint256(Error.NO_ERROR);
    }

    function requestPoolWhitelist(address pool, uint256 deposit) external nonReentrant nonZeroAddress(pool) returns (uint256) {
        Pool poolI = Pool(pool);
        require(poolI.isInitialized(), "Pool is not initialized");

        Application storage application = poolApplicationsByLender[pool][msg.sender];
        if(!application.created) {
            require(poolI.stableCoin().allowance(msg.sender, address(this)) >= deposit, "Lender does not approve allowance");
            
            application.created = true;

            application.depositAmount = deposit;
            application.lender = msg.sender;
            application.mapIndex = poolApplications[pool].length;

            poolApplications[pool].push(application);
            emit LenderCreated(msg.sender, pool, deposit);
            
            assert(poolI.stableCoin().transferFrom(msg.sender, address(this), deposit));
        }

        return uint256(Error.NO_ERROR);
    }

    function withdrawApplicationDeposit(address pool) external {
        Application storage application = poolApplicationsByLender[pool][msg.sender];
        require(application.lender == msg.sender, "invalid application lender");

        if (application.created) {
            uint256 depositAmount = application.depositAmount;
            
            delete poolApplications[pool][application.mapIndex];
            delete poolApplicationsByLender[pool][msg.sender];

            emit LenderDepositWithdrawn(msg.sender, pool, depositAmount);
            assert(Pool(pool).stableCoin().transfer(msg.sender, depositAmount));
        }
    }

    function createPool(string memory name, uint256 minDeposit, address stableCoin, Pool.Access poolAccess) external nonReentrant {
        require(borrowers[msg.sender].whitelisted, "Only whitelisted user can create pool");
        require(_stableCoins.contains(stableCoin), "Stable coin not supported");

        address pool = Clones.createClone(_poolLibrary);

        Pool _poolI = Pool(pool);
        require(!_poolI.isInitialized(), "pool already initialized");
        _poolI.initialize(msg.sender, stableCoin, name, minDeposit, poolAccess);

        PoolInfo storage _pool = pools[pool];
        _pool.owner = msg.sender;
        _pool.isActive = true;

        borrowerPools[msg.sender].push(pool);

        // reward variables
        rewardPools.push(pool);
        rewardsState[pool] = PoolState(true, 0, 0, 0, 0);

        emit PoolCreated(pool, msg.sender, stableCoin, name, minDeposit, uint8(poolAccess));
    }

    function getPoolUtilizationRate(address pool) external view returns (uint256) {
        uint256 totalCash = Pool(pool).getCash();
        uint256 totalBorrows = Pool(pool).getTotalBorrowBalance();

        return interestRateModel.utilizationRate(totalCash, totalBorrows);
    }

    struct APYLocalVars {
        MathError err;
        uint256 interestDelta;
        uint256 utilizationRate;
        uint256 apy;
    }
    function getPoolAPY(address pool) external view returns (uint256) {
        APYLocalVars memory vars;

        vars.interestDelta = Pool(pool).totalInterestRate();
        vars.utilizationRate = this.getPoolUtilizationRate(pool);

        return mul_(vars.utilizationRate, Exp({ mantissa: vars.interestDelta }));
    }

    function getTotalSupplyBalance(address lender) external view returns (uint256) {
        uint256 totalSupply = 0;
        for (uint256 i = 0; i < lenderJoinedPools[lender].length; i++) {
            totalSupply += Pool(lenderJoinedPools[lender][i]).balanceOfUnderlying(lender);
        }
        return totalSupply;
    }

    // Admin functions
    function _setProvisionPool(LossProvisionInterface newProvisionPool) external onlyOwner {
        require(newProvisionPool.isLossProvision(), "marker method returned false");

        LossProvisionInterface oldProvisionPool = provisionPool;
        require(newProvisionPool != oldProvisionPool, "provisionPool is already set to this value");

        provisionPool = newProvisionPool;
        emit NewProvisionPool(oldProvisionPool, newProvisionPool);
    }

    function _setInterestRateModel(InterestRateModel newInterestModel) external onlyOwner {
        require(newInterestModel.isInterestRateModel(), "marker method returned false");

        InterestRateModel oldInterestModel = interestRateModel;
        require(newInterestModel != oldInterestModel, "interestRateModel is already set to this value");

        interestRateModel = newInterestModel;
        emit NewInterestRateModel(oldInterestModel, newInterestModel);
    }

    function _setAssetsFactory(AssetInterface newAssetsFactory) external onlyOwner {
        require(newAssetsFactory.isAssetsFactory(), "marker method returned false");

        AssetInterface oldAssetsFactory = assetsFactory;
        require(newAssetsFactory != oldAssetsFactory, "assetsFactory is already set to this value");

        assetsFactory = newAssetsFactory;
        emit NewAssetsFactory(oldAssetsFactory, newAssetsFactory);
    }

    function _setAmptContract(IERC20 newAmptToken) external onlyOwner {
        IERC20 oldAmptToken = amptToken;
        require(newAmptToken != oldAmptToken, "amptToken is already set to this value");

        amptToken = newAmptToken;
        emit NewAmptContract(oldAmptToken, newAmptToken);
    }

    function _setAmptSpeed(address pool, uint256 newSpeed) external onlyOwner nonZeroAddress(pool) {
        require(Pool(pool).isInitialized(), "pool is not active");
        require(newSpeed > 0, "speed must be greater than 0");

        uint currentSpeed = amptPoolSpeeds[pool];
        if (currentSpeed != newSpeed) {
            amptPoolSpeeds[pool] = newSpeed;
            emit AmptPoolSpeedChanged(pool, currentSpeed, newSpeed);
        }
        updateBorrowIndexInternal(pool);
        updateSupplyIndexInternal(pool);
    }

    function _setAmptDepositAmount(uint256 newDeposit) external onlyOwner{
        require(newDeposit > 0, "amount must be greater than 0");

        uint currentDeposit = amptDepositAmount;

        if (currentDeposit != newDeposit) {
            amptDepositAmount = newDeposit;
            emit AmptDepositAmountChanged(currentDeposit, newDeposit);
        }
    }

    function transferFunds(address destination) external onlyOwner nonZeroAddress(destination) returns (bool) {
        require(amptToken.transfer(destination, amptToken.balanceOf(address(this))), "transfer failed");
        return true;
    }

    function whitelistBorrower(address borrower, uint256 debtCeiling, uint256 rating) external onlyOwner returns (uint256) {
        Borrower storage _borrower = borrowers[borrower];
        require(_borrower.created, toString(Error.BORROWER_NOT_CREATED));
        require(!_borrower.whitelisted, toString(Error.ALREADY_WHITELISTED));
 
        _borrower.whitelisted = true;

        _setBorrowerDebtCeiling(borrower, debtCeiling);
        _setBorrowerRating(borrower, rating);

        emit BorrowerWhitelisted(borrower);
        return uint256(Error.NO_ERROR);
    }

    function whitelistLender(address _lender, address _pool) external returns (uint256) {
        Application storage application = poolApplicationsByLender[_pool][_lender];

        address borrower = pools[_pool].owner;
        require(borrower == msg.sender, toString(Error.INVALID_OWNER));

        require(!borrowerWhitelists[borrower][_lender], toString(Error.ALREADY_WHITELISTED));
        borrowerWhitelists[borrower][_lender] = true;
        emit LenderWhitelisted(_lender, msg.sender);

        if (application.created) {
            application.whitelisted = true;
            poolApplications[_pool][application.mapIndex] = application;
            
            if (!!lenderJoinedPoolsMap[_lender][_pool]) { // if the pool is already joined
                // transfer tokens in the pool
                Pool poolI = Pool(_pool);

                assert(poolI.stableCoin().approve(_pool, application.depositAmount));
                assert(poolI._lend(application.depositAmount, _lender) == 0);
            }
        }

        return uint256(Error.NO_ERROR);
    }

    function blacklistBorrower(address borrower) external onlyOwner returns (uint256) {
        Borrower storage _borrower = borrowers[borrower];

        require(_borrower.created, toString(Error.BORROWER_NOT_CREATED));
        require(_borrower.whitelisted, toString(Error.BORROWER_NOT_WHITELISTED));
    
        _borrower.whitelisted = false;
        for(uint8 i=0; i < borrowerPools[borrower].length; i++) {
            address pool = borrowerPools[borrower][i];
            pools[pool].isActive = false;
        }
        emit BorrowerBlacklisted(borrower);
        return uint256(Error.NO_ERROR);
    }

    // @dev this function must be used to limit the lender actions in the pool 
    function blacklistLender(address _lender) external returns (uint256) {
        require(borrowerWhitelists[msg.sender][_lender], toString(Error.LENDER_NOT_WHITELISTED));
    
        borrowerWhitelists[msg.sender][_lender] = false;

        emit LenderBlacklisted(_lender, msg.sender);
        return uint256(Error.NO_ERROR);
    }

    struct BorrowerInfo {
        uint256 debtCeiling;
        uint256 rating;
    }

    function updateBorrowerInfo(address borrower, BorrowerInfo calldata borrowerInfo) external onlyOwner nonZeroAddress(borrower) returns (uint256) {
        require(borrowers[borrower].created, toString(Error.BORROWER_NOT_CREATED));
        
        _setBorrowerDebtCeiling(borrower, borrowerInfo.debtCeiling);
        _setBorrowerRating(borrower, borrowerInfo.rating);

        return uint256(Error.NO_ERROR);
    }

    function addStableCoin(address stableCoin) onlyOwner external {
        require(_stableCoins.insert(stableCoin));
    }

    function removeStableCoin(address stableCoin) onlyOwner external {
        require(_stableCoins.remove(stableCoin));
    }

    function containsStableCoin(address stableCoin) public view returns (bool) {
        return _stableCoins.contains(stableCoin);
    }

    function getStableCoins() external view returns (address[] memory) {
        return _stableCoins.getList();
    }

    function lendAllowed(address pool, address lender, uint256 amount) external returns (uint256) {
        PoolInfo storage _pool = pools[pool];

        // Check if pool is active
        if (!_pool.isActive) {
            return uint256(Error.POOL_NOT_ACTIVE);
        }

        // Check if pool is private
        if (
            Pool(pool).access() == uint8(Pool.Access.Private) &&
            !borrowerWhitelists[_pool.owner][lender]
        ) {
            return uint256(Error.LENDER_NOT_WHITELISTED);
        }

        // Not used for now
        amount;

        updateSupplyIndexInternal(pool);
        distributeSupplierTokens(pool, lender);
        if (!lenderJoinedPoolsMap[lender][pool]) {
            lenderJoinedPools[lender].push(pool);
            lenderJoinedPoolsMap[lender][pool] = true;
        }

        return uint256(Error.NO_ERROR);
    }

    function redeemAllowed(address pool, address redeemer, uint256 amount) external returns (uint256) {
        PoolInfo storage _pool = pools[pool];

        // Check if pool is active
        if (!_pool.isActive) {
            return uint256(Error.POOL_NOT_ACTIVE);
        }

        // Not used for now
        amount;

        updateSupplyIndexInternal(pool);
        distributeSupplierTokens(pool, redeemer);

        return uint256(Error.NO_ERROR);
    }

    function borrowAllowed(address pool, address borrower, uint256 amount) external returns (uint256) {
        PoolInfo storage _pool = pools[pool];

        // Check if pool is active
        if (!_pool.isActive) {
            return uint256(Error.POOL_NOT_ACTIVE);
        }

        /* Check if borrower is owner of the pool */
        // @dev Borrower can borrow only from his own pools
        if (_pool.owner != borrower) {
            return uint256(Error.BORROWER_NOT_MEMBER);
        }

        // Check if borrower is whitelisted
        if (!borrowers[borrower].whitelisted) {
            return uint256(Error.BORROWER_NOT_WHITELISTED);
        }

        uint256 borrowCap = borrowers[borrower].debtCeiling;
        // Borrow cap of 0 corresponds to unlimited borrowing
        if (borrowCap != 0) {
            uint256 totalBorrows = Pool(pool).getBorrowerBalance(borrower);
            uint256 nextTotalBorrows = totalBorrows + amount;
            if (nextTotalBorrows >= borrowCap) {
                return uint256(Error.BORROW_CAP_EXCEEDED);
            }
        }

        updateBorrowIndexInternal(pool);
        distributeBorrowerTokens(pool, borrower);

        return uint256(Error.NO_ERROR);
    }

    function repayAllowed(address pool, address payer, address borrower, uint256 amount) external returns (uint256) {
        PoolInfo storage _pool = pools[pool];

        // currently unused
        payer;
        amount;

        // Check if pool is active
         require(_pool.isActive, toString(Error.POOL_NOT_ACTIVE));

        updateBorrowIndexInternal(pool);
        distributeBorrowerTokens(pool, borrower);

        return uint256(Error.NO_ERROR);
    }

    struct CreditLinesLocalVars {
        uint256 assetValue;
        uint256 maturity;
        uint256 interestRate;
        uint256 advanceRate;
        address owner;
        bool redeemed;
    }
    function createCreditLineAllowed(address pool, address borrower, uint256 collateralAsset) external virtual nonReentrant returns (uint256, uint256, uint256, uint256, uint256) {
        PoolInfo storage _pool = pools[pool];
        CreditLinesLocalVars memory vars;

        // Check if pool is active
        require(_pool.isActive, toString(Error.POOL_NOT_ACTIVE));

        // Check if collateral asset is supported
        (vars.assetValue, vars.maturity,vars.interestRate,vars.advanceRate,, , vars.owner ,vars.redeemed) = assetsFactory.getTokenInfo(collateralAsset);
        uint256 borrowCap = borrowers[borrower].debtCeiling;

        require(borrowCap == 0 || borrowCap >= vars.assetValue, toString(Error.BORROW_CAP_EXCEEDED));
        require(vars.owner == pool, toString(Error.INVALID_OWNER));
        require(!vars.redeemed, toString(Error.ASSET_REDEEMED));
        require(vars.maturity >= getBlockTimestamp(), toString(Error.MATURITY_DATE_EXPIRED));
        require(vars.interestRate > 0, toString(Error.NOT_ALLOWED_TO_CREATE_CREDIT_LINE));

        vars.interestRate = calculateBorrowInterestRate(borrower, vars.interestRate);
        return (uint256(Error.NO_ERROR), vars.assetValue, vars.maturity, vars.interestRate, vars.advanceRate);
    }

    struct InterestRateLocalVars {
        uint256 interestRateScaled;
        uint256 interestProduct;
    }
    function calculateBorrowInterestRate(address borrower, uint256 interestRate) internal view returns (uint256) {
        InterestRateLocalVars memory vars;

        vars.interestRateScaled = div_(mul_(interestRate, expScale), 100); // interest rate scaled in %
        vars.interestProduct = div_(mul_(vars.interestRateScaled, borrowers[borrower].ratingMantissa), expScale); // interest product mantissa

        return add_(vars.interestRateScaled, vars.interestProduct);
    }

    // Internal function
    function transferAMPTDeposit(address _owner) internal nonReentrant {
        require(amptToken.allowance(_owner, address(this)) >= amptDepositAmount, "Allowance is not enough");
        require(amptToken.transferFrom(_owner, address(this), amptDepositAmount), toString(Error.AMPT_TOKEN_TRANSFER_FAILED));
    }

    function _setBorrowerDebtCeiling(address borrower, uint256 debtCeiling) internal returns (uint256) {
        Borrower storage _borrower = borrowers[borrower];

        if (_borrower.whitelisted) {
            _borrower.debtCeiling = debtCeiling;
            emit DebtCeilingChanged(borrower, debtCeiling);
        }
        return uint256(Error.NO_ERROR);
    }

    function _setBorrowerRating(address borrower, uint256 rating) internal returns (uint256) {
        require(1e18 - rating >= 0, "Rating must be between 0 and 1");
        Borrower storage _borrower = borrowers[borrower];

        if (_borrower.whitelisted) {
            _borrower.ratingMantissa = rating;
            emit RatingChanged(borrower, rating);
        }
        return uint256(Error.NO_ERROR);
    }

    function grantRewardInternal(address account, uint256 amount) internal override returns (uint256) {
        uint amptRemaining = amptToken.balanceOf(address(this));
        if (amount > 0 && amount <= amptRemaining) {
            assert(amptToken.transfer(account, amount));
            return 0;
        }
        return amount;
    }

    function getBorrowerTotalPrincipal(address pool, address holder) internal override virtual view returns (uint256) {
        return Pool(pool).getBorrowerTotalPrincipal(holder);
    }

    function getSupplierBalance(address pool, address holder) internal override virtual view returns (uint256) {
        return Pool(pool).balanceOf(holder);
    }

    function getPoolInfo(address pool) internal override view returns (uint256, uint256) {
        Pool _pool = Pool(pool);
        return (_pool.totalSupply(), _pool.totalPrincipal());
    }

    function getBlockNumber() public virtual override view returns (uint256) {
        return block.number;
    }

    function getBlockTimestamp() public virtual view returns (uint256) {
        return block.timestamp;
    }
}
