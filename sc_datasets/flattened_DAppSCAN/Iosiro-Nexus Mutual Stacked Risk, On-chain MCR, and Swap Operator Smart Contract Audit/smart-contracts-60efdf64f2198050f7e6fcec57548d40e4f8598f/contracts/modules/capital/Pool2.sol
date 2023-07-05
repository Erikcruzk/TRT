// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Nexus Mutual Stacked Risk, On-chain MCR, and Swap Operator Smart Contract Audit/smart-contracts-60efdf64f2198050f7e6fcec57548d40e4f8598f/contracts/abstract/INXMMaster.sol

/* Copyright (C) 2020 NexusMutual.io

  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

  This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/ */

pragma solidity ^0.5.0;

contract INXMMaster {

  address public tokenAddress;

  address public owner;

  uint public pauseTime;

  function delegateCallBack(bytes32 myid) external;

  function masterInitialized() public view returns (bool);

  function isInternal(address _add) public view returns (bool);

  function isPause() public view returns (bool check);

  function isOwner(address _add) public view returns (bool);

  function isMember(address _add) public view returns (bool);

  function checkIsAuthToGoverned(address _add) public view returns (bool);

  function updatePauseTime(uint _time) public;

  function dAppLocker() public view returns (address _add);

  function dAppToken() public view returns (address _add);

  function getLatestAddress(bytes2 _contractName) public view returns (address payable contractAddress);
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Nexus Mutual Stacked Risk, On-chain MCR, and Swap Operator Smart Contract Audit/smart-contracts-60efdf64f2198050f7e6fcec57548d40e4f8598f/contracts/abstract/MasterAware.sol

/*
    Copyright (C) 2020 NexusMutual.io

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/
*/

pragma solidity ^0.5.0;

contract MasterAware {

  INXMMaster public master;

  modifier onlyMember {
    require(master.isMember(msg.sender), "Caller is not a member");
    _;
  }

  modifier onlyInternal {
    require(master.isInternal(msg.sender), "Caller is not an internal contract");
    _;
  }

  modifier onlyMaster {
    if (address(master) != address(0)) {
      require(address(master) == msg.sender, "Not master");
    }
    _;
  }

  modifier onlyGovernance {
    require(
      master.checkIsAuthToGoverned(msg.sender),
      "Caller is not authorized to govern"
    );
    _;
  }

  modifier whenPaused {
    require(master.isPause(), "System is not paused");
    _;
  }

  modifier whenNotPaused {
    require(!master.isPause(), "System is paused");
    _;
  }

  function changeDependentContractAddress() external;

  function changeMasterAddress(address masterAddress) public onlyMaster {
    master = INXMMaster(masterAddress);
  }
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Nexus Mutual Stacked Risk, On-chain MCR, and Swap Operator Smart Contract Audit/smart-contracts-60efdf64f2198050f7e6fcec57548d40e4f8598f/contracts/modules/capital/Pool2.sol

/* Copyright (C) 2020 NexusMutual.io

  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

  This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/ */

pragma solidity ^0.5.0;


/**
 * @dev Send assets to Pool1
 */
contract Pool2 is MasterAware {

  IERC20 public dai;

  constructor (address masterAddress, address _dai) public {
    changeMasterAddress(masterAddress);
    dai = IERC20(_dai);
  }

  function sendEther() external payable {
    // noop
  }

  // triggered after all contracts upgrade
  function changeDependentContractAddress() external {

    address poolAddress = master.getLatestAddress("P1");
    uint balance = dai.balanceOf(address(this));
    uint etherBalance = address(this).balance;

    // transfer dai
    require(dai.transfer(poolAddress, balance), "P2: failed to send DAI to P1");

    // transfer ether
    (bool ok, /* data */) = poolAddress.call.value(etherBalance)("");
    require(ok, "P2: failed to send ETH to P1");
  }

}
