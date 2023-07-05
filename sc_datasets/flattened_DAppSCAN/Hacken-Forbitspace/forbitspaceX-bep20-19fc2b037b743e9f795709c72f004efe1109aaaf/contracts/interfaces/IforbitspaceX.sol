// File: ../sc_datasets/DAppSCAN/Hacken-Forbitspace/forbitspaceX-bep20-19fc2b037b743e9f795709c72f004efe1109aaaf/contracts/interfaces/IPayment.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

interface IPayment {
	function collectBNB() external returns (uint amount);

	function collectTokens(address token) external returns (uint amount);

	function setAdmin(address newAdmin) external ;
}

// File: ../sc_datasets/DAppSCAN/Hacken-Forbitspace/forbitspaceX-bep20-19fc2b037b743e9f795709c72f004efe1109aaaf/contracts/interfaces/IforbitspaceX.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

interface IforbitspaceX is IPayment {
	struct SwapParam {
		address addressToApprove;
		address exchangeTarget;
		address tokenIn; // tokenFrom
		address tokenOut; // tokenTo
		bytes swapData;
	}

	function aggregate(
		address tokenIn,
		address tokenOut,
		uint amountInTotal,
		address recipient,
		SwapParam[] calldata params
	) external payable returns (uint amountInAcutual, uint amountOutAcutual);
}
