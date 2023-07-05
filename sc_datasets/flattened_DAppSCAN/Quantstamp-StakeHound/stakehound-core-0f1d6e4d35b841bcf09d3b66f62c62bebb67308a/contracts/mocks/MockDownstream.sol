// File: ../sc_datasets/DAppSCAN/Quantstamp-StakeHound/stakehound-core-0f1d6e4d35b841bcf09d3b66f62c62bebb67308a/contracts/mocks/Mock.sol

// contracts/StakedToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract Mock {
    event FunctionCalled(string instanceName, string functionName, address caller);
    event FunctionArguments(uint256[] uintVals, int256[] intVals);
    event ReturnValueInt256(int256 val);
    event ReturnValueUInt256(uint256 val);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-StakeHound/stakehound-core-0f1d6e4d35b841bcf09d3b66f62c62bebb67308a/contracts/mocks/MockDownstream.sol

// contracts/StakedToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract MockDownstream is Mock {
    function updateNoArg() external returns (bool) {
        emit FunctionCalled("MockDownstream", "updateNoArg", msg.sender);
        uint256[] memory uintVals = new uint256[](0);
        int256[] memory intVals = new int256[](0);
        emit FunctionArguments(uintVals, intVals);
        return true;
    }

    function updateOneArg(uint256 u) external {
        emit FunctionCalled("MockDownstream", "updateOneArg", msg.sender);

        uint256[] memory uintVals = new uint256[](1);
        uintVals[0] = u;
        int256[] memory intVals = new int256[](0);
        emit FunctionArguments(uintVals, intVals);
    }

    function updateTwoArgs(uint256 u, int256 i) external {
        emit FunctionCalled("MockDownstream", "updateTwoArgs", msg.sender);

        uint256[] memory uintVals = new uint256[](1);
        uintVals[0] = u;
        int256[] memory intVals = new int256[](1);
        intVals[0] = i;
        emit FunctionArguments(uintVals, intVals);
    }

    function reverts() external {
        emit FunctionCalled("MockDownstream", "reverts", msg.sender);

        uint256[] memory uintVals = new uint256[](0);
        int256[] memory intVals = new int256[](0);
        emit FunctionArguments(uintVals, intVals);

        require(false, "reverted");
    }
}
