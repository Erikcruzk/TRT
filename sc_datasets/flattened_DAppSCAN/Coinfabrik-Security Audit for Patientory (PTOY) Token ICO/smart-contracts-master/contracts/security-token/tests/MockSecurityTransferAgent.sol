// File: ../sc_datasets/DAppSCAN/Coinfabrik-Security Audit for Patientory (PTOY) Token ICO/smart-contracts-master/contracts/security-token/SecurityTransferAgentInterface.sol

pragma solidity ^0.4.18;

interface SecurityTransferAgent {
  function verify(address from, address to, uint256 value) external view returns (uint256 newValue);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Security Audit for Patientory (PTOY) Token ICO/smart-contracts-master/contracts/security-token/tests/MockSecurityTransferAgent.sol

pragma solidity ^0.4.18;

contract MockSecurityTransferAgent is SecurityTransferAgent {
  bool frozen = false;

  function MockSecurityTransferAgent() {
    // This is here for our verification code only
  }

  function freeze() public {
    frozen = true;
  }

  function verify(address from, address to, uint256 value) public view returns (uint256 newValue) {
    require(frozen == false);

    return 1;
  }
}
