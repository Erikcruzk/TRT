pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_to != address(0)); // prevent sending tokens to address(0)
        require(Token(_token).transfer(_to, _amount)); // use transfer function instead of low-level call
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping (address => uint) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if(msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if(holders[_to] > 0) {
            holders[_to] = 0;
            Token(token).withdrawToken(_token, _amount, _to); // call function from Token contract
        }
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        if(holders[_addr] > 0 && _wei <= holders[_addr]) { // add a check to prevent underflow
            holders[_addr] -= _wei;
            require(_addr.send(_wei)); // use send function instead of low-level call
        }
    }
}