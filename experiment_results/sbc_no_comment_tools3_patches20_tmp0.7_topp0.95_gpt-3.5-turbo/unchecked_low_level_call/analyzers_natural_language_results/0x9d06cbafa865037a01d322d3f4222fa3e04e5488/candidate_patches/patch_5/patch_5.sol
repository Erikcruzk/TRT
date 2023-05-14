pragma solidity ^0.8.0;

contract Delta {
    address public c = 0xF85A2E95FA30d005F629cBe6c6d2887D979ffF2A;
    address public owner = 0x788c45dd60ae4dbe5055b5ac02384d5dc84677b0;
    address public owner2 = 0x0C6561edad2017c01579Fd346a58197ea01A0Cf3;
    uint public active = 1;

    uint public token_price = (10 ** 18 * 1) / 1000;

    function buyTokens() payable public returns (bool) {
        require(active > 0, "Contract is not active");
        require(msg.value >= token_price, "Value is less than token price");

        uint tokens_buy = (msg.value * 10 ** 18) / token_price;

        require(tokens_buy > 0, "Tokens to buy should be greater than zero");

        (bool success, ) = c.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", owner, msg.sender, tokens_buy));
        require(success, "Transfer failed");

        uint sum2 = (msg.value * 3) / 10;

        payable(owner2).transfer(sum2);

        return true;
    }

    function withdraw(uint256 _amount) public onlyOwner returns (bool result) {
        uint256 balance = address(this).balance;
        if (_amount > 0) {
            require(_amount <= balance, "Amount is greater than balance");
            balance = _amount;
        }

        payable(owner).transfer(balance);
        return true;
    }

    function changeTokenPrice(uint256 _token_price) public onlyOwner returns (bool result) {
        token_price = _token_price;
        return true;
    }

    function changeActive(uint256 _active) public onlyOwner returns (bool result) {
        active = _active;
        return true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }
}