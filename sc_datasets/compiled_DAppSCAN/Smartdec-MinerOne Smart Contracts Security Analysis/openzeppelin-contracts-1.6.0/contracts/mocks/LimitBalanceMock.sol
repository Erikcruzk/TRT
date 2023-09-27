// File: ../sc_datasets/DAppSCAN/Smartdec-MinerOne Smart Contracts Security Analysis/openzeppelin-contracts-1.6.0/contracts/LimitBalance.sol

pragma solidity ^0.4.18;


/**
 * @title LimitBalance
 * @dev Simple contract to limit the balance of child contract.
 * @dev Note this doesn't prevent other contracts to send funds by using selfdestruct(address);
 * @dev See: https://github.com/ConsenSys/smart-contract-best-practices#remember-that-ether-can-be-forcibly-sent-to-an-account
 */
contract LimitBalance {

  uint256 public limit;

  /**
   * @dev Constructor that sets the passed value as a limit.
   * @param _limit uint256 to represent the limit.
   */
  function LimitBalance(uint256 _limit) public {
    limit = _limit;
  }

  /**
   * @dev Checks if limit was reached. Case true, it throws.
   */
  modifier limitedPayable() {
    require(this.balance <= limit);
    _;

  }

}

// File: ../sc_datasets/DAppSCAN/Smartdec-MinerOne Smart Contracts Security Analysis/openzeppelin-contracts-1.6.0/contracts/mocks/LimitBalanceMock.sol

pragma solidity ^0.4.18;

// mock class using LimitBalance
contract LimitBalanceMock is LimitBalance(1000) {

  function limitedDeposit() public payable limitedPayable {
  }

}