

pragma solidity ^0.4.21;





interface IPollManagedFund {
    




    function onTapPollFinish(bool agree, uint256 _tap) external;

    



    function onRefundPollFinish(bool agree) external;
}