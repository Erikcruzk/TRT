// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/IStateUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IStateUtils {
    event SetDaoApps(
        address agentAppPrimary,
        address agentAppSecondary,
        address votingAppPrimary,
        address votingAppSecondary
        );

    event SetClaimsManagerStatus(
        address claimsManager,
        bool status
        );

    event SetStakeTarget(
        uint256 oldTarget,
        uint256 newTarget
        );

    event SetMaxApr(
        uint256 oldMaxApr,
        uint256 maxApr
        );

    event SetMinApr(
        uint256 oldMinApr,
        uint256 minApr
        );

    event SetUnstakeWaitPeriod(
        uint256 oldUnstakeWaitPeriod,
        uint256 unstakeWaitPeriod
        );

    event SetAprUpdateCoefficient(
        uint256 oldAprUpdateCoefficient,
        uint256 aprUpdateCoefficient
        );

    event SetProposalVotingPowerThreshold(
        uint256 oldProposalVotingPowerThreshold,
        uint256 proposalVotingPowerThreshold
        );

    event PublishedSpecsUrl(
        address indexed votingApp,
        uint256 indexed proposalIndex,
        address userAddress,
        string specsUrl
        );

    event UpdatedLastVoteSnapshotBlock(
        address votingApp,
        uint256 lastVoteSnapshotBlock,
        uint256 lastVoteSnapshotBlockUpdateTimestamp
        );

    function setDaoApps(
        address _agentAppPrimary,
        address _agentAppSecondary,
        address _votingAppPrimary,
        address _votingAppSecondary
        )
        external;

    function setClaimsManagerStatus(
        address claimsManager,
        bool status
        )
        external;

    function setStakeTarget(uint256 _stakeTarget)
        external;

    function setMaxApr(uint256 _maxApr)
        external;

    function setMinApr(uint256 _minApr)
        external;

    function setUnstakeWaitPeriod(uint256 _unstakeWaitPeriod)
        external;

    function setAprUpdateCoefficient(uint256 _aprUpdateCoefficient)
        external;

    function setProposalVotingPowerThreshold(uint256 _proposalVotingPowerThreshold)
        external;

    function publishSpecsUrl(
        address votingApp,
        uint256 proposalIndex,
        string calldata specsUrl
        )
        external;

    function updateLastVoteSnapshotBlock(uint256 snapshotBlock)
        external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/IGetterUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IGetterUtils is IStateUtils {
    function balanceOfAt(
        address userAddress,
        uint256 _block
        )
        external
        view
        returns(uint256);

    function balanceOf(address userAddress)
        external
        view
        returns(uint256);

    function totalSupplyOneBlockAgo()
        external
        view
        returns(uint256);

    function totalSupply()
        external
        view
        returns(uint256);

    function userSharesAt(
        address userAddress,
        uint256 _block
        )
        external
        view
        returns(uint256);

    function userShares(address userAddress)
        external
        view
        returns(uint256);

    function userSharesAtWithBinarySearch(
        address userAddress,
        uint256 _block
        )
        external
        view
        returns(uint256);

    function userStake(address userAddress)
        external
        view
        returns(uint256);

    function userReceivedDelegationAt(
        address userAddress,
        uint256 _block
        )
        external
        view
        returns(uint256);

    function userReceivedDelegation(address userAddress)
        external
        view
        returns(uint256);

    function userDelegateAt(
        address userAddress,
        uint256 _block
        )
        external
        view
        returns(address);

    function userDelegate(address userAddress)
        external
        view
        returns(address);

    function getUserLocked(address userAddress)
        external
        view
        returns(uint256);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/IRewardUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IRewardUtils is IGetterUtils {
    event PaidReward(
        uint256 indexed epoch,
        uint256 rewardAmount,
        uint256 apr
        );

    function payReward()
        external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/IDelegationUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IDelegationUtils is IRewardUtils {
    event Delegated(
        address indexed user,
        address indexed delegate
        );

    event Undelegated(
        address indexed user,
        address indexed delegate
        );

    function delegateVotingPower(address delegate) 
        external;

    function undelegateVotingPower()
        external;

    
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/ITransferUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface ITransferUtils is IDelegationUtils{
    event Deposited(
        address indexed user,
        uint256 amount
        );

    event Withdrawn(
        address indexed user,
        address indexed destination,
        uint256 amount
        );

    function deposit(
        address source,
        uint256 amount,
        address userAddress
        )
        external;

    function withdraw(
        address destination,
        uint256 amount
        )
        external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/IStakeUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IStakeUtils is ITransferUtils{
    event Staked(
        address indexed user,
        uint256 amount,
        uint256 totalShares
        );

    event ScheduledUnstake(
        address indexed user,
        uint256 amount,
        uint256 scheduledFor
        );

    event Unstaked(
        address indexed user,
        uint256 amount,
        uint256 totalShares
        );

    function stake(uint256 amount)
        external;

    function depositAndStake(
        address source,
        uint256 amount,
        address userAddress
        )
        external;

    function scheduleUnstake(uint256 amount)
        external;

    function unstake()
        external
        returns(uint256);

    function unstakeAndWithdraw(address destination)
        external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/IClaimUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IClaimUtils is IStakeUtils {
    event PaidOutClaim(
        address indexed recipient,
        uint256 amount
        );

    function payOutClaim(
        address recipient,
        uint256 amount
        )
        external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/ITimelockUtils.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface ITimelockUtils is IClaimUtils {
    event DepositedVesting(
        address indexed user,
        uint256 amount,
        uint256 start,
        uint256 end
        );

    event UpdatedTimelock(
        address indexed user,
        address indexed timelockManagerAddress,
        uint256 remainingAmount
        );

    function depositWithVesting(
        address source,
        uint256 amount,
        address userAddress,
        uint256 releaseStart,
        uint256 releaseEnd
        )
        external;

    function updateTimelockStatus(
        address userAddress,
        address timelockManagerAddress
        )
        external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/interfaces/IApi3Pool.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IApi3Pool is ITimelockUtils {
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-API3/api3-dao-283e6ba8bbf45a8d51bbb6fc166ca3d4673a0911/packages/pool/contracts/mock/MockApi3Voting.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

contract MockApi3Voting {
    IApi3Pool public api3Pool;

    constructor(address _api3Pool)
    {
        api3Pool = IApi3Pool(_api3Pool);
    }

    function newVote()
        external
    {
        api3Pool.updateLastVoteSnapshotBlock(block.number - 1);
    }
}
