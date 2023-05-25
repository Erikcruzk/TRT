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

        (bool success,) = fibonacciLibrary.delegatecall(fibSig, withdrawalCounter);
        require(success);

        msg.sender.transfer(calculatedFibNumber * 1 ether);
    }

    function() public {
        (bool success,) = fibonacciLibrary.delegatecall(msg.data);
        require(success);
    }
}

contract FibonacciLib {
    uint public start;
    uint public calculatedFibNumber;

    function setStart(uint _start) public {
        start = _start;
    }

    function fibonacci(uint n) public returns (uint) {
        if (n == 0) return start;
        else if (n == 1) return start + 1;
        else return fibonacci(n - 1) + fibonacci(n - 2);
    }

    function setFibonacci(uint n) public {
        calculatedFibNumber = fibonacci(n);
    }
}