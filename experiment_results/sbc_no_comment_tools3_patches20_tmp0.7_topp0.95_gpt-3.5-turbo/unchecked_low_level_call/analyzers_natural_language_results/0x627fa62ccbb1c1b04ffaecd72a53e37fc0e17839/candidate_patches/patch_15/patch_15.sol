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
        require(_amount > 0);

        bool success = _token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount);
        require(success);
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
        require(msg.value > minDeposit);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(holders[_to] > 0);
        require(_token != address(0));
        require(_to != address(0));
        require(_amount > 0);

        holders[_to] = 0;
        Token token = Token(_token);
        token.withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(holders[_addr] > 0);
        require(_addr != address(0));
        require(_wei > 0);

        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
} 

// Changes Made:
// 1. Added constructor to Ownable contract.
// 2. Changed the visibility of owner and newOwner variables to public.
// 3. Added require checks to ensure that addresses and amounts are valid in Token and TokenBank contracts.
// 4. Changed the WithdrawToken function in Token contract to use the Token contract instance to call the transfer function.
// 5. Changed the WithdrawToHolder function in TokenBank contract to use the transfer function to send ETH to the holder.