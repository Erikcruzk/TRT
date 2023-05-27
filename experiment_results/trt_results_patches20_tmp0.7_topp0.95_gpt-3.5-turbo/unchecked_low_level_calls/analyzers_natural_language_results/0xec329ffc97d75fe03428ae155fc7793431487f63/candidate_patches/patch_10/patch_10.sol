pragma solidity >=0.4.11;

contract Owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this operation");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function execute(address _dst, uint _value, bytes memory _data) public onlyOwner {
        (bool success, ) = _dst.call.value(_value)(_data);
        require(success, "Execution failed");
    }
}

contract Token {
    function transfer(address, uint) public returns (bool);

    function balanceOf(address) public view returns (uint);
}

contract TokenSender is Owned {
    Token public token;
    uint public totalToDistribute;

    uint public next;

    struct Transfer {
        address addr;
        uint amount;
    }

    Transfer[] public transfers;

    constructor(address _token) public {
        token = Token(_token);
    }

    uint constant D160 = 0x0010000000000000000000000000000000000000000;

    function fill(uint[] memory data) public onlyOwner {
        require(next == 0, "Already filled");
        uint acc;
        uint offset = transfers.length;
        transfers.length = transfers.length + data.length;
        for (uint i = 0; i < data.length; i++) {
            address addr = address(data[i] & (D160 - 1));
            uint amount = data[i] / D160;

            transfers[offset + i].addr = addr;
            transfers[offset + i].amount = amount;
            acc += amount;
        }
        totalToDistribute += acc;
    }

    function run() public onlyOwner {
        if (transfers.length == 0) return;

        uint mNext = next;

        next = transfers.length;

        if ((mNext == 0) && (token.balanceOf(address(this)) != totalToDistribute)) {
            revert("Insufficient balance");
        }

        while ((mNext < transfers.length) && (gasleft() > 150000)) {
            uint amount = transfers[mNext].amount;
            address addr = transfers[mNext].addr;
            if (amount > 0) {
                require(token.transfer(addr, transfers[mNext].amount), "Transfer failed");
            }
            mNext++;
        }

        next = mNext;
    }

    function hasTerminated() public view returns (bool) {
        if (transfers.length == 0) return false;
        if (next < transfers.length) return false;
        return true;
    }

    function nTransfers() public view returns (uint) {
        return transfers.length;
    }
}