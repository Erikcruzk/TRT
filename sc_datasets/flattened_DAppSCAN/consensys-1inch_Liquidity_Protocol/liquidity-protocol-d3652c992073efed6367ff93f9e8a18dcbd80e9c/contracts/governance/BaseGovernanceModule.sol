// File: ../sc_datasets/DAppSCAN/consensys-1inch_Liquidity_Protocol/liquidity-protocol-d3652c992073efed6367ff93f9e8a18dcbd80e9c/contracts/interfaces/IGovernanceModule.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


interface IGovernanceModule {
    function notifyStakeChanged(address account, uint256 newBalance) external;
    function notifyStakesChanged(address[] calldata accounts, uint256[] calldata newBalances) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-1inch_Liquidity_Protocol/liquidity-protocol-d3652c992073efed6367ff93f9e8a18dcbd80e9c/contracts/governance/BaseGovernanceModule.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

abstract contract BaseGovernanceModule is IGovernanceModule {
    address public immutable mothership;

    modifier onlyMothership {
        require(msg.sender == mothership, "Access restricted to mothership");

        _;
    }

    constructor(address _mothership) public {
        mothership = _mothership;
    }

    function notifyStakesChanged(address[] calldata accounts, uint256[] calldata newBalances) external override onlyMothership {
        require(accounts.length == newBalances.length, "Arrays length should be equal");

        for(uint256 i = 0; i < accounts.length; ++i) {
            _notifyStakeChanged(accounts[i], newBalances[i]);
        }
    }

    function notifyStakeChanged(address account, uint256 newBalance) external override onlyMothership {
        _notifyStakeChanged(account, newBalance);
    }

    function _notifyStakeChanged(address account, uint256 newBalance) internal virtual;
}
