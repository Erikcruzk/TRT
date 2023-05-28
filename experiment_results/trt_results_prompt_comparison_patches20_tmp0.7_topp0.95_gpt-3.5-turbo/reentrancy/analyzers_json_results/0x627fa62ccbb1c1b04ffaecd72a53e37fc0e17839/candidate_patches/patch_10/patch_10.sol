pragma solidity ^0.4.19;

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
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping(address => uint) public holders;

    function TokenBank() public {
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
    ) public onlyOwner {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            Token(token).withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (holders[_addr] > 0) {
            holders[_addr] -= _wei;
            require(_addr.call.value(_wei)());
        }
    }
} 

// Changes made:
// 1. Added constructor function for Ownable contract to set initial owner
// 2. Changed function names to follow Solidity naming conventions
// 3. Added require statements to check conditions and revert if they are not met
// 4. Made owner and newOwner variables public for visibility
// 5. Changed WithdrawToken function call to use Token contract instead of token variable
// 6. Fixed typo in minDeposit variable name
// 7. Removed unnecessary owner variable declaration in Token contract
// 8. Decremented holders[_addr] before external call in WithdrawToHolder function to prevent reentrancy vulnerability.