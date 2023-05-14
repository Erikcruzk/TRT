pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract airDrop {
    function transfer(
        address token,
        address from,
        address[] memory _tos,
        uint256 amount
    ) public returns (bool) {
        require(_tos.length > 0, "At least one recipient is required");
        IERC20 erc20 = IERC20(token);
        for (uint i = 0; i < _tos.length; i++) {
            erc20.transferFrom(from, _tos[i], amount);
        }
        return true;
    }
}