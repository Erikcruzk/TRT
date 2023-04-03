/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 94
 */

pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
            newOwner = address(0);
        }
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(IERC20(_token).transfer(_to, _amount), "Transfer failed.");
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping (address => uint) public Holders;

    constructor() {
        MinDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(Holders[_to] > 0, "Holder has no balance.");
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint _wei) public onlyOwner {
        require(Holders[_addr] > 0, "Holder has no balance.");
        Holders[_addr] -= _wei;
        require(_addr.send(_wei), "Transfer failed.");
    }
} 

// Changes Made:
// 1. Added visibility modifiers to state variables.
// 2. Removed the redundant "owner" variable in the Token contract.
// 3. Changed the function name "WithdrawToken" to "withdrawToken" to follow naming conventions.
// 4. Added error handling to the transfer function in the Token contract.
// 5. Removed the initTokenBank function and added a constructor to the TokenBank contract.
// 6. Changed the fallback function to receive function.
// 7. Added the payable modifier to the withdrawToHolder function.
// 8. Added require statements to check for conditions before executing the function logic.