// File: ../sc_datasets/DAppSCAN/Inspex-Token/iAM-Admin-Poll-Token-0f8bb7a04c439286a5dffa223c3b30265acb4b5c/interfaces/IERC20Burnable.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IERC20Burnable {
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function burn(uint256 amount) external;

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  function adminTransfer(
    address,
    address,
    uint256
  ) external returns (bool);

  function transferOwnership(address) external;
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/Inspex-Token/iAM-Admin-Poll-Token-0f8bb7a04c439286a5dffa223c3b30265acb4b5c/MultipleTransferProxy.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;


contract MultipleTransferProxy is ReentrancyGuard {
  function singleTransfer(
    address _recipient,
    address _token,
    uint256 _amount
  ) public nonReentrant returns (bool) {
    IERC20Burnable ERC20 = IERC20Burnable(_token);
    ERC20.transferFrom(msg.sender, _recipient, _amount);
    return true;
  }

  function multipleTransfer(
    address _token,
    address[] memory _recipients,
    uint256[] memory _amounts
  ) external returns (bool) {
    require(_recipients.length == _amounts.length);
    for (uint256 i = 0; i < _recipients.length; i++) {
      bool success = singleTransfer(_recipients[i], _token, _amounts[i]);
      require(success, 'transfer not success');
    }
    return true;
  }
}
