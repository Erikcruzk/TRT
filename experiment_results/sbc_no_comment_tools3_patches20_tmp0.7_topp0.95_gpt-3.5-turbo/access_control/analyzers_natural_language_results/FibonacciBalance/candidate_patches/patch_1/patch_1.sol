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

    function setFibonacci(uint n) public {
        calculatedFibNumber = fibonacci(n);
    }

    function fibonacci(uint n) internal pure returns (uint) {
        if (n == 0) return 0;
        else if (n == 1) return 1;
        else return fibonacci(n - 1) + fibonacci(n - 2);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.4.24
// 2. Added 'public' access modifier to withdraw() function
// 3. Updated sha3 to keccak256
// 4. Modified fibonacci() function to return correct values for n=0 and n=1
// 5. Added 'pure' access modifier to fibonacci() function to prevent state changes.