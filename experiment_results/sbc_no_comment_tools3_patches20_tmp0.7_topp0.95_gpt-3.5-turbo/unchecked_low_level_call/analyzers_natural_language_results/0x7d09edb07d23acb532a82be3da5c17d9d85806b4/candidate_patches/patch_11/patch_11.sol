pragma solidity ^0.8.0;

contract PoCGame {
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier isOpenToPublic() {
        require(openToPublic, "Contract is not open to public yet");
        _;
    }

    modifier onlyRealPeople() {
        require(msg.sender == tx.origin, "Only externally owned accounts allowed");
        _;
    }

    modifier onlyPlayers() {
        require(wagers[msg.sender] > 0, "Player has not placed any wagers yet");
        _;
    }

    event Wager(uint256 amount, address depositer);
    event Win(uint256 amount, address paidTo);
    event Lose(uint256 amount, address loser);
    event Donate(uint256 amount, address paidTo, address donator);
    event DifficultyChanged(uint256 currentDifficulty);
    event BetLimitChanged(uint256 currentBetLimit);

    address private whale;
    uint256 betLimit;
    uint256 difficulty;
    uint256 private randomSeed;
    address owner;
    mapping(address => uint256) timestamps;
    mapping(address => uint256) wagers;
    bool openToPublic;
    uint256 totalDonated;

    constructor(address _whaleAddress, uint256 _wagerLimit) {
        require(tx.origin == msg.sender, "Only externally owned accounts allowed to deploy this contract");
        openToPublic = false;
        owner = tx.origin;
        whale = _whaleAddress;
        totalDonated = 0;
        betLimit = _wagerLimit;
    }

    function openToThePublic() public onlyOwner {
        openToPublic = true;
    }

    function adjustBetAmounts(uint256 amount) public onlyOwner {
        betLimit = amount;

        emit BetLimitChanged(betLimit);
    }

    function adjustDifficulty(uint256 amount) public onlyOwner {
        difficulty = amount;

        emit DifficultyChanged(difficulty);
    }

    function() external payable {}

    function wager() public payable isOpenToPublic onlyRealPeople {
        require(msg.value == betLimit, "Wager amount should be equal to bet limit");

        timestamps[msg.sender] = block.number;
        wagers[msg.sender] = msg.value;
        emit Wager(msg.value, msg.sender);
    }

    function play() public isOpenToPublic onlyRealPeople onlyPlayers {
        uint256 blockNumber = timestamps[msg.sender];
        require(blockNumber < block.number, "Cannot play before placing a wager");

        timestamps[msg.sender] = 0;
        wagers[msg.sender] = 0;

        uint256 winningNumber = (uint256(keccak256(abi.encodePacked(blockhash(blockNumber), msg.sender, randomSeed))) % difficulty) + 1;
        randomSeed = winningNumber;

        if (winningNumber == difficulty / 2) {
            payout(msg.sender);
        } else {
            loseWager(betLimit / 2);
        }
    }

    function donate() public payable isOpenToPublic {
        require(msg.value > 0, "Donation amount should be greater than zero");
        donateToWhale(msg.value);
    }

    function payout(address winner) internal {
        uint256 ethToTransfer = address(this).balance / 2;

        (bool success,) = winner.call{value: ethToTransfer}("");
        require(success, "Failed to send ether to winner");

        emit Win(ethToTransfer, winner);
    }

    function donateToWhale(uint256 amount) internal {
        (bool success,) = whale.call{value: amount}(abi.encodeWithSignature("donate()"));
        require(success, "Failed to send ether to whale");
        totalDonated += amount;
        emit Donate(amount, whale, msg.sender);
    }

    function loseWager(uint256 amount) internal {
        (bool success,) = whale.call{value: amount}(abi.encodeWithSignature("donate()"));
        require(success, "Failed to send ether to whale");
        totalDonated += amount;
        emit Lose(amount, msg.sender);
    }

    function ethBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function currentDifficulty() public view returns (uint256) {
        return difficulty;
    }

    function currentBetLimit() public view returns (uint256) {
        return betLimit;
    }

    function hasPlayerWagered(address player) public view returns (bool) {
        return wagers[player] > 0;
    }

    function winnersPot() public view returns (uint256) {
        return address(this).balance / 2;
    }

    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint256 tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
    }
}

interface ERC20Interface {
    function transfer(address to, uint256 tokens) external returns (bool success);
}