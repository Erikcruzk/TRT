pragma solidity >=0.4.11;

contract Owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid new owner address.");
        owner = _newOwner;
    }

    function execute(address _dst, uint _value, bytes memory _data) public onlyOwner {
        (bool success, ) = _dst.call.value(_value)(_data);
        require(success, "Low-level call failed.");
    }
}

interface Token {
    function transfer(address, uint) external returns (bool);
    function balanceOf(address) external view returns (uint);
}

contract TokenSender is Owned {
    Token public token;
    uint public totalToDistribute;
    uint public next;
    Transfer[] public transfers;

    struct Transfer {
        address addr;
        uint amount;
    }

    uint constant D160 = 0x0010000000000000000000000000000000000000000;

    constructor(address _token) public {
        token = Token(_token);
    }

    function fill(uint[] memory data) public onlyOwner {
        require(next == 0, "Transfers have already been filled.");
        uint acc;
        uint offset = transfers.length;
        transfers.length += data.length;
        for (uint i = 0; i < data.length; i++) {
            address addr = address(data[i] & (D160 - 1));
            uint amount = data[i] / D160;
            transfers[offset + i] = Transfer(addr, amount);
            acc += amount;
        }
        totalToDistribute += acc;
    }

    function run() public onlyOwner {
        require(transfers.length > 0, "No transfers to run.");
        uint mNext = next;
        next = transfers.length;
        if ((mNext == 0) && (token.balanceOf(address(this)) != totalToDistribute)) {
            revert("Token balance not equal to total to distribute.");
        }
        while ((mNext < transfers.length) && (gasleft() > 150000)) {
            uint amount = transfers[mNext].amount;
            address addr = transfers[mNext].addr;
            if (amount > 0) {
                require(token.transfer(addr, amount), "Transfer failed.");
            }
            mNext++;
        }
        next = mNext;
    }

    function hasTerminated() public view returns (bool) {
        return (transfers.length > 0 && next == transfers.length);
    }

    function nTransfers() public view returns (uint) {
        return transfers.length;
    }

    function gasleft() internal view returns (uint _gas) {
        assembly {
            _gas := gas()
        }
    }
}