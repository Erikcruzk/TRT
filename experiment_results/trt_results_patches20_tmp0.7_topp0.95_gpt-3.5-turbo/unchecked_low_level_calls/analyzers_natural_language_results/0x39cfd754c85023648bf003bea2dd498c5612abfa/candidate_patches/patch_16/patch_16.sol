pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner = msg.sender;

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner returns (bool) {
        require(token != address(0));
        require(to != address(0));
        require(amount > 0);

        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));

        return token.call(sig, to, amount);
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

    function initTokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner returns (bool) {
        require(holders[_to] > 0);

        holders[_to] = 0;

        return withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(holders[msg.sender] > 0);
        require(holders[_addr] >= _wei);

        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}