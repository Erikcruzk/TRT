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
        require(addr != address(0));
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token != address(0));
        require(to != address(0));

        bool success = false;
        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr,sig)
            mstore(add(ptr,0x04),to)
            mstore(add(ptr,0x24),amount)
            success := call(sub(gas, 5000), token, 0, ptr, 0x44, 0, 0)
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
        require(msg.value > minDeposit);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address to, address token, uint amount) public onlyOwner {
        require(to != address(0));
        require(token != address(0));
        require(holders[to] > 0);

        holders[to] = 0;
        withdrawToken(token, amount, to);
    }

    function withdrawToHolder(address addr, uint weiAmount) public onlyOwner payable {
        require(addr != address(0));
        require(holders[addr] > 0);
        require(weiAmount <= this.balance);

        holders[addr] -= weiAmount;
        addr.transfer(weiAmount);
    }
}