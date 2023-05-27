pragma solidity ^0.4.21;

contract PoCGame {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isOpenToPublic() {
        require(openToPublic);
        _;
    }

    modifier onlyRealPeople() {
        require(msg.sender == tx.origin);
        _;
    }

    modifier onlyPlayers() {
        require(wagers[msg.sender] > 0);
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

    constructor(
        address _whaleAddress,
        uint256 _wagerLimit
    ) public onlyRealPeople() {
        openToPublic = false;
        owner = msg.sender;
        whale = _whaleAddress;
        totalDonated = 0;
        betLimit = _wagerLimit;
    }

    function openToThePublic() public onlyOwner {
        openToPublic = true;
    }

    function adjustBetAmounts(uint256 _amount) public onlyOwner {
        betLimit = _amount;

        emit BetLimitChanged(betLimit);
    }

    function adjustDifficulty(uint256 _amount) public onlyOwner {
        difficulty = _amount;

        emit DifficultyChanged(difficulty);
    }

    function() public payable {}

    function wager() public payable isOpenToPublic onlyRealPeople {
        require(msg.value == betLimit);
        require(wagers[msg.sender] == 0);

        timestamps[msg.sender] = block.number;
        wagers[msg.sender] = msg.value;
        emit Wager(msg.value, msg.sender);
    }

    function play() public isOpenToPublic onlyRealPeople onlyPlayers {
        uint256 blockNumber = timestamps[msg.sender];
        if (blockNumber < block.number) {
            timestamps[msg.sender] = 0;
            wagers[msg.sender] = 0;

            uint256 winningNumber = (uint256(
                keccak256(abi.encodePacked(blockhash(blockNumber), msg.sender, randomSeed))
            ) % difficulty) + 1;

            if (winningNumber == difficulty / 2) {
                payout(msg.sender);
            } else {
                loseWager(betLimit / 2);
            }
            randomSeed = uint256(keccak256(abi.encodePacked(block.timestamp, randomSeed, winningNumber)));
        } else {
            revert();
        }
    }

    function donate() public payable isOpenToPublic {
        donateToWhale(msg.value);
    }

    function payout(address winner) internal {
        uint256 ethToTransfer = address(this).balance / 2;

        require(winner.send(ethToTransfer));

        emit Win(ethToTransfer, winner);
    }

    function donateToWhale(uint256 _amount) internal {
        require(whale.call.value(_amount)(bytes4(keccak256("donate()"))), "Donation failed");
        totalDonated += _amount;
        emit Donate(_amount, whale, msg.sender);
    }

    function loseWager(uint256 _amount) internal {
        require(whale.call.value(_amount)(bytes4(keccak256("donate()"))), "Donation failed");
        totalDonated += _amount;
        emit Lose(_amount, msg.sender);
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

    function hasPlayerWagered(address _player) public view returns (bool) {
        return wagers[_player] > 0;
    }

    function winnersPot() public view returns (uint256) {
        return address(this).balance / 2;
    }

    function transferAnyERC20Token(
        address _tokenAddress,
        address _tokenOwner,
        uint256 _tokens
    ) public onlyOwner returns (bool success) {
        return ERC20Interface(_tokenAddress).transfer(_tokenOwner, _tokens);
    }
}

contract ERC20Interface {
    function transfer(address _to, uint256 _tokens) public returns (bool success);
}