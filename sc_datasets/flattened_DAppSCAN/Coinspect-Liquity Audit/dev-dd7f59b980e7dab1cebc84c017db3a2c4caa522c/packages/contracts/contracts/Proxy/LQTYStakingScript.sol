// File: ../sc_datasets/DAppSCAN/Coinspect-Liquity Audit/dev-dd7f59b980e7dab1cebc84c017db3a2c4caa522c/packages/contracts/contracts/Dependencies/CheckContract.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;


contract CheckContract {
    /**
     * Check that the account is an already deployed non-destroyed contract.
     * See: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L12
     */
    function checkContract(address _account) internal view {
        require(_account != address(0), "Account cannot be zero address");

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(_account) }
        require(size > 0, "Account code size cannot be zero");
    }
}

// File: ../sc_datasets/DAppSCAN/Coinspect-Liquity Audit/dev-dd7f59b980e7dab1cebc84c017db3a2c4caa522c/packages/contracts/contracts/Interfaces/ILQTYStaking.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;

interface ILQTYStaking {

    // --- Events --
    
    event LQTYTokenAddressSet(address _lqtyTokenAddress);
    event LUSDTokenAddressSet(address _lusdTokenAddress);
    event TroveManagerAddressSet(address _troveManager);
    event BorrowerOperationsAddressSet(address _borrowerOperationsAddress);
    event ActivePoolAddressSet(address _activePoolAddress);

    event StakeChanged(address indexed staker, uint newStake);
    event StakingGainsWithdrawn(address indexed staker, uint LUSDGain, uint ETHGain);
    event F_ETHUpdated(uint _F_ETH);
    event F_LUSDUpdated(uint _F_LUSD);
    event TotalLQTYStakedUpdated(uint _totalLQTYStaked);
    event EtherSent(address _account, uint _amount);
    event StakerSnapshotsUpdated(address _staker, uint _F_ETH, uint _F_LUSD);

    // --- Functions ---

    function setAddresses
    (
        address _lqtyTokenAddress,
        address _lusdTokenAddress,
        address _troveManagerAddress, 
        address _borrowerOperationsAddress,
        address _activePoolAddress
    )  external;

    function stake(uint _LQTYamount) external;

    function unstake(uint _LQTYamount) external;

    function increaseF_ETH(uint _ETHFee) external; 

    function increaseF_LUSD(uint _LQTYFee) external;  

    function getPendingETHGain(address _user) external view returns (uint);

    function getPendingLUSDGain(address _user) external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Coinspect-Liquity Audit/dev-dd7f59b980e7dab1cebc84c017db3a2c4caa522c/packages/contracts/contracts/Proxy/LQTYStakingScript.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;


contract LQTYStakingScript is CheckContract {
    ILQTYStaking immutable LQTYStaking;

    constructor(address _lqtyStakingAddress) public {
        checkContract(_lqtyStakingAddress);
        LQTYStaking = ILQTYStaking(_lqtyStakingAddress);
    }

    function stake(uint _LQTYamount) external {
        LQTYStaking.stake(_LQTYamount);
    }
}
