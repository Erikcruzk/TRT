pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        require(addr != address(0)); // Ensure new owner address is not 0x0
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner); // Ensure only the new owner can confirm ownership
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner); // Ensure only the owner can call functions with this modifier
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token != address(0)); // Ensure token address is not 0x0
        require(to != address(0)); // Ensure recipient address is not 0x0
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount)); // Use keccak256 instead of sha3 and require transfer call to succeed
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function initTokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() payable {
        deposit();
    }

    function deposit() payable {
        if (msg.value >= MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(_to != address(0)); // Ensure recipient address is not 0x0
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(_addr != address(0)); // Ensure recipient address is not 0x0
        if (Holders[msg.sender] > 0) {
            if (Holders[_addr] >= _wei) {
                _addr.transfer(_wei); // Use transfer instead of call.value
                Holders[_addr] -= _wei;
            }
        }
    }

    function bal() public constant returns (uint) {
        return this.balance;
    }
}