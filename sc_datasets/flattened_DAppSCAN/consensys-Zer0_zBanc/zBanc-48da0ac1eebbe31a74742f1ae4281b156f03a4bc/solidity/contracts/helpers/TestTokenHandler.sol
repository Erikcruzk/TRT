// File: ../sc_datasets/DAppSCAN/consensys-Zer0_zBanc/zBanc-48da0ac1eebbe31a74742f1ae4281b156f03a4bc/solidity/contracts/token/interfaces/IERC20Token.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    ERC20 Standard Token interface
*/
interface IERC20Token {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function allowance(address _owner, address _spender) external view returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/consensys-Zer0_zBanc/zBanc-48da0ac1eebbe31a74742f1ae4281b156f03a4bc/solidity/contracts/utility/TokenHandler.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

contract TokenHandler {
    bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));
    bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
    bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));

    /**
      * @dev executes the ERC20 token's `approve` function and reverts upon failure
      * the main purpose of this function is to prevent a non standard ERC20 token
      * from failing silently
      *
      * @param _token   ERC20 token address
      * @param _spender approved address
      * @param _value   allowance amount
    */
    function safeApprove(IERC20Token _token, address _spender, uint256 _value) internal {
        (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_APPROVE_FAILED');
    }

    /**
      * @dev executes the ERC20 token's `transfer` function and reverts upon failure
      * the main purpose of this function is to prevent a non standard ERC20 token
      * from failing silently
      *
      * @param _token   ERC20 token address
      * @param _to      target address
      * @param _value   transfer amount
    */
    function safeTransfer(IERC20Token _token, address _to, uint256 _value) internal {
       (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_TRANSFER_FAILED');
    }

    /**
      * @dev executes the ERC20 token's `transferFrom` function and reverts upon failure
      * the main purpose of this function is to prevent a non standard ERC20 token
      * from failing silently
      *
      * @param _token   ERC20 token address
      * @param _from    source address
      * @param _to      target address
      * @param _value   transfer amount
    */
    function safeTransferFrom(IERC20Token _token, address _from, address _to, uint256 _value) internal {
       (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_TRANSFER_FROM_FAILED');
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-Zer0_zBanc/zBanc-48da0ac1eebbe31a74742f1ae4281b156f03a4bc/solidity/contracts/helpers/TestTokenHandler.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Utils test helper that exposes the token handler functions
*/
contract TestTokenHandler is TokenHandler {
    function testSafeApprove(IERC20Token _token, address _spender, uint256 _value) public {
        safeApprove(_token, _spender, _value);
    }

    function testSafeTransfer(IERC20Token _token, address _to, uint256 _value) public {
        safeTransfer(_token, _to, _value);
    }

    function testSafeTransferFrom(IERC20Token _token, address _from, address _to, uint256 _value) public {
        safeTransferFrom(_token, _from, _to, _value);
    }
}
