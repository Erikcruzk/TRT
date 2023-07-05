// File: ../sc_datasets/DAppSCAN/Chainsecurity-Primitive Finance  Core engine smart contracts/rmm-core-c44f8ca1ee43772ec4ba56e031bdb6fb8aac0ca3/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function decimals() external view returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Primitive Finance  Core engine smart contracts/rmm-core-c44f8ca1ee43772ec4ba56e031bdb6fb8aac0ca3/contracts/libraries/Transfers.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

library Transfers {
    /// @notice         Performs an ERC20 `transfer` call and checks return data
    /// @param  token   ERC20 token to transfer
    /// @param  to      Recipient of the ERC20 token
    /// @param  value   Amount of ERC20 to transfer
    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory returnData) = address(token).call(
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
        require(success && (returnData.length == 0 || abi.decode(returnData, (bool))), "Transfer fail");
    }
}
