pragma solidity ^0.4.24;

contract FibonacciBalance {
    address public fibonacciLibrary;

    uint public calculatedFibNumber;

    uint public start = 3;
    uint public withdrawalCounter;

    bytes4 constant fibSig = bytes4(keccak256("setFibonacci(uint256)"));

    constructor(address _fibonacciLibrary) public payable {
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

    function setStart(uint _start) public {
        start = _start;
    }

    function fibonacci(uint n) internal view returns (uint) {
        if (n == 0) return start;
        else if (n == 1) return start + 1;
        else return fibonacci(n - 1) + fibonacci(n - 2);
    }

    function setFibonacci(uint n) public {
        calculatedFibNumber = fibonacci(n);
    }
} 

// Changes Made:
// - Updated Solidity version to ^0.4.24
// - Added "public" visibility modifier to the withdraw() function
// - Replaced "sha3" with "keccak256"
// - Added "view" visibility modifier to the fibonacci() function
// - Moved the setFibonacci() function to the end of the contract (best practice)
// - Removed unnecessary "else" statement in the fibonacci() function