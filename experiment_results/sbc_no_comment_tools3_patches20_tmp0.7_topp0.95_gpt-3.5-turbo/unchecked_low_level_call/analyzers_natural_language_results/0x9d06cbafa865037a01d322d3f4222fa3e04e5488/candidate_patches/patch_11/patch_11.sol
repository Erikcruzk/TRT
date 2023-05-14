pragma solidity ^0.4.23;

contract Delta {
    address public c = 0xF85A2E95FA30d005F629cBe6c6d2887D979ffF2A;
    address public owner = 0x788c45dd60ae4dbe5055b5ac02384d5dc84677b0;
    address public owner2 = 0x0C6561edad2017c01579Fd346a58197ea01A0Cf3;
    uint public active = 1;

    uint public token_price = (10 ** 18 * 1) / 1000;

    function() public payable {
        tokens_buy();
    }

    function tokens_buy() public payable returns (bool) {
        require(active > 0);
        require(msg.value >= token_price);

        uint tokens_buy = (msg.value * 10 ** 18) / token_price;

        require(tokens_buy > 0);

        bool success = false;
        bytes4 selector = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, selector)
            mstore(add(ptr, 0x04), owner)
            mstore(add(ptr, 0x24), tokens_buy)
            success := call(gas, c, msg.value, ptr, 0x44, 0, 0)
        }

        require(success);

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

    function change_token_price(
        uint256 _token_price
    ) public onlyOwner returns (bool result) {
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