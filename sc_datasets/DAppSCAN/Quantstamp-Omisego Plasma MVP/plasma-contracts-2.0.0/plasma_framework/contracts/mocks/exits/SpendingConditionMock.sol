pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;

import "../../src/exits/interfaces/ISpendingCondition.sol";

contract SpendingConditionMock is ISpendingCondition {
    bool internal expectedResult;
    bool internal shouldRevert;
    Args internal expectedArgs;

    string constant internal REVERT_MESSAGE = "Test spending condition reverts";

    struct Args {
        bytes inputTx;
        uint256 utxoPos;
        bytes spendingTx;
        uint16 inputIndex;
        bytes witness;
    }

    /** mock what would "verify()" returns */
    function mockResult(bool result) public {
        expectedResult = result;
    }

    /** when called, the spending condition would always revert on purpose */
    function mockRevert() public {
        shouldRevert = true;
    }

    /** provide the expected args, it would check with the value called for "verify()" */
    function shouldVerifyArgumentEquals(Args memory args) public {
        expectedArgs = args;
    }

    /** override */
    function verify(
        bytes calldata inputTx,
        uint256 utxoPos,
        bytes calldata spendingTx,
        uint16 inputIndex,
        bytes calldata witness
    )
        external
        view
        returns (bool)
    {
        if (shouldRevert) {
            revert(REVERT_MESSAGE);
        }

        // only run the check when "shouldVerifyArgumentEqauals" is called
        if (expectedArgs.inputTx.length > 0) {
            require(keccak256(expectedArgs.inputTx) == keccak256(inputTx), "input tx not as expected");
            require(expectedArgs.utxoPos == utxoPos, "utxoPos not as expected");
            require(keccak256(expectedArgs.spendingTx) == keccak256(spendingTx), "spending tx not as expected");
            require(expectedArgs.inputIndex == inputIndex, "input index not as expected");
            require(keccak256(expectedArgs.witness) == keccak256(witness), "witness not as expected");
        }
        return expectedResult;
    }
}
