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

    function fibonacci(uint n) internal pure returns (uint) {
        if (n == 0) return 0;
        else if (n == 1) return 1;
        else {
            uint a = 0;
            uint b = 1;
            uint c;
            for (uint i = 2; i <= n; i++) {
                c = a + b;
                a = b;
                b = c;
            }
            return b;
        }
    }
}