pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
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
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
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

// Changes made:
// - Added constructor function to Ownable contract to set owner address
// - Changed visibility of owner and newOwner variables to public
// - Added require statements to ensure function calls are only made by owner
// - Renamed WithdrawToken function to withdrawToken to follow Solidity naming conventions
// - Renamed WitdrawTokenToHolder function to withdrawTokenToHolder to fix typo
// - Changed MinDeposit variable to minDeposit to follow Solidity naming conventions
// - Added require statement to deposit function to ensure minimum deposit amount is met
// - Changed WithdrawToHolder function to first subtract the amount from the holder's balance before making the external call to prevent reentrancy vulnerability
// - Removed unnecessary initTokenBank function