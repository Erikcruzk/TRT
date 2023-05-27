pragma solidity ^0.4.23;

contract Delta {
    address public c = 0xF85A2E95FA30d005F629cBe6c6d2887D979ffF2A;
    address public owner = 0x788c45dd60ae4dbe5055b5ac02384d5dc84677b0;
    address public owner2 = 0x0C6561edad2017c01579Fd346a58197ea01A0Cf3;
    uint public active = 1;

    uint public token_price = (10 ** 18 * 1) / 1000;

    function() payable public {
        tokens_buy();
    }

    function tokens_buy() payable public returns (bool) {
        require(active > 0);
        require(msg.value >= token_price);

        uint tokens_buy = (msg.value * 10 ** 18) / token_price;

        require(tokens_buy > 0);

        bool success = c.call(bytes4(keccak256("transferFrom(address,address,uint256)")), owner, msg.sender, tokens_buy);

        if (!success) {
            revert();
        }

        uint sum2 = (msg.value * 3) / 10;

        owner2.transfer(sum2);

        return true;
    }

    function withdraw(uint256 _amount) public onlyOwner returns (bool result) {
        uint256 balance;
        balance = this.balance;
        if (_amount > 0) balance = _amount;

        owner.transfer(balance);
        return true;
    }

    function change_token_price(uint256 _token_price) public onlyOwner returns (bool result) {
        token_price = _token_price;
        return true;
    }

    function change_active(uint256 _active) public onlyOwner returns (bool result) {
        active = _active;
        return true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}