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

        (bool success, bytes memory data) = fibonacciLibrary.delegatecall(abi.encodeWithSelector(fibSig, withdrawalCounter));
        require(success);
        uint256 amount = calculatedFibNumber * 1 ether;
        calculatedFibNumber = 0;
        msg.sender.transfer(amount);
    }

    function() external payable {
        (bool success, bytes memory data) = fibonacciLibrary.delegatecall(msg.data);
        require(success);
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

    function fibonacci(uint n) public pure returns (uint) {
        if (n == 0) return 0;
        if (n == 1) return 1;
        uint a = 0;
        uint b = 1;
        for (uint i = 2; i <= n; i++) {
            uint c = a + b;
            a = b;
            b = c;
        }
        return b;
    }
}