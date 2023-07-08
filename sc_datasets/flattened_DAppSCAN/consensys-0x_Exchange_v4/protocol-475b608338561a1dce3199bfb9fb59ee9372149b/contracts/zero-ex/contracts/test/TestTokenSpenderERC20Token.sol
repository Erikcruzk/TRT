// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/zero-ex/contracts/test/TestMintableERC20Token.sol

/*

  Copyright 2020 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.6.5;
pragma experimental ABIEncoderV2;


contract TestMintableERC20Token {

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address to, uint256 amount)
        external
        virtual
        returns (bool)
    {
        return transferFrom(msg.sender, to, amount);
    }

    function approve(address spender, uint256 amount)
        external
        virtual
        returns (bool)
    {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function approveAs(address owner, address spender, uint256 amount)
        external
        returns (bool)
    {
        allowance[owner][spender] = amount;
        return true;
    }

    function mint(address owner, uint256 amount)
        external
        virtual
    {
        balanceOf[owner] += amount;
    }

    function burn(address owner, uint256 amount)
        external
        virtual
    {
        require(balanceOf[owner] >= amount, "TestMintableERC20Token/INSUFFICIENT_FUNDS");
        balanceOf[owner] -= amount;
    }

    function transferFrom(address from, address to, uint256 amount)
        public
        virtual
        returns (bool)
    {
        if (from != msg.sender) {
            require(
                allowance[from][msg.sender] >= amount,
                "TestMintableERC20Token/INSUFFICIENT_ALLOWANCE"
            );
            allowance[from][msg.sender] -= amount;
        }
        require(balanceOf[from] >= amount, "TestMintableERC20Token/INSUFFICIENT_FUNDS");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function getSpendableAmount(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return balanceOf[owner] < allowance[owner][spender]
            ? balanceOf[owner]
            : allowance[owner][spender];
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/zero-ex/contracts/test/TestTokenSpenderERC20Token.sol

/*

  Copyright 2020 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.6.5;
pragma experimental ABIEncoderV2;

contract TestTokenSpenderERC20Token is
    TestMintableERC20Token
{

    event TransferFromCalled(
        address sender,
        address from,
        address to,
        uint256 amount
    );

    // `transferFrom()` behavior depends on the value of `amount`.
    uint256 constant private EMPTY_RETURN_AMOUNT = 1337;
    uint256 constant private FALSE_RETURN_AMOUNT = 1338;
    uint256 constant private REVERT_RETURN_AMOUNT = 1339;
    uint256 constant private TRIGGER_FALLBACK_SUCCESS_AMOUNT = 1340;
    uint256 constant private EXTRA_RETURN_TRUE_AMOUNT = 1341;
    uint256 constant private EXTRA_RETURN_FALSE_AMOUNT = 1342;

    bool private _isGreedyRevert;

    function setGreedyRevert(bool isGreedy) external {
        _isGreedyRevert = isGreedy;
    }

    function transferFrom(address from, address to, uint256 amount)
        public
        override
        returns (bool)
    {
        emit TransferFromCalled(msg.sender, from, to, amount);
        if (amount == EMPTY_RETURN_AMOUNT) {
            assembly { return(0, 0) }
        }
        if (amount == FALSE_RETURN_AMOUNT) {
            return false;
        }
        if (amount == REVERT_RETURN_AMOUNT) {
            assert(!_isGreedyRevert);
            revert("TestTokenSpenderERC20Token/Revert");
        }
        if (amount == TRIGGER_FALLBACK_SUCCESS_AMOUNT) {
            assert(!_isGreedyRevert);
            return false;
        }
        if (amount == EXTRA_RETURN_TRUE_AMOUNT
            || amount == EXTRA_RETURN_FALSE_AMOUNT) {
            bool ret = amount == EXTRA_RETURN_TRUE_AMOUNT;

            assembly {
                mstore(0x00, ret)
                mstore(0x20, amount) // just something extra to return
                return(0, 0x40)
            }
        }
        return true;
    }

    function setBalanceAndAllowanceOf(
        address owner,
        uint256 balance,
        address spender,
        uint256 allowance_
    )
        external
    {
        balanceOf[owner] = balance;
        allowance[owner][spender] = allowance_;
    }
}
