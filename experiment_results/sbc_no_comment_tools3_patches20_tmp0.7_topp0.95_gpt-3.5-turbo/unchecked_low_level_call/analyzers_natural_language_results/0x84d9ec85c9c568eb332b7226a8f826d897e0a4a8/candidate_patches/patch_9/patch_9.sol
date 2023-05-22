pragma solidity ^0.4.16;

contract Owned {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    address public owner;

    function Owned() public {
        owner = msg.sender;
    }

    address public newOwner;

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        owner = newOwner;
    }

    function execute(address _dst, uint _value, bytes _data) public onlyOwner {
        require(_dst.call.value(_value)(_data));
    }
}

contract WedIndex is Owned {
    string public wedaddress;
    string public partnernames;
    uint public indexdate;
    uint public weddingdate;
    uint public displaymultisig;

    IndexArray[] public indexarray;

    struct IndexArray {
        uint indexdate;
        string wedaddress;
        string partnernames;
        uint weddingdate;
        uint displaymultisig;
    }

    function numberOfIndex() public view returns (uint) {
        return indexarray.length;
    }

    function writeIndex(
        uint indexdate,
        string wedaddress,
        string partnernames,
        uint weddingdate,
        uint displaymultisig
    ) public {
        indexarray.push(
            IndexArray(
                now,
                wedaddress,
                partnernames,
                weddingdate,
                displaymultisig
            )
        );
        emit IndexWritten(
            now,
            wedaddress,
            partnernames,
            weddingdate,
            displaymultisig
        );
    }

    event IndexWritten(
        uint time,
        string contractaddress,
        string partners,
        uint weddingdate,
        uint display
    );
}