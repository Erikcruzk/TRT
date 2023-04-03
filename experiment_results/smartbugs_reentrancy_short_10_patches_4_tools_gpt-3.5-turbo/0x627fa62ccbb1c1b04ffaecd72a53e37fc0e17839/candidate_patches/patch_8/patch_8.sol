/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 94
 */

pragma solidity ^0.8.0;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        (bool success, ) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
        require(success, "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping(address => uint256) public holders;

    constructor() {
        minDeposit = 1 ether;
        owner = msg.sender;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(address payable _addr, uint256 _wei) public onlyOwner {
        if (holders[_addr] >= _wei) {
            holders[_addr] -= _wei;
            (bool success, ) = _addr.call{value: _wei}("");
            require(success, "ETH transfer failed");
        }
    }
} 

// Changes Made:
// 1. Added visibility modifiers to state variables
// 2. Added constructor to initialize owner
// 3. Changed function names to follow Solidity naming conventions
// 4. Replaced deprecated "call" with "call" with encoded function signature
// 5. Added error handling and require statements to ensure proper execution of functions
// 6. Changed fallback function to receive function
// 7. Added "payable" modifier to withdrawToHolder function
// 8. Fixed reentrancy vulnerability by updating state before transferring ETH