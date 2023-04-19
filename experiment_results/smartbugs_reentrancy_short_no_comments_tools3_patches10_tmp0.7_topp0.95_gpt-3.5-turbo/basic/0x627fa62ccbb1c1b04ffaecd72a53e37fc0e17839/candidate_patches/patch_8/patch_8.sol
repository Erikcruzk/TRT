pragma solidity ^0.4.19;

contract Ownable {
    address public owner;
    address public newOwner;

    function Ownable() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }
    
    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_token != address(0));
        require(_to != address(0));
        
        bool success = false;
        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)
            mstore(add(ptr, 0x04), _to)
            mstore(add(ptr, 0x24), _amount)
            success := call(sub(gas, 10000), _token, 0, ptr, 0x44, 0, 0)
        }
        require(success);
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping (address => uint) public holders;

    function TokenBank() public {
        minDeposit = 1 ether;
    }
    
    function() public payable {
        deposit();
    }
    
    function deposit() public payable {
        if(msg.value >= minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }
    
    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0);
        holders[_to] = 0;
        Token token = Token(_token);
        token.withdrawToken(_token, _amount, _to);
    }
    
    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(holders[_addr] > 0);
        require(_wei <= this.balance);
        holders[_addr] = 0;
        _addr.transfer(_wei);
    }
}