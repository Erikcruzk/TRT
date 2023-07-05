// File: ../sc_datasets/DAppSCAN/Chainsulting-1inch/liquidity-protocol-master/contracts/interfaces/IGovernanceModule.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/// @title Interface for governance notifications
interface IGovernanceModule {
    function notifyStakeChanged(address account, uint256 newBalance) external;
    function notifyStakesChanged(address[] calldata accounts, uint256[] calldata newBalances) external;
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-1inch/liquidity-protocol-master/contracts/governance/BaseGovernanceModule.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/// @title Base governance contract with notification logics
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
