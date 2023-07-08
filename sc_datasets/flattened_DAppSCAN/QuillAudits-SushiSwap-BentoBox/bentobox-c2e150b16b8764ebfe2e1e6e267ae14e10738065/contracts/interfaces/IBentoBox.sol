// File: ../sc_datasets/DAppSCAN/QuillAudits-SushiSwap-BentoBox/bentobox-c2e150b16b8764ebfe2e1e6e267ae14e10738065/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // non-standard
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);

    // EIP 2612
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-SushiSwap-BentoBox/bentobox-c2e150b16b8764ebfe2e1e6e267ae14e10738065/contracts/interfaces/IBentoBox.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

interface IBentoBox {
    event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
    event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount);
    event LogFlashLoan(address indexed user, address indexed token, uint256 amount, uint256 feeAmount);
    event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool indexed approved);
    event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 amount);
    event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount);
    // solhint-disable-next-line func-name-mixedcase
    function WETH() external view returns (IERC20);
    function balanceOf(IERC20, address) external view returns (uint256);
    function masterContractApproved(address, address) external view returns (bool);
    function masterContractOf(address) external view returns (address);
    function totalSupply(IERC20) external view returns (uint256);
    function deploy(address masterContract, bytes calldata data) external;
    function setMasterContractApproval(address masterContract, bool approved) external;
    function deposit(IERC20 token, address from, uint256 amount) external payable;
    function depositTo(IERC20 token, address from, address to, uint256 amount) external payable;
    function depositWithPermit(IERC20 token, address from, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external payable;
    function depositWithPermitTo(
        IERC20 token, address from, address to, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external payable;
    function withdraw(IERC20 token, address to, uint256 amount) external;
    function withdrawFrom(IERC20 token, address from, address to, uint256 amount) external;
    function transfer(IERC20 token, address to, uint256 amount) external;
    function transferFrom(IERC20 token, address from, address to, uint256 amount) external;
    function transferMultiple(IERC20 token, address[] calldata tos, uint256[] calldata amounts) external;
    function transferMultipleFrom(IERC20 token, address from, address[] calldata tos, uint256[] calldata amounts) external;
    function skim(IERC20 token) external returns (uint256 amount);
    function skimTo(IERC20 token, address to) external returns (uint256 amount);
    function skimETH() external returns (uint256 amount);
    function skimETHTo(address to) external returns (uint256 amount);
    function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);
}
