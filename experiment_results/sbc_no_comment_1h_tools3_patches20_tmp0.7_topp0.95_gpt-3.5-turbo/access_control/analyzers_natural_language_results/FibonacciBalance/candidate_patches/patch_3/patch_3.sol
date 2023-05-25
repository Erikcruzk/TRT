pragma solidity ^0.4.24;

contract FibonacciBalance {
    address public fibonacciLibrary;
    uint public calculatedFibNumber;
    uint public start = 3;
    uint public withdrawalCounter;

    bytes4 constant fibSig = bytes4(keccak256("setFibonacci(uint256)"));

    constructor(address _fibonacciLibrary) public payable {
        require(_fibonacciLibrary != address(0)); // Check that library address is not 0x0
        fibonacciLibrary = _fibonacciLibrary;
    }

    function withdraw() public {
        withdrawalCounter += 1;
        require(fibonacciLibrary.delegatecall(fibSig, withdrawalCounter));
        msg.sender.transfer(calculatedFibNumber * 1 ether);
    }

    function() public {
        require(fibonacciLibrary.delegatecall(msg.data));
    }
}

contract FibonacciLib {
    uint public start;
    uint public calculatedFibNumber;

    constructor(uint _start) public {
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

/*
Changes Made:
1. Upgraded solidity version to ^0.4.24
2. Added visibility modifier to withdraw() and fallback function.
3. Added a require statement to check that library address is not 0x0.
4. Changed sha3() to keccak256() since sha3() is deprecated in newer versions of Solidity.
5. Added a constructor to FibonacciLib contract to set the start value.
6. Changed the fibonacci() function to view function since it doesn't modify state variables.
*/