// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/pcv/IPCVDepositBalances.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/// @title a PCV Deposit interface for only balance getters
/// @author Fei Protocol
interface IPCVDepositBalances {
    
    // ----------- Getters -----------
    
    /// @notice gets the effective balance of "balanceReportedIn" token if the deposit were fully withdrawn
    function balance() external view returns (uint256);

    /// @notice gets the token address in which this deposit returns its balance
    function balanceReportedIn() external view returns (address);

    /// @notice gets the resistant token balance and protocol owned fei of this deposit
    function resistantBalanceAndFei() external view returns (uint256, uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/pcv/IPCVDeposit.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/// @title a PCV Deposit interface
/// @author Fei Protocol
interface IPCVDeposit is IPCVDepositBalances {
    // ----------- Events -----------
    event Deposit(address indexed _from, uint256 _amount);

    event Withdrawal(
        address indexed _caller,
        address indexed _to,
        uint256 _amount
    );

    event WithdrawERC20(
        address indexed _caller,
        address indexed _token,
        address indexed _to,
        uint256 _amount
    );

    event WithdrawETH(
        address indexed _caller,
        address indexed _to,
        uint256 _amount
    );

    // ----------- State changing api -----------

    function deposit() external;

    // ----------- PCV Controller only state changing api -----------

    function withdraw(address to, uint256 amount) external;

    function withdrawERC20(address token, address to, uint256 amount) external;

    function withdrawETH(address payable to, uint256 amount) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/pcv/utils/IPCVDripController.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/// @title a PCV dripping controller interface
/// @author Fei Protocol
interface IPCVDripController {
    // ----------- Events -----------

    event SourceUpdate (address indexed oldSource, address indexed newSource);
    event TargetUpdate (address indexed oldTarget, address indexed newTarget);
    event DripAmountUpdate (uint256 oldDripAmount, uint256 newDripAmount);
    event Dripped (address indexed source, address indexed target, uint256 amount);

    // ----------- Governor only state changing api -----------

    function setSource(IPCVDeposit newSource) external;

    function setTarget(IPCVDeposit newTarget) external;

    function setDripAmount(uint256 newDripAmount) external;

    // ----------- Public state changing api -----------

    function drip() external;

    // ----------- Getters -----------

    function source() external view returns (IPCVDeposit);

    function target() external view returns (IPCVDeposit);

    function dripAmount() external view returns (uint256);

    function dripEligible() external view returns (bool);
}
