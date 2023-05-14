pragma solidity ^0.8.0;

contract DrainMe {
    address payable public winner = payable(address(0));
    address public owner;
    address public firstTarget = 0x461ec7309F187dd4650EE6b4D25D93c922d7D56b;
    address public secondTarget = 0x1C3E062c77f09fC61550703bDd1D59842C22c766;
    address[] public players;

    mapping(address => bool) approvedPlayers;

    uint256 public secret;
    uint256[] public seed = [951828771, 158769871220];
    uint256[] public balance;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier onlyWinner() {
        require(msg.sender == winner, "Only winner can call this function.");
        _;
    }

    modifier onlyPlayers() {
        require(approvedPlayers[msg.sender], "Only approved players can call this function.");
        _;
    }

    function getLength() public view returns (uint256) {
        return seed.length;
    }

    function setSecret(uint256 _secret) public payable onlyOwner {
        secret = _secret;
    }

    function getPlayerCount() public view returns (uint256) {
        return players.length;
    }

    function getPrize() public view returns (uint256) {
        return address(this).balance;
    }

    function becomePlayer() public payable {
        require(msg.value >= 0.02 ether, "Minimum value to become a player is 0.02 ether.");
        players.push(msg.sender);
        approvedPlayers[msg.sender] = true;
    }

    function manipulateSecret() public payable onlyPlayers {
        require(msg.value >= 0.01 ether, "Minimum value to manipulate secret is 0.01 ether.");
        if (msg.sender != owner || unlockSecret()) {
            uint256 amount = 0;
            payable(msg.sender).transfer(amount);
        }
    }

    function unlockSecret() private returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(blockhash(block.number - 1)));
        uint256 secret = uint256(hash);
        if (secret % 5 == 0) {
            winner = payable(msg.sender);
            return true;
        } else {
            return false;
        }
    }

    function callFirstTarget() public payable onlyPlayers {
        require(msg.value >= 0.005 ether, "Minimum value to call first target is 0.005 ether.");

        (bool success, ) = firstTarget.call{value: msg.value}("");
        require(success, "Call to first target failed.");
    }

    function callSecondTarget() public payable onlyPlayers {
        require(msg.value >= 0.005 ether, "Minimum value to call second target is 0.005 ether.");

        (bool success, ) = secondTarget.call{value: msg.value}("");
        require(success, "Call to second target failed.");
    }

    function setSeed(
        uint256 _index,
        uint256 _value
    ) public payable onlyPlayers {
        seed[_index] = _value;
    }

    function addSeed(uint256 _add) public payable onlyPlayers {
        seed.push(_add);
    }

    function guessSeed(
        uint256 _seed
    ) public payable onlyPlayers {
        require((_seed / (seed[0] * seed[1])) == secret, "Seed guess is incorrect.");
        owner = winner;
    }

    function checkSecret() public payable onlyPlayers {
        require(msg.value >= 0.01 ether, "Minimum value to check secret is 0.01 ether.");
        if (msg.value == secret) {
            winner = payable(msg.sender);
        }
    }

    function winPrize() public onlyOwner {
        require(address(this).balance > 0, "There is no prize to win.");
        (bool success, ) = owner.call{value: 1 wei}("");
        require(success, "Call to owner failed.");
    }

    function claimPrize() public onlyWinner {
        require(address(this).balance > 0, "There is no prize to claim.");
        (bool success, ) = winner.call{value: address(this).balance}("");
        require(success, "Call to winner failed.");
    }

    receive() external payable {}
}