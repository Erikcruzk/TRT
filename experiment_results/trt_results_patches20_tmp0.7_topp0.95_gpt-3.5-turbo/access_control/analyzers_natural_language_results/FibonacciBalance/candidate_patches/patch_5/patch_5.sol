pragma solidity ^0.4.24;

contract FibonacciBalance {
    address public fibonacciLibrary;

    uint public calculatedFibNumber;

    uint public start = 3;
    uint public withdrawalCounter;

    bytes4 constant fibSig = bytes4(keccak256("setFibonacci(uint256)"));

    constructor(address _fibonacciLibrary) public payable {
        require(_fibonacciLibrary != address(0));
        fibonacciLibrary = _fibonacciLibrary;
    }

    function withdraw() public {
        withdrawalCounter += 1;

        require(fibonacciLibrary.delegatecall(fibSig, withdrawalCounter));
        require(msg.sender.send(calculatedFibNumber * 1 ether));
    }

    function() public {
        require(fibonacciLibrary.delegatecall(msg.data));
    }
}

contract FibonacciLib {
    uint public start;
    uint public calculatedFibNumber;

    function setStart(uint _start) public {
        start = _start;
    }

    function setFibonacci(uint n) public {
        calculatedFibNumber = fibonacci(n);
    }

    function fibonacci(uint n) internal view returns (uint) {
        if (n == 0) return start;
        else if (n == 1) return start + 1;
        else return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

// Changes made:
// 1. Updated Solidity version to ^0.4.24
// 2. Added require statement in constructor to check for valid library address
// 3. Made withdraw function public and added require statement to check for successful transfer
// 4. Changed sha3 to keccak256 for fibSig
// 5. Changed fibonacci function to view function since it does not modify state
// 6. Removed unused withdrawalCounter variable from FibonacciLib contract
// 7. Made setStart function public for testing purposes