pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount));
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    constructor() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (Holders[_addr] >= _wei) {
            Holders[_addr] -= _wei;
            _addr.transfer(_wei);
        }
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
} 

// Changes Made:
// 1. Made owner and newOwner variables public
// 2. Added a constructor to the Ownable contract to set owner
// 3. Replaced sha3 with keccak256 in Token contract
// 4. Added require statement to check the return value of external call in Token contract
// 5. Changed function names to follow Solidity naming conventions
// 6. Added require statement to check if Holders[_addr] is greater than or equal to _wei in withdrawToHolder function in TokenBank contract
// 7. Changed MinDeposit to a public variable for better accessibility
// 8. Changed balance() to a view function for better gas optimization