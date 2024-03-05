




pragma solidity ^0.8.0;




interface IERC20 {
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);

    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address to, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}






pragma solidity ^0.8.0;










interface IERC165 {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}






pragma solidity ^0.8.0;




interface IERC721 is IERC165 {
    


    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    


    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    


    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    


    function balanceOf(address owner) external view returns (uint256 balance);

    






    function ownerOf(uint256 tokenId) external view returns (address owner);

    












    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    













    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    















    function transferFrom(address from, address to, uint256 tokenId) external;

    












    function approve(address to, uint256 tokenId) external;

    









    function setApprovalForAll(address operator, bool approved) external;

    






    function getApproved(uint256 tokenId) external view returns (address operator);

    




    function isApprovedForAll(address owner, address operator) external view returns (bool);
}



pragma solidity 0.8.6;

























interface IOptionsManager is IERC721 {
    


    function createOptionFor(address holder) external returns (uint256);

    


    function tokenPool(uint256 tokenId) external returns (address pool);

    




    function isApprovedOrOwner(address spender, uint256 tokenId)
        external
        view
        returns (bool);
}



pragma solidity 0.8.6;





















interface IHegicOperationalTreasury {
    enum LockedLiquidityState {Unlocked, Locked}

    event Expired(uint256 indexed id);
    event Paid(uint256 indexed id, address indexed account, uint256 amount);
    event Replenished(uint256 amount);

    struct LockedLiquidity {
        LockedLiquidityState state;
        address strategy;
        uint128 amount;
        uint128 premium;
        uint32 expiration;
    }

    function manager() external view returns (IOptionsManager);

    function token() external view returns (IERC20);

    function lockLiquidityFor(
        address holder,
        uint128 amount,
        uint32 expiration
    ) external returns (uint256 optionID);

    function payOff(
        uint256 lockedLiquidityID,
        uint256 amount,
        address account
    ) external;

    function lockedByStrategy(address strategy)
        external
        view
        returns (uint256 lockedAmount);

    function totalBalance() external view returns (uint256 totalBalance);

    function benchmark() external view returns (uint256 benchmark);

    function totalLocked() external view returns (uint256 totalLocked);
}