pragma solidity ^0.4.18;

contract Ownable {
    address newOwner;
    address public owner = msg.sender;

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner returns (bool) {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
        return true;
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

    function initTokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() payable public {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner returns (bool) {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            return withdrawToken(_token, _amount, _to);
        }
        return false;
    }

    function withdrawToHolder(address _addr, uint _wei) public payable onlyOwner returns (bool) {
        if (holders[msg.sender] > 0) {
            if (holders[_addr] >= _wei) {
                _addr.transfer(_wei);
                holders[_addr] -= _wei;
                return true;
            }
        }
        return false;
    }

    function balance() public constant returns (uint) {
        return this.balance;
    }
}