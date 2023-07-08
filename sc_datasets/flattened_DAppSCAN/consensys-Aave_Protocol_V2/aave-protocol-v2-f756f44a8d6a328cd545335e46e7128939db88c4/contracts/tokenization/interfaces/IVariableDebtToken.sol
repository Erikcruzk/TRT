// File: ../sc_datasets/DAppSCAN/consensys-Aave_Protocol_V2/aave-protocol-v2-f756f44a8d6a328cd545335e46e7128939db88c4/contracts/tokenization/interfaces/IScaledBalanceToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.8;

interface IScaledBalanceToken {

  /**
   * @dev emitted after the mint action
   * @param from the address performing the mint
   * @param value the amount to be minted
   * @param index the last index of the reserve
   **/
  event Mint(address indexed from, uint256 value, uint256 index);

  /**
   * @dev mints aTokens to user
   * only lending pools can call this function
   * @param user the address receiving the minted tokens
   * @param amount the amount of tokens to mint
   * @param index the liquidity index
   */
  function mint(
    address user,
    uint256 amount,
    uint256 index
  ) external;

  /**
   * @dev returns the principal balance of the user. The principal balance is the last
   * updated stored balance, which does not consider the perpetually accruing interest.
   * @param user the address of the user
   * @return the principal balance of the user
   **/
  function scaledBalanceOf(address user) external view returns (uint256);

  /**
   * @dev returns the principal balance of the user and principal total supply.
   * @param user the address of the user
   * @return the principal balance of the user
   * @return the principal total supply
   **/
  function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);

  /**
   * @dev Returns the scaled total supply of the variable debt token. Represents sum(borrows/index)
   * @return the scaled total supply
   **/
  function scaledTotalSupply() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Aave_Protocol_V2/aave-protocol-v2-f756f44a8d6a328cd545335e46e7128939db88c4/contracts/tokenization/interfaces/IVariableDebtToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.8;

/**
 * @title interface IVariableDebtToken
 * @author Aave
 * @notice defines the basic interface for a variable debt token.
 **/
interface IVariableDebtToken is IScaledBalanceToken {  
  
  /**
   * @dev emitted when variable debt is burnt
   * @param user the user which debt has been burned
   * @param amount the amount of debt being burned
   * @param index the index of the user
   **/
  event Burn(
    address indexed user,
    uint256 amount,
    uint256 index
  );

    /**
   * @dev burns user variable debt
   * @param user the user which debt is burnt
   * @param index the variable debt index of the reserve
   **/
  function burn(
    address user,
    uint256 amount,
    uint256 index
  ) external;
 
}
