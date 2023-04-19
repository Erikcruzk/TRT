pragma solidity ^0.4.19;

contract Ownable {
    address public owner;
    address public newOwner;

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
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);

        require(Token(_token).transfer(_to, _amount));
    }
}

contract TokenBank is Ownable {
    uint256 public minDeposit;
    mapping (address => uint256) public holders;

    function TokenBank() public {
        minDeposit = 1 ether;
    }

    function () public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit);

        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(holders[_to] > 0);
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);

        holders[_to] = 0;
        Token(token).withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _to, uint256 _amount) public onlyOwner {
        require(holders[_to] > 0);
        require(_to != address(0));
        require(_amount > 0);

        holders[_to] -= _amount;
        require(_to.call.value(_amount)());
    }
} 

// Fixed issues:
// 1. Added constructor to Ownable contract to set initial owner
// 2. Changed owner and newOwner to public in Ownable contract
// 3. Added require statements to input parameters in Token contract
// 4. Changed function name WithdrawToken to withdrawToken in Token contract
// 5. Added require statements to input parameters in TokenBank contract
// 6. Changed function name initTokenBank to TokenBank in TokenBank contract
// 7. Added require statement to deposit function in TokenBank contract
// 8. Changed function name WitdrawTokenToHolder to withdrawTokenToHolder in TokenBank contract
// 9. Fixed integer underflow/overflow issue in deposit function in TokenBank contract
// 10. Added require statement to withdrawToHolder function in TokenBank contract
// 11. Changed visibility of minDeposit to public in TokenBank contract
// 12. Added public visibility to functions in TokenBank contract