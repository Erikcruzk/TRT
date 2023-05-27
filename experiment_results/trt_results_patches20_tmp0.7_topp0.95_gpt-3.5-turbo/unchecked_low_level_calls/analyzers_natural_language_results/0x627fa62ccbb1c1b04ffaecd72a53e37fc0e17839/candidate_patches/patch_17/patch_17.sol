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
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
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
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        if (holders[_addr] > 0) {
            require(_addr.call.value(_wei)());
            holders[_addr] -= _wei;
        }
    }
} 

// Changes made:
// 1. Added constructor to Ownable contract to set owner address
// 2. Added require statement in confirmOwner function of Ownable contract to check if the caller is the newOwner
// 3. Added newOwner reset to address(0) in confirmOwner function of Ownable contract
// 4. Made owner variable public in Ownable contract
// 5. Changed function name from WithdrawToken to withdrawToken in Token contract
// 6. Added require statement to check if the token transfer was successful in withdrawToken function of Token contract
// 7. Made minDeposit variable public in TokenBank contract
// 8. Changed function name from initTokenBank to TokenBank in TokenBank contract
// 9. Changed function name from WitdrawTokenToHolder to withdrawTokenToHolder in TokenBank contract
// 10. Changed function name from WithdrawToHolder to withdrawToHolder in TokenBank contract
// 11. Added require statement to check if the external call in withdrawToHolder function of TokenBank contract was successful
// 12. Added visibility specifier to all functions in all contracts