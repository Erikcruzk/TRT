// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/precompiles/iOVM_DeployerWhitelist.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title iOVM_DeployerWhitelist
 */
interface iOVM_DeployerWhitelist {

    /********************
     * Public Functions *
     ********************/

    function initialize(address _owner, bool _allowArbitraryDeployment) external;
    function getOwner() external returns (address _owner);
    function setWhitelistedDeployer(address _deployer, bool _isWhitelisted) external;
    function setOwner(address _newOwner) external;
    function setAllowArbitraryDeployment(bool _allowArbitraryDeployment) external;
    function enableArbitraryContractDeployment() external;
    function isDeployerAllowed(address _deployer) external returns (bool _allowed);
}
