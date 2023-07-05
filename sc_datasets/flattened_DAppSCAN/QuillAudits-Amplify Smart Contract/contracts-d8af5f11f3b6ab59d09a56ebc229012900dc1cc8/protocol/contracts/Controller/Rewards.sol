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
