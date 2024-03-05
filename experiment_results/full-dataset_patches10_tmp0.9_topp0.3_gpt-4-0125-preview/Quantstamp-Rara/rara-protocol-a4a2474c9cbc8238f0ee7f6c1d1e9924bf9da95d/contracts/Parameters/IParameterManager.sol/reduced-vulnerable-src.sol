


pragma solidity 0.8.9;

interface IRoleManager {
    
    
    function isAdmin(address potentialAddress) external view returns (bool);

    
    
    function isAddressManagerAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isParameterManagerAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isReactionNftAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isCuratorVaultPurchaser(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isCuratorTokenAdmin(address potentialAddress)
        external
        view
        returns (bool);
}






pragma solidity ^0.8.0;




interface IERC20Upgradeable {
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);

    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address to, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}




pragma solidity 0.8.9;


interface IParameterManager {
    struct SigmoidCurveParameters {
        uint256 a;
        uint256 b;
        uint256 c;
    }

    
    function paymentToken() external returns (IERC20Upgradeable);

    
    function setPaymentToken(IERC20Upgradeable _paymentToken) external;

    
    function reactionPrice() external returns (uint256);

    
    function setReactionPrice(uint256 _reactionPrice) external;

    
    function saleCuratorLiabilityBasisPoints() external returns (uint256);

    
    function setSaleCuratorLiabilityBasisPoints(
        uint256 _saleCuratorLiabilityBasisPoints
    ) external;

    
    function saleReferrerBasisPoints() external returns (uint256);

    
    function setSaleReferrerBasisPoints(uint256 _saleReferrerBasisPoints)
        external;

    
    function spendTakerBasisPoints() external returns (uint256);

    
    function setSpendTakerBasisPoints(uint256 _spendTakerBasisPoints) external;

    
    function spendReferrerBasisPoints() external returns (uint256);

    
    function setSpendReferrerBasisPoints(uint256 _spendReferrerBasisPoints)
        external;

    
    function approvedCuratorVaults(address potentialVault)
        external
        returns (bool);

    
    function setApprovedCuratorVaults(address vault, bool approved) external;

    
    function bondingCurveParams() external returns(uint256, uint256, uint256);

    
    function setBondingCurveParams(uint256 a, uint256 b, uint256 c) external;
}