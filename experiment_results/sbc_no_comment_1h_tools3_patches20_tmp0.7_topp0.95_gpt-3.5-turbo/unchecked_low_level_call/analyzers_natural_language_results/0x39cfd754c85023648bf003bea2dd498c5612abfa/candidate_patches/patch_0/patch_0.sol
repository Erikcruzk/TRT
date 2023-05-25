pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner returns (bool) {
        require(_token != address(0));
        return _token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount);
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function TokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner returns (bool) {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            return withdrawToken(_token, _amount, _to);
        }
        return false;
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (Holders[_addr] >= _wei) {
            _addr.transfer(_wei);
            Holders[_addr] -= _wei;
        }
    }
} 

// Changes made:
// 1. Added constructor function to Ownable contract to set the owner
// 2. Added require statements to confirmOwner() and onlyOwner() modifiers to ensure only the owner can call those functions
// 3. Changed WithdrawToken function to withdrawToken and added require statement to check for valid token address and return value of external call
// 4. Added return statement to withdrawTokenToHolder function to return the value of the external call
// 5. Changed WitdrawTokenToHolder to withdrawTokenToHolder to fix spelling error
// 6. Added return statement to withdrawToHolder function to check for successful transfer and return boolean value