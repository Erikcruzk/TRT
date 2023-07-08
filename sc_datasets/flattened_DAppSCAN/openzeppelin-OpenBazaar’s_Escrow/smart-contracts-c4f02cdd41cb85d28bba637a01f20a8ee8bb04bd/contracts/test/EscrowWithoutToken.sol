// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-OpenBazaar’s_Escrow/smart-contracts-c4f02cdd41cb85d28bba637a01f20a8ee8bb04bd/contracts/test/EscrowWithoutToken.sol

pragma solidity 0.4.24;

/** 
* @dev The escrow smart contract for the open bazaar trades in Ethereum
* The smart contract is desgined keeping in mind the current wallet interface of the OB-core
* https://github.com/OpenBazaar/wallet-interface/blob/master/wallet.go
* Current wallet interface strictly adheres to UTXO(bitcoin) model
*/
contract EscrowWithoutToken{
    
    using SafeMath for uint256;
    
    enum Status {FUNDED, RELEASED}
                       
    event Executed(bytes32 scriptHash, address[] destinations, uint256[] amounts);
    
    event FundAdded(bytes32 scriptHash, address indexed from, uint256 valueAdded);

    event Funded(bytes32 scriptHash, address indexed from, uint256 value);

    struct Transaction {
        bytes32 scriptHash;//This is unique indentifier for a transaction
        address buyer;
        address seller;
        address[] moderators;
        uint256 value;
        Status status;
        string ipfsHash;
        uint256 lastFunded;//Time at which transaction was last funded
        uint32 timeoutHours;
        uint8 threshold;
        mapping(address=>bool) isOwner;//to keep track of owners/signers. 
        mapping(address=>bool) voted;//to keep track of who all voted       
    }

    mapping(bytes32 => Transaction) public transactions;
 
    uint256 public transactionCount = 0;

    mapping(address => bytes32[])public partyVsTransaction;//Contains mapping between each party and all of his transactions

 
    modifier transactionExists(bytes32 scriptHash) {
        require(transactions[scriptHash].value != 0, "Transaction does not exists");
        _;
    }

    modifier transactionDoesNotExists (bytes32 scriptHash) {
        require(transactions[scriptHash].value == 0, "Transaction exists");
        _;
    }
 
    modifier inFundedState(bytes32 scriptHash) {
        require(transactions[scriptHash].status == Status.FUNDED, "Transaction is either in dispute or released state");
        _;
    }

    modifier nonZeroAddress(address _address) {
        require(_address != address(0), "Zero address passed");
        _;
    }
    
    /** 
    *@dev Add new transaction in the contract
    *@param _buyer The buyer of the transaction
    *@param _seller The seller of the listing associated with the transaction
    *@param _moderators List of moderators for this transaction. For now only single moderator
    *@param scriptHash keccak256 hash of the redeem script
    *@param threshold Minimum number of singatures required to released funds
    *@param timeoutHours Hours after which seller can release funds into his favour by signing transaction
    *Redeem Script format will be following
    <uniqueId: 20><threshold:1><timeoutHours:4><buyer:20><seller:20><moderator:20>
    * scripthash-> keccak256(uniqueId, threshold, timeoutHours, buyer, seller, moderator)
    *Pass amount of the ethers to be put in escrow
    *Please keep in mind you will have to add moderators fees also in the value
    */
    function addTransaction(address _buyer, address _seller, address[] _moderators, uint8 threshold, uint32 timeoutHours, bytes32 scriptHash)
    public payable transactionDoesNotExists(scriptHash) nonZeroAddress(_buyer) nonZeroAddress(_seller){
        
       
        uint256 _value = msg.value;

        require(_buyer != _seller, "Buyer and seller are same");

        //value passed should be greater than 0
        require(_value>0, "Value passed is 0");
        
        // For now allowing 0 moderators to support 1-2 multisig wallet
        //require(_moderators.length>0,"There should be atleast 1 moderator");//TODO- What to do in case of 1-2 multi sig transaction

        require(threshold <= _moderators.length + 2, "Threshold is greater than total owners");

    
        transactions[scriptHash] = Transaction({
                
            buyer: _buyer,
        
            seller: _seller,
        
            moderators: _moderators,
        
            value: _value,
        
            status: Status.FUNDED,
                
            ipfsHash: "",

            lastFunded: block.timestamp,

            scriptHash: scriptHash,

            threshold: threshold,

            timeoutHours: timeoutHours

                        
        });

        transactions[scriptHash].isOwner[_seller] = true;
        transactions[scriptHash].isOwner[_buyer] = true;

        
        //check if moderator is verified moderator or not
        for(uint8 i=0;i<_moderators.length; i++){
            
            require(_moderators[i] != address(0), "Zero address passed");
            require(!transactions[scriptHash].isOwner[_moderators[i]], "Moderator is beign repeated");//Check if same moderator is not passed twice in the list
           
            transactions[scriptHash].isOwner[_moderators[i]] = true;
        }    
        transactionCount++;

        partyVsTransaction[_buyer].push(scriptHash);
        partyVsTransaction[_seller].push(scriptHash);

        emit Funded(scriptHash, msg.sender, _value);
    }
    
    /** 
    *@dev Allows buyer of the transaction to add more funds in the transaction. This will help to cater scenarios wherein initially buyer missed to fund transaction as required
    *@param scriptHash script hash of the transaction
    */
    function addFundsToTransaction(bytes32 scriptHash)public transactionExists(scriptHash) inFundedState(scriptHash) payable{
         
        uint256 _value = msg.value;
    
        require(_value > 0);

        transactions[scriptHash].value = transactions[scriptHash].value.add(_value);
        transactions[scriptHash].lastFunded = block.timestamp;


        emit FundAdded(scriptHash, msg.sender, _value);


    }
 
    /**
    *@dev Allows one of the moderator to collect all the signature to solve dispute and submit it to this method.
    * If all the required signatures are collected and consensus has been reached than funds will be released to the voted party
    *@param sigV Array containing V component of all the signatures(signed by each moderator)
    *@param sigR Array containing R component of all the signatures(signed by each moderator)
    *@param signS Array containing S component of all the signature(signed by each moderator)
    *@param scriptHash script hash of the transaction
    *@param uniqueId bytes20 unique id for the transaction, generated by ETH wallet
    *@param destinations address of the destination in whose favour dispute resolution is taking place. In case of split payments it will be address of the split payments contract
    *@param amounts value to send to each destination
    */  
    function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, bytes32 scriptHash, bytes20 uniqueId, address[] destinations, uint256[] amounts) public  transactionExists(scriptHash) inFundedState(scriptHash){

        require(destinations.length>0 && destinations.length == amounts.length);

        Transaction storage t = transactions[scriptHash];

        bytes32 calculatedScriptHash = keccak256(abi.encodePacked(uniqueId, t.threshold, t.timeoutHours, t.buyer, t.seller, t.moderators[0]));

        require(scriptHash == calculatedScriptHash, "Calculated script hash does not match passed script hash");

        address lastRecovered = verifySignatures(sigV, sigR, sigS, scriptHash, destinations, amounts);

        bool timeLockExpired = isTimeLockExpired(t.timeoutHours, t.lastFunded);

        //assumin threshold will always be greater than 1, else its not multisig
        if(sigV.length < t.threshold && !timeLockExpired){
            revert();
        }else if(sigV.length == 1 && timeLockExpired && lastRecovered != t.seller){
            revert();
        }else if(sigV.length < t.threshold){
            revert();
        }
           
        transactions[scriptHash].status = Status.RELEASED;

        uint256 totalValue = 0;

        for(uint8 i = 0; i<destinations.length; i++) {

            require(destinations[i] != address(0) && transactions[scriptHash].isOwner[destinations[i]], "Not a valid destination");
            require(amounts[i] > 0, "Amount to be sent should be greater than 0");

            totalValue = totalValue.add(amounts[i]);

            destinations[i].transfer(amounts[i]);
        }
        require(totalValue <= transactions[scriptHash].value, "Total value to be sent is greater than the transaction value");

        emit Executed(scriptHash, destinations, amounts);
            
       
    }
    
    //to check whether the signature are valid or not and if consensus was reached
    //returns the last address recovered, in case of timeout this must be the sender's address
    function verifySignatures(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, bytes32 scriptHash, address[] destinations, uint256[]amounts)
      private returns (address lastAddress){

        require(sigR.length == sigS.length && sigR.length == sigV.length);

        // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
        bytes32 txHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(byte(0x19), byte(0), this, destinations, amounts, scriptHash))));
        
        for (uint i = 0; i < sigR.length; i++) {

            address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);

            require(transactions[scriptHash].isOwner[recovered], "Invalid signature");
            require(!transactions[scriptHash].voted[recovered], "Same signature sent twice");
            transactions[scriptHash].voted[recovered] = true;
            lastAddress = recovered;
        
        }

    }

    /** 
    *@dev Returns all transaction ids for a party
    *@param _partyAddress Address of the party
    */
    function getAllTransactionsForParty(address _partyAddress)public view returns(bytes32[] scriptHashes) {

        return partyVsTransaction[_partyAddress];
    }


    function isTimeLockExpired(uint32 timeoutHours, uint256 lastFunded)internal view returns(bool expired){
        uint256 timeSince = now.sub(lastFunded);

        expired = timeoutHours == 0?false:timeSince > uint256(timeoutHours).mul(3600);
    }
}
