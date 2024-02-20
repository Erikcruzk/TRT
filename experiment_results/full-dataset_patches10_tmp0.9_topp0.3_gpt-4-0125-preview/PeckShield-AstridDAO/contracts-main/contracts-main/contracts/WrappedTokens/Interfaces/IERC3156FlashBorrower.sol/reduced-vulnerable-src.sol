


pragma solidity 0.8.13;


interface IERC3156FlashBorrower {

    








    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}