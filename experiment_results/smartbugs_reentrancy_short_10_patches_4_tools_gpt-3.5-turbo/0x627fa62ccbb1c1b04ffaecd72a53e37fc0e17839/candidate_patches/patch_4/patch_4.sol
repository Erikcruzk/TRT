/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 94
 */

pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_token != address(0));
        require(_to != address(0));
        require(_amount > 0);

        bool success = false;
        bytes4 selector = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, selector)
            mstore(add(ptr, 0x04), _to)
            mstore(add(ptr, 0x24), _amount)
            success := call(gas, _token, 0, ptr, 0x44, 0, 0)
        }
        require(success);
    }
}

contract TokenBank is Token {
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
        require(msg.value >= minDeposit);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0);
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(holders[_addr] >= _wei);
        holders[_addr] -= _wei;
        require(_addr.call.value(_wei)());
    }
}