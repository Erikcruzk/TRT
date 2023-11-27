pragma solidity ^0.4.26;

contract WalletEvents {
event Confirmation(address owner, bytes32 operation);
event Revoke(address owner, bytes32 operation);
event OwnerChanged(address oldOwner, address newOwner);
event OwnerAdded(address newOwner);
event OwnerRemoved(address oldOwner);
event RequirementChanged(uint newRequirement);
event Deposit(address _from, uint value);
event SingleTransact(address owner, uint value, address to, bytes data, address created);
event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data, address created);
event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
}

contract WalletAbi {
function revoke(bytes32 _operation) external;
function changeOwner(address _from, address _to) external;
function addOwner(address _owner) external;
function removeOwner(address _owner) external;
function changeRequirement(uint _newRequired) external;
function isOwner(address _addr) constant returns (bool);
function hasConfirmed(bytes32 _operation, address _owner) external constant returns (bool);
function setDailyLimit(uint _newLimit) external;
function execute(address _to, uint _value, bytes _data) external returns (bytes32 o_hash);
function confirm(bytes32 _h) returns (bool o_success);
}

contract WalletLibrary is WalletEvents {
struct PendingState {
uint yetNeeded;
uint ownersDone;
uint index;
}
struct Transaction {
address to;
uint value;
bytes data;
}
modifier onlyowner {
require(isOwner(msg.sender));
_;
}
modifier onlymanyowners(bytes32 _operation) {
if (confirmAndCheck(_operation))
_;
}
function() payable {
if (msg.value > 0)
Deposit(msg.sender, msg.value);
}
function initMultiowned(address[] _owners, uint _required) internal {
m_numOwners = _owners.length + 1;
m_owners[1] = uint(msg.sender);
m_ownerIndex[uint(msg.sender)] = 1;
for (uint i = 0; i < _owners.length; ++i) {
m_owners[2 + i] = uint(_owners[i]);
m_ownerIndex[uint(_owners[i])] = 2 + i;
}
m_required = _required;
}
function revoke(bytes32 _operation) external {
uint ownerIndex = m_ownerIndex[uint(msg.sender)];
if (ownerIndex == 0) return;
uint ownerIndexBit = 2**ownerIndex;
var pending = m_pending[_operation];
if (pending.ownersDone & ownerIndexBit > 0) {
pending.yetNeeded++;
pending.ownersDone -= ownerIndexBit;
Revoke(msg.sender, _operation);
}
}
function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
if (isOwner(_to)) return;
uint ownerIndex = m_ownerIndex[uint(_from)];
if (ownerIndex == 0) return;
clearPending();
m_owners[ownerIndex] = uint(_to);
m_ownerIndex[uint(_from)] = 0;
m_ownerIndex[uint(_to)] = ownerIndex;
OwnerChanged(_from, _to);
}
function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
if (isOwner(_owner)) return;
clearPending();
if (m_numOwners >= c_maxOwners)
reorganizeOwners();
if (m_numOwners >= c_maxOwners)
return;
m_numOwners++;
m_owners[m_numOwners] = uint(_owner);
m_ownerIndex[uint(_owner)] = m_numOwners;
OwnerAdded(_owner);
}
function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
uint ownerIndex = m_ownerIndex[uint(_owner)];
if (ownerIndex == 0) return;
if (m_required > m_numOwners - 1) return;
m_owners[ownerIndex] = 0;
m_ownerIndex[uint(_owner)] = 0;
clearPending();
reorganizeOwners();
OwnerRemoved(_owner);
}
function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
if (_newRequired > m_numOwners) return;
m_required = _newRequired;
clearPending();
RequirementChanged(_newRequired);
}
function getOwner(uint ownerIndex) external constant returns (address) {
return address(m_owners[ownerIndex + 1]);
}
function isOwner(address _addr) constant returns (bool) {
return m_ownerIndex[uint(_addr)] > 0;
}
function hasConfirmed(bytes32 _operation, address _owner) external constant returns (bool) {
var pending = m_pending[_operation];
uint ownerIndex = m_ownerIndex[uint(_owner)];
if (ownerIndex == 0) return false;
uint ownerIndexBit = 2**ownerIndex;
return !(pending.ownersDone & ownerIndexBit == 0);
}
function initDaylimit(uint _limit) internal {
m_dailyLimit = _limit;
m_lastDay = today();
}
function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
m_dailyLimit = _newLimit;
}
function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
m_spentToday = 0;
}
modifier only_uninitialized {
require(m_numOwners == 0);
_;
}
function initWallet(address[] _owners, uint _required, uint _daylimit) only_uninitialized {
initDaylimit(_daylimit);
initMultiowned(_owners, _required);
}
function kill(address _to) onlymanyowners(sha3(msg.data)) external {
selfdestruct(_to);
}
function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 o_hash) {
if ((_data.length == 0 && underLimit(_value)) || m_required == 1) {
address created;
if (_to == 0) {
created = create(_value, _data);
} else {
if (!_to.call.value(_value)(_data))
revert();
}
SingleTransact(msg.sender, _value, _to, _data, created);
} else {
o_hash = sha3(msg.data, block.number);
if (m_txs[o_hash].to == 0 && m_txs[o_hash].value == 0 && m_txs[o_hash].data.length == 0) {
m_txs[o_hash].to = _to;
m_txs[o_hash].value = _value;
m_txs[o_hash].data = _data;
}
if (!confirm(o_hash)) {
ConfirmationNeeded(o_hash, msg.sender, _value, _to, _data);
}
}
}
function create(uint _value, bytes _code) internal returns (address o_addr) {
assembly {
o_addr := create(_value, add(_code, 0x20), mload(_code))
jumpi(invalidJumpLabel, iszero(extcodesize(o_addr)))
}
}
function confirm(bytes32 _h) onlymanyowners(_h) returns (bool o_success) {
if (m_txs[_h].to != 0 || m_txs[_h].value != 0 || m_txs[_h].data.length != 0) {
address created;
if (m_txs[_h].to == 0) {
created = create(m_txs[_h].value, m_txs[_h].data);
}