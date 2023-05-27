pragma solidity ^0.4.16;

contract RealOldFuckMaker {
    address fuck = 0xc63e7b1DEcE63A77eD7E4Aeef5efb3b05C81438D;

    function makeOldFucks(uint32 number) public {
        uint32 i;
        for (i = 0; i < number; i++) {
            require(fuck.call(bytes4(sha3("giveBlockReward()"))));
        }
    }
} 

// Changes Made:
// 1. Added "public" visibility modifier to the function makeOldFucks().
// 2. Added "require" statement to check the return value of the external call.