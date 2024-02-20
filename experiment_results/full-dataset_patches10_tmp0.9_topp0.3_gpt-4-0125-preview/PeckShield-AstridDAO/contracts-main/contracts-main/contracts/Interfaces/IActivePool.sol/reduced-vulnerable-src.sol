



pragma solidity 0.8.13;


interface IPool {
    
    
    
    event COLBalanceUpdated(uint _newBalance);
    event BAIBalanceUpdated(uint _newBalance);
    event ActivePoolAddressChanged(address _newActivePoolAddress);
    event DefaultPoolAddressChanged(address _newDefaultPoolAddress);
    event StabilityPoolAddressChanged(address _newStabilityPoolAddress);
    event COLSent(address _to, uint _amount);

    
    
    function getCOL() external view returns (uint);

    function getBAIDebt() external view returns (uint);

    function increaseBAIDebt(uint _amount) external;

    function decreaseBAIDebt(uint _amount) external;

    
    function receiveCOL(uint _amount) external;
    
}





pragma solidity 0.8.13;


interface ICollSurplusPool {

    
    
    event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
    event VaultManagerAddressChanged(address _newVaultManagerAddress);
    event ActivePoolAddressChanged(address _newActivePoolAddress);
    event COLTokenAddressChanged(address _newCOLTokenAddress);

    event CollBalanceUpdated(address indexed _account, uint _newBalance);
    event COLSent(address _to, uint _amount);

    

    function setAddresses(
        address _borrowerOperationsAddress,
        address _vaultManagerAddress,
        address _activePoolAddress,
        address _collateralTokenAddress
    ) external;

    function getCOL() external view returns (uint);

    function getCollateral(address _account) external view returns (uint);

    function accountSurplus(address _account, uint _amount) external;

    function claimColl(address _account) external;

    
    function receiveCOL(uint _amount) external;
}





pragma solidity 0.8.13;

interface IDefaultPool is IPool {
    
    event VaultManagerAddressChanged(address _newVaultManagerAddress);
    event COLTokenAddressChanged(address _newCOLTokenAddress);
    event DefaultPoolBAIDebtUpdated(uint _BAIDebt);
    event DefaultPoolCOLBalanceUpdated(uint _COL);

    
    function sendCOLToActivePool(uint _amount) external;
}





pragma solidity 0.8.13;





























interface IStabilityPool {

    
    
    event StabilityPoolCOLBalanceUpdated(uint _newBalance);
    event StabilityPoolBAIBalanceUpdated(uint _newBalance);

    event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
    event VaultManagerAddressChanged(address _newVaultManagerAddress);
    event ActivePoolAddressChanged(address _newActivePoolAddress);
    event DefaultPoolAddressChanged(address _newDefaultPoolAddress);
    event COLTokenAddressChanged(address _newCOLTokenAddress);
    event BAITokenAddressChanged(address _newBAITokenAddress);
    event SortedVaultsAddressChanged(address _newSortedVaultsAddress);
    event PriceFeedAddressChanged(address _newPriceFeedAddress);
    event CommunityIssuanceAddressChanged(address _newCommunityIssuanceAddress);

    event P_Updated(uint _P);
    event S_Updated(uint _S, uint128 _epoch, uint128 _scale);
    event G_Updated(uint _G, uint128 _epoch, uint128 _scale);
    event EpochUpdated(uint128 _currentEpoch);
    event ScaleUpdated(uint128 _currentScale);

    event DepositSnapshotUpdated(address indexed _depositor, uint _P, uint _S, uint _G);
    event UserDepositChanged(address indexed _depositor, uint _newDeposit);

    event COLGainWithdrawn(address indexed _depositor, uint _COL, uint _BAILoss);
    event ATIDPaidToDepositor(address indexed _depositor, uint _ATID);
    event COLSent(address _to, uint _amount);

    

    



    function setCollateralName(
        string memory _collateralName
    ) external;

    



    function setAddresses(
        address _borrowerOperationsAddress,
        address _vaultManagerAddress,
        address _activePoolAddress,
        address _colTokenAddress,
        address _baiTokenAddress,
        address _sortedVaultsAddress,
        address _priceFeedAddress,
        address _communityIssuanceAddress
    ) external;

    







    function provideToSP(uint _amount) external;

    










    function withdrawFromSP(uint _amount) external;

    











    function withdrawCOLGainToVault(address _upperHint, address _lowerHint) external;

    







    function offset(uint _debt, uint _coll) external;

    



    function getCOL() external view returns (uint);

    


    function getTotalBAIDeposits() external view returns (uint);

    


    function getDepositorCOLGain(address _depositor) external view returns (uint);

    


    function getDepositorATIDGain(address _depositor) external view returns (uint);

    


    function getCompoundedBAIDeposit(address _depositor) external view returns (uint);

    
    function receiveCOL(uint _amount) external;
    
}





pragma solidity 0.8.13;




interface IActivePool is IPool {
    
    event BorrowerOperationsAddressChanged(address _newBorrowerOperationsAddress);
    event VaultManagerAddressChanged(address _newVaultManagerAddress);
    event COLTokenAddressChanged(address _newCOLTokenAddress);
    event ActivePoolBAIDebtUpdated(uint _BAIDebt);
    event ActivePoolCOLBalanceUpdated(uint _COL);

    
    function sendCOL(address _account, uint _amount) external;
    function sendCOLToCollSurplusPool(ICollSurplusPool _collSurplusPool, uint _amount) external;
    function sendCOLToDefaultPool(IDefaultPool _defaultPool, uint _amount) external;
    function sendCOLToStabilityPool(IStabilityPool _stabilityPool, uint _amount) external;
}