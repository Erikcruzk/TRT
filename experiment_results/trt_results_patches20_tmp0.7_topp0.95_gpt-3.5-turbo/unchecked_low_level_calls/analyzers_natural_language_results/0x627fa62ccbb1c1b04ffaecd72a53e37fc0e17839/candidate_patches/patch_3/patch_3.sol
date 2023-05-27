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
        newOwner = 0x0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount));
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
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            Token token = Token(_token);
            token.withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        if (holders[_addr] > 0) {
            holders[_addr] -= _wei;
            require(_addr.send(_wei));
        }
    }
} 

// Changes Made:
// 1. Made owner and newOwner variables public
// 2. Added constructor to Ownable contract
// 3. Added require statement to confirmOwner function
// 4. Added require statement to withdrawToken function in Token contract
// 5. Changed WithdrawToken function name to withdrawToken in Token contract
// 6. Renamed variables to follow Solidity naming convention
// 7. Added Token contract instance in TokenBank contract to call withdrawToken function
// 8. Added require statement in withdrawToHolder function to check send() success