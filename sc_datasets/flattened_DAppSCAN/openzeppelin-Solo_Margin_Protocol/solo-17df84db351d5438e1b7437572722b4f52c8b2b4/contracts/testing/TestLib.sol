// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Solo_Margin_Protocol/solo-17df84db351d5438e1b7437572722b4f52c8b2b4/contracts/protocol/lib/Require.sol

/*

    Copyright 2018 dYdX Trading Inc.

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

pragma solidity 0.5.4;


/**
 * @title Require
 * @author dYdX
 *
 * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
 */
library Require {

    // ============ Constants ============

    uint256 constant ASCII_ZERO = 48; // '0'
    uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
    uint256 constant ASCII_LOWER_EX = 120; // 'x'
    bytes2 constant COLON = 0x3a20; // ': '
    bytes2 constant COMMA = 0x2c20; // ', '
    bytes2 constant LPAREN = 0x203c; // ' <'
    byte constant RPAREN = 0x3e; // '>'

    // ============ Library Functions ============

    function that(
        bool must,
        bytes32 file,
        bytes32 reason
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringify(file),
                        COLON,
                        stringify(reason)
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        uint256 payloadA
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringify(file),
                        COLON,
                        stringify(reason),
                        LPAREN,
                        stringify(payloadA),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        uint256 payloadA,
        uint256 payloadB
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringify(file),
                        COLON,
                        stringify(reason),
                        LPAREN,
                        stringify(payloadA),
                        COMMA,
                        stringify(payloadB),
                        RPAREN
                    )
                )
            );
        }
    }

    function that(
        bool must,
        bytes32 file,
        bytes32 reason,
        address payloadA
    )
        internal
        pure
    {
        if (!must) {
            revert(
                string(
                    abi.encodePacked(
                        stringify(file),
                        COLON,
                        stringify(reason),
                        LPAREN,
                        stringify(payloadA),
                        RPAREN
                    )
                )
            );
        }
    }

    // ============ Private Functions ============

    function stringify(
        bytes32 b
    )
        private
        pure
        returns (bytes memory)
    {
        bytes memory r = abi.encodePacked(b);
        for (uint256 i = 0; i < 32; i++) {
            if (r[i] == 0) {
                /* solium-disable-next-line security/no-inline-assembly */
                assembly {
                    mstore(r, i) // r.length = i;
                }
                return r;
            }
        }
        return r;
    }

    function stringify(
        uint256 i
    )
        private
        pure
        returns (bytes memory)
    {
        if (i == 0) {
            return "0";
        }

        // get length
        uint256 j = i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }

        // get string
        j = i;
        bytes memory bstr = new bytes(length);
        uint256 k = length - 1;
        while (j != 0) {
            bstr[k--] = byte(uint8(ASCII_ZERO + (j % 10)));
            j /= 10;
        }

        return bstr;
    }

    function stringify(
        address a
    )
        private
        pure
        returns (bytes memory)
    {
        uint256 z = uint256(a);

        bytes memory result = new bytes(42);
        result[0] = byte(uint8(ASCII_ZERO));
        result[1] = byte(uint8(ASCII_LOWER_EX));

        for (uint256 i = 0; i < 20; i++) {
            uint256 shift = i * 2;
            result[41 - shift] = char(z & 0xf);
            z = z >> 4;
            result[40 - shift] = char(z & 0xf);
            z = z >> 4;
        }

        return result;
    }

    function char(
        uint256 b
    )
        private
        pure
        returns (byte)
    {
        if (b < 10) {
            return byte(uint8(b + ASCII_ZERO));
        }
        return byte(uint8(b + ASCII_RELATIVE_ZERO));
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Solo_Margin_Protocol/solo-17df84db351d5438e1b7437572722b4f52c8b2b4/contracts/protocol/lib/Math.sol

/*

    Copyright 2018 dYdX Trading Inc.

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

pragma solidity 0.5.4;


/**
 * @title Math
 * @author dYdX
 *
 * Library for non-standard Math functions
 */
library Math {
    using SafeMath for uint256;

    // ============ Constants ============

    bytes32 constant FILE = "Math";

    // ============ Library Functions ============

    function getPartial(
        uint256 target,
        uint256 numerator,
        uint256 denominator
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(numerator).div(denominator);
    }

    function getPartialRoundUp(
        uint256 target,
        uint256 numerator,
        uint256 denominator
    )
        internal
        pure
        returns (uint256)
    {
        if (target == 0 || numerator == 0) {
            // SafeMath will check for zero denominator
            return SafeMath.div(0, denominator);
        }
        return target.mul(numerator).sub(1).div(denominator).add(1);
    }

    function to128(
        uint256 x
    )
        internal
        pure
        returns (uint128)
    {
        uint128 r = uint128(x);
        Require.that(
            r == x,
            FILE,
            "Unsafe cast to uint128"
        );
        return r;
    }

    function to96(
        uint256 x
    )
        internal
        pure
        returns (uint96)
    {
        uint96 r = uint96(x);
        Require.that(
            r == x,
            FILE,
            "Unsafe cast to uint96"
        );
        return r;
    }

    function to32(
        uint256 x
    )
        internal
        pure
        returns (uint32)
    {
        uint32 r = uint32(x);
        Require.that(
            r == x,
            FILE,
            "Unsafe cast to uint32"
        );
        return r;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Solo_Margin_Protocol/solo-17df84db351d5438e1b7437572722b4f52c8b2b4/contracts/protocol/lib/Time.sol

/*

    Copyright 2018 dYdX Trading Inc.

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

pragma solidity 0.5.4;

/**
 * @title Time
 * @author dYdX
 *
 * Library for dealing with time, assuming timestamps fit within 32 bits (valid until year 2106)
 */
library Time {

    // ============ Library Functions ============

    function currentTime()
        internal
        view
        returns (uint32)
    {
        return Math.to32(block.timestamp);
    }

    function hasHappened(
        uint32 time
    )
        internal
        view
        returns (bool)
    {
        return (time != 0) && (time <= currentTime());
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Solo_Margin_Protocol/solo-17df84db351d5438e1b7437572722b4f52c8b2b4/contracts/protocol/interfaces/IErc20.sol

/*

    Copyright 2018 dYdX Trading Inc.

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

pragma solidity 0.5.4;

/**
 * @title IErc20
 * @author dYdX
 *
 * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
 * that we dont automatically revert when calling non-compliant tokens that have no return value for
 * transfer(), transferFrom(), or approve().
 */
interface IErc20 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply(
    )
        external
        view
        returns (uint256);

    function balanceOf(
        address who
    )
        external
        view
        returns (uint256);

    function allowance(
        address owner,
        address spender
    )
        external
        view
        returns (uint256);

    function transfer(
        address to,
        uint256 value
    )
        external;


    function transferFrom(
        address from,
        address to,
        uint256 value
    )
        external;

    function approve(
        address spender,
        uint256 value
    )
        external;

    function name()
        external
        view
        returns (string memory);

    function symbol()
        external
        view
        returns (string memory);

    function decimals()
        external
        view
        returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Solo_Margin_Protocol/solo-17df84db351d5438e1b7437572722b4f52c8b2b4/contracts/protocol/lib/Token.sol

/*

    Copyright 2018 dYdX Trading Inc.

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

pragma solidity 0.5.4;


/**
 * @title Token
 * @author dYdX
 *
 * This library contains basic functions for interacting with ERC20 tokens. Modified to work with
 * tokens that don't adhere strictly to the ERC20 standard (for example tokens that don't return a
 * boolean value on success).
 */
library Token {

    // ============ Constants ============

    bytes32 constant FILE = "Token";

    // ============ Library Functions ============

    function balanceOf(
        address token,
        address owner
    )
        internal
        view
        returns (uint256)
    {
        return IErc20(token).balanceOf(owner);
    }

    function allowance(
        address token,
        address owner,
        address spender
    )
        internal
        view
        returns (uint256)
    {
        return IErc20(token).allowance(owner, spender);
    }

    function approve(
        address token,
        address spender,
        uint256 amount
    )
        internal
    {
        IErc20(token).approve(spender, amount);

        Require.that(
            checkSuccess(),
            FILE,
            "Approve failed"
        );
    }

    function approveMax(
        address token,
        address spender
    )
        internal
    {
        approve(
            token,
            spender,
            uint256(-1)
        );
    }

    function transfer(
        address token,
        address to,
        uint256 amount
    )
        internal
    {
        if (amount == 0 || to == address(this)) {
            return;
        }

        IErc20(token).transfer(to, amount);

        Require.that(
            checkSuccess(),
            FILE,
            "Transfer failed"
        );
    }

    function transferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    )
        internal
    {
        if (amount == 0 || to == from) {
            return;
        }

        IErc20(token).transferFrom(from, to, amount);

        Require.that(
            checkSuccess(),
            FILE,
            "TransferFrom failed"
        );
    }

    // ============ Private Functions ============

    /**
     * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
     * function returned 0 bytes or 32 bytes that are not all-zero.
     */
    function checkSuccess(
    )
        private
        pure
        returns (bool)
    {
        uint256 returnValue = 0;

        /* solium-disable-next-line security/no-inline-assembly */
        assembly {
            // check number of bytes returned from last function call
            switch returndatasize

            // no bytes returned: assume success
            case 0x0 {
                returnValue := 1
            }

            // 32 bytes returned: check if non-zero
            case 0x20 {
                // copy 32 bytes into scratch space
                returndatacopy(0x0, 0x0, 0x20)

                // load those bytes into returnValue
                returnValue := mload(0x0)
            }

            // not sure what was returned: dont mark as success
            default { }
        }

        return returnValue != 0;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Solo_Margin_Protocol/solo-17df84db351d5438e1b7437572722b4f52c8b2b4/contracts/protocol/lib/Types.sol

/*

    Copyright 2018 dYdX Trading Inc.

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

pragma solidity 0.5.4;


/**
 * @title Types
 * @author dYdX
 *
 * Library for interacting with the basic structs used in Solo
 */
library Types {
    using Math for uint256;

    // ============ AssetAmount ============

    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par  // the amount is denominated in par
    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at
    }

    struct AssetAmount {
        bool sign;
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }

    // ============ Par (Principal Amount) ============

    struct TotalPar {
        uint128 borrow;
        uint128 supply;
    }

    struct Par {
        bool sign;
        uint128 value;
    }

    function zeroPar()
        internal
        pure
        returns (Par memory)
    {
        return Par({
            sign: false,
            value: 0
        });
    }

    function sub(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (Par memory)
    {
        return add(a, negative(b));
    }

    function add(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (Par memory)
    {
        Par memory result;
        if (a.sign == b.sign) {
            result.sign = a.sign;
            result.value = SafeMath.add(a.value, b.value).to128();
        } else {
            if (a.value >= b.value) {
                result.sign = a.sign;
                result.value = SafeMath.sub(a.value, b.value).to128();
            } else {
                result.sign = b.sign;
                result.value = SafeMath.sub(b.value, a.value).to128();
            }
        }
        return result;
    }

    function equals(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (bool)
    {
        if (a.value == b.value) {
            if (a.value == 0) {
                return true;
            }
            return a.sign == b.sign;
        }
        return false;
    }

    function negative(
        Par memory a
    )
        internal
        pure
        returns (Par memory)
    {
        return Par({
            sign: !a.sign,
            value: a.value
        });
    }

    function isNegative(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return !a.sign && a.value > 0;
    }

    function isPositive(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.sign && a.value > 0;
    }

    function isZero(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.value == 0;
    }

    // ============ Wei (Token Amount) ============

    struct Wei {
        bool sign;
        uint256 value;
    }

    function zeroWei()
        internal
        pure
        returns (Wei memory)
    {
        return Wei({
            sign: false,
            value: 0
        });
    }

    function sub(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (Wei memory)
    {
        return add(a, negative(b));
    }

    function add(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (Wei memory)
    {
        Wei memory result;
        if (a.sign == b.sign) {
            result.sign = a.sign;
            result.value = SafeMath.add(a.value, b.value);
        } else {
            if (a.value >= b.value) {
                result.sign = a.sign;
                result.value = SafeMath.sub(a.value, b.value);
            } else {
                result.sign = b.sign;
                result.value = SafeMath.sub(b.value, a.value);
            }
        }
        return result;
    }

    function equals(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (bool)
    {
        if (a.value == b.value) {
            if (a.value == 0) {
                return true;
            }
            return a.sign == b.sign;
        }
        return false;
    }

    function negative(
        Wei memory a
    )
        internal
        pure
        returns (Wei memory)
    {
        return Wei({
            sign: !a.sign,
            value: a.value
        });
    }

    function isNegative(
        Wei memory a
    )
        internal
        pure
        returns (bool)
    {
        return !a.sign && a.value > 0;
    }

    function isPositive(
        Wei memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.sign && a.value > 0;
    }

    function isZero(
        Wei memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.value == 0;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Solo_Margin_Protocol/solo-17df84db351d5438e1b7437572722b4f52c8b2b4/contracts/testing/TestLib.sol

/*

    Copyright 2018 dYdX Trading Inc.

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

pragma solidity 0.5.4;
pragma experimental ABIEncoderV2;





/**
 * @title TestCallee
 * @author dYdX
 *
 * Contract for testing pure library functions
 */
contract TestLib {

    // TODO: other libraries

    // ============ Constants ============

    bytes32 constant FILE = "TestLib";

    // ============ Math Functions ============

    function MathGetPartial(
        uint256 target,
        uint256 numerator,
        uint256 denominator
    )
        external
        pure
        returns (uint256)
    {
        return Math.getPartial(target, numerator, denominator);
    }

    function MathGetPartialRoundUp(
        uint256 target,
        uint256 numerator,
        uint256 denominator
    )
        external
        pure
        returns (uint256)
    {
        return Math.getPartialRoundUp(target, numerator, denominator);
    }

    function MathTo128(
        uint256 x
    )
        external
        pure
        returns (uint128)
    {
        return Math.to128(x);
    }

    function MathTo96(
        uint256 x
    )
        external
        pure
        returns (uint96)
    {
        return Math.to96(x);
    }

    function MathTo32(
        uint256 x
    )
        external
        pure
        returns (uint32)
    {
        return Math.to32(x);
    }

    // ============ Require Functions ============

    function RequireThat0(
        bytes32 reason
    )
        external
        pure
    {
        Require.that(
            false,
            FILE,
            reason
        );
    }

    function RequireThat1(
        bytes32 reason,
        uint256 payloadA
    )
        external
        pure
    {
        Require.that(
            false,
            FILE,
            reason,
            payloadA
        );
    }

    function RequireThat2(
        bytes32 reason,
        uint256 payloadA,
        uint256 payloadB
    )
        external
        pure
    {
        Require.that(
            false,
            FILE,
            reason,
            payloadA,
            payloadB
        );
    }

    function RequireThatA(
        bytes32 reason,
        address payloadA
    )
        external
        pure
    {
        Require.that(
            false,
            FILE,
            reason,
            payloadA
        );
    }

    // ============ Time Functions ============

    function TimeCurrentTime()
        external
        view
        returns (uint32)
    {
        return Time.currentTime();
    }

    function TimeHasHappened(
        uint32 time
    )
        external
        view
        returns (bool)
    {
        return Time.hasHappened(time);
    }

    // ============ Token Functions ============

    function TokenBalanceOf(
        address token,
        address owner
    )
        external
        view
        returns (uint256)
    {
        return Token.balanceOf(token, owner);
    }

    function TokenAllowance(
        address token,
        address owner,
        address spender
    )
        external
        view
        returns (uint256)
    {
        return Token.allowance(token, owner, spender);
    }

    function TokenApprove(
        address token,
        address spender,
        uint256 amount
    )
        external
    {
        Token.approve(token, spender, amount);
    }

    function TokenApproveMax(
        address token,
        address spender
    )
        external
    {
        Token.approveMax(token, spender);
    }

    function TokenTransfer(
        address token,
        address to,
        uint256 amount
    )
        external
    {
        Token.transfer(token, to, amount);
    }

    function TokenTransferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    )
        external
    {
        Token.transferFrom(
            token,
            from,
            to,
            amount
        );
    }

    // ============ Types Functions ============

    function TypesZeroPar()
        external
        pure
        returns (Types.Par memory)
    {
        return Types.zeroPar();
    }

    function TypesParSub(
        Types.Par memory a,
        Types.Par memory b
    )
        public
        pure
        returns (Types.Par memory)
    {
        return Types.sub(a, b);
    }

    function TypesParAdd(
        Types.Par memory a,
        Types.Par memory b
    )
        public
        pure
        returns (Types.Par memory)
    {
        return Types.add(a, b);
    }

    function TypesParEquals(
        Types.Par memory a,
        Types.Par memory b
    )
        public
        pure
        returns (bool)
    {
        return Types.equals(a, b);
    }

    function TypesParNegative(
        Types.Par memory a
    )
        public
        pure
        returns (Types.Par memory)
    {
        return Types.negative(a);
    }

    function TypesParIsNegative(
        Types.Par memory a
    )
        public
        pure
        returns (bool)
    {
        return Types.isNegative(a);
    }

    function TypesParIsPositive(
        Types.Par memory a
    )
        public
        pure
        returns (bool)
    {
        return Types.isPositive(a);
    }

    function TypesParIsZero(
        Types.Par memory a
    )
        public
        pure
        returns (bool)
    {
        return Types.isZero(a);
    }

    function TypesZeroWei()
        external
        pure
        returns (Types.Wei memory)
    {
        return Types.zeroWei();
    }

    function TypesWeiSub(
        Types.Wei memory a,
        Types.Wei memory b
    )
        public
        pure
        returns (Types.Wei memory)
    {
        return Types.sub(a, b);
    }

    function TypesWeiAdd(
        Types.Wei memory a,
        Types.Wei memory b
    )
        public
        pure
        returns (Types.Wei memory)
    {
        return Types.add(a, b);
    }

    function TypesWeiEquals(
        Types.Wei memory a,
        Types.Wei memory b
    )
        public
        pure
        returns (bool)
    {
        return Types.equals(a, b);
    }

    function TypesWeiNegative(
        Types.Wei memory a
    )
        public
        pure
        returns (Types.Wei memory)
    {
        return Types.negative(a);
    }

    function TypesWeiIsNegative(
        Types.Wei memory a
    )
        public
        pure
        returns (bool)
    {
        return Types.isNegative(a);
    }

    function TypesWeiIsPositive(
        Types.Wei memory a
    )
        public
        pure
        returns (bool)
    {
        return Types.isPositive(a);
    }

    function TypesWeiIsZero(
        Types.Wei memory a
    )
        public
        pure
        returns (bool)
    {
        return Types.isZero(a);
    }
}
