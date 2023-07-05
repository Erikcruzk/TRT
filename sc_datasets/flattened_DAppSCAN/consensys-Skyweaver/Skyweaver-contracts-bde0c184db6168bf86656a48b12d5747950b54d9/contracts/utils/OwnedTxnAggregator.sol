// File: ../sc_datasets/DAppSCAN/consensys-Skyweaver/Skyweaver-contracts-bde0c184db6168bf86656a48b12d5747950b54d9/contracts/utils/Ownable.sol

pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address internal owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor () internal {
    owner = msg.sender;
    emit OwnershipTransferred(address(0), owner);
  }

  /**
   * @dev Throws if called by any account other than the master owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner, "Ownable#onlyOwner: SENDER_IS_NOT_OWNER");
    _;
  }

  /**
   * @notice Transfers the ownership of the contract to new address
   * @param _newOwner Address of the new owner
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    require(_newOwner != address(0), "Ownable#transferOwnership: INVALID_ADDRESS");
    owner = _newOwner;
    emit OwnershipTransferred(owner, _newOwner);
  }

  /**
   * @notice Returns the address of the owner.
   */
  function getOwner() public view returns (address) {
    return owner;
  }

}

// File: ../sc_datasets/DAppSCAN/consensys-Skyweaver/Skyweaver-contracts-bde0c184db6168bf86656a48b12d5747950b54d9/contracts/utils/OwnedTxnAggregator.sol

pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

/**
 * This is a contract allowing to batch execute contract calls or
 * contract queries.
 * only owner callable
 */
contract OwnedTxnAggregator is Ownable {

  /*
  * TO DO:
  *   - Put into seperate repo
  */

  struct ContractCall {
    address dest; // Contract to call
    bytes data;   // Calldata to pass to contract
  }

  /***********************************|
  |         BATCH TRANSACTIONS        |
  |__________________________________*/

  event Error(uint256 tx_id, bytes error);

  /**
   * @notice Will execute transactions with possibly different contracts
   * @param _txns    ContractCall struct array containing all the txns and target contract
   * @param _revert  To revert if a txn fail or to log the error
   */
  function executeTxns(ContractCall[] calldata _txns, bool _revert) external onlyOwner{
    // Execute all txns
    for (uint256 i = 0; i < _txns.length; i++) {
      (bool success, bytes memory resp) = _txns[i].dest.call(_txns[i].data);
      if (!success) {
        // Will either revert on error or log it
        if (_revert) {
          revert(string(resp));
        } else {
          emit Error(i, resp);
        }
      }
    }
  }

  /**
   * @notice Will execute transactions calling _contract
   * @param _contract Target contract that txns are calling
   * @param _txns     Array containing encoded function calls to _contract
   * @param _revert   To revert if a txn fail or to log the error
   */
  function singleContract_executeTxns(address _contract, bytes[] calldata _txns, bool _revert) external onlyOwner{
    // Execute all txns
    for (uint256 i = 0; i < _txns.length; i++) {
      (bool success, bytes memory resp) = _contract.call(_txns[i]);
      if (!success) {
        // Will either revert on error or log it
        if (_revert) {
          revert(string(resp));
        } else {
          emit Error(i, resp);
        }
      }
    }
  }

  /***********************************|
  |           BATCH QUERIES           |
  |__________________________________*/

  /**
   * @notice Will call functions to retrieve data calling _contract
   * @param _txns ContractCall struct array containing all the queries data and target contract
   */
  function viewTxns(ContractCall[] calldata _txns) external view onlyOwner returns (bytes[] memory) {
    // Declaration
    bool success;
    uint256 n_txns = _txns.length;
    bytes[] memory responses = new bytes[](n_txns);

    // Execute all txns
    for (uint256 i = 0; i < n_txns; i++) {
      (success, responses[i]) = _txns[i].dest.staticcall(_txns[i].data);
    }
  }
}
