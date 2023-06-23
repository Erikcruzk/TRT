pragma solidity 0.5.11;

import { OUSDStorage } from "./OUSDStorage.sol";

contract OUSDResolutionUpgrade is OUSDStorage {
    uint256 private constant RESOLUTION_INCREASE = 1e9;

    function upgradeGlobals() external {
        require(isUpgraded[address(0)] == 0);
        isUpgraded[address(0)] = 1;
        rebasingCredits = rebasingCredits.mul(RESOLUTION_INCREASE);
        rebasingCreditsPerToken = rebasingCreditsPerToken.mul(
            RESOLUTION_INCREASE
        );
    }

    function upgradeAccounts(address[] calldata accounts) external {
        for (uint256 i = 0; i < accounts.length; i++) {
            address account = accounts[i];
            require(isUpgraded[account] == 0);
            isUpgraded[account] = 1;

            // Is the account non-rebasing
            uint256 nrc = nonRebasingCreditsPerToken[account];
            if (nrc > 1e19) {
                // Account has already been created at high resolution
                continue;
            }

            if (nrc > 0) {
                nonRebasingCreditsPerToken[account] = nrc.mul(
                    RESOLUTION_INCREASE
                );
            }
            _creditBalances[account] = _creditBalances[account].mul(
                RESOLUTION_INCREASE
            );
        }
    }

    // We have to fill the ERC20 interface in order to not be an abstract
    // contract that cannot be deployed.

    function totalSupply() external view returns (uint256) {
        revert("OUSD: Upgrading");
    }

    function balanceOf(address account) external view returns (uint256) {
        revert("OUSD: Upgrading");
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        revert("OUSD: Upgrading");
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        revert("OUSD: Upgrading");
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        revert("OUSD: Upgrading");
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        revert("OUSD: Upgrading");
    }
}
