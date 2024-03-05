



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