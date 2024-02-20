

pragma solidity ^0.4.24;














library AutoIncrementing {

  struct Counter {
    uint256 prevId; 
  }

  function nextId(Counter storage _counter)
    internal
    returns (uint256)
  {
    _counter.prevId = _counter.prevId + 1;
    return _counter.prevId;
  }
}