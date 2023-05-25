pragma solidity ^0.4.24;

contract FibonacciBalance {
    address public fibonacciLibrary;

    uint public calculatedFibNumber;

    uint public withdrawalCounter;

    bytes4 constant fibSig = bytes4(keccak256("setFibonacci(uint256)"));

    constructor(address _fibonacciLibrary) public payable {
        require(_fibonacciLibrary != address(0)); // add check for valid address
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
    uint public start = 0; // add default value for start

    function setStart(uint _start) public {
        start = _start;
    }

    function fibonacci(uint n) internal view returns (uint) { // add view keyword to fibonacci function
        if (n == 0) return start;
        else if (n == 1) return start + 1;
        else return fibonacci(n - 1) + fibonacci(n - 2);
    }

    function setFibonacci(uint n) public {
        require(n >= 0); // add check for non-negative input
        calculatedFibNumber = fibonacci(n);
    }
}