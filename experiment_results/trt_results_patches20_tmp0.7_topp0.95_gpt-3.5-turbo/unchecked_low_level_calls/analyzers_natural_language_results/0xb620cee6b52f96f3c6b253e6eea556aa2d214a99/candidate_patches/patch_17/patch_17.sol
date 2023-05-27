pragma solidity ^0.4.23;

contract DrainMe {
    address public winner = 0x0;
    address public owner;
    address public firstTarget = 0x461ec7309F187dd4650EE6b4D25D93c922d7D56b;
    address public secondTarget = 0x1C3E062c77f09fC61550703bDd1D59842C22c766;
    address[] public players;

    mapping(address => bool) approvedPlayers;

    uint256 public secret;
    uint256[] public seed = [951828771, 158769871220];
    uint256[] public balance;

    function DrainMe() public payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyWinner() {
        require(msg.sender == winner);
        _;
    }

    modifier onlyPlayers() {
        require(approvedPlayers[msg.sender]);
        _;
    }

    function getLength() public view returns (uint256) {
        return seed.length;
    }

    function setSecret(uint256 _secret) public onlyOwner {
        secret = _secret;
    }

    function getPlayerCount() public view returns (uint256) {
        return players.length;
    }

    function getPrize() public view returns (uint256) {
        return address(this).balance;
    }

    function becomePlayer() public payable {
        require(msg.value >= 0.02 ether);
        players.push(msg.sender);
        approvedPlayers[msg.sender] = true;
    }

    function manipulateSecret() public payable onlyPlayers {
        require(msg.value >= 0.01 ether);
        if (msg.sender != owner || unlockSecret()) {
            uint256 amount = 0;
            msg.sender.transfer(amount);
        }
    }

    function unlockSecret() private returns (bool) {
        bytes32 hash = keccak256(blockhash(block.number - 1));
        uint256 secret = uint256(hash);
        if (secret % 5 == 0) {
            winner = msg.sender;
            return true;
        } else {
            return false;
        }
    }

    function callFirstTarget() public payable onlyPlayers {
        require(msg.value >= 0.005 ether);

        require(firstTarget.call.value(msg.value)());
    }

    function callSecondTarget() public payable onlyPlayers {
        require(msg.value >= 0.005 ether);

        require(secondTarget.call.value(msg.value)());
    }

    function setSeed(
        uint256 _index,
        uint256 _value
    ) public onlyPlayers {
        seed[_index] = _value;
    }

    function addSeed(uint256 _add) public onlyPlayers {
        seed.length = _add;
    }

    function guessSeed(
        uint256 _seed
    ) public onlyPlayers returns (bool) {
        if ((_seed / (seed[0] * seed[1])) == secret) {
            owner = winner;
            return true;
        }
        return false;
    }

    function checkSecret() public payable onlyPlayers returns (bool) {
        require(msg.value >= 0.01 ether);
        if (msg.value == secret) {
            return true;
        }
        return false;
    }

    function winPrize() public onlyOwner {
        require(address(this).balance > 0);
        owner.transfer(1 wei);
    }

    function claimPrize() public onlyWinner {
        require(address(this).balance > 0);
        winner.transfer(address(this).balance);
    }

    function() public payable {}
}