

pragma solidity ^0.4.18;




























library Array128Lib {

  
  
  
  function sumElements(uint128[] storage self) public view returns(uint256 sum) {
    uint256 term;
    uint8 remainder;

    assembly {
      mstore(0x60,self_slot)

      for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
        term := sload(add(sha3(0x60,0x20),div(i,2)))

        remainder := mod(i,2)

        for { let j := 0 } lt(j, mul(remainder, 4)) { j := add(j, 1) } {
          term := div(term,4294967296)
        }

        term := and(0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff,term)
        sum := add(term,sum)

      }
    }
  }

  
  
  
  function getMax(uint128[] storage self) public view returns(uint128 maxValue) {
    uint256 term;
    uint8 remainder;

    assembly {
      mstore(0x60,self_slot)
      maxValue := 0

      for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
        term := sload(add(sha3(0x60,0x20),div(i,2)))

        remainder := mod(i,2)

        for { let j := 0 } lt(j, mul(remainder, 4)) { j := add(j, 1) } {
          term := div(term,4294967296)
        }

        term := and(0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff,term)
        switch lt(maxValue, term)
        case 1 {
          maxValue := term
        }
      }
    }
  }

  
  
  
  function getMin(uint128[] storage self) public view returns(uint128 minValue) {
    uint256 term;
    uint8 remainder;

    assembly {
      mstore(0x60,self_slot)

      for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
        term := sload(add(sha3(0x60,0x20),div(i,2)))

        remainder := mod(i,2)

        for { let j := 0 } lt(j, mul(remainder, 4)) { j := add(j, 1) } {
          term := div(term,4294967296)
        }

        term := and(0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff,term)
        switch eq(i,0)
        case 1 {
          minValue := term
        }
        switch gt(minValue, term)
        case 1 {
          minValue := term
        }
      }
    }
  }

  
  
  
  
  
  
  function indexOf(uint128[] storage self, uint128 value, bool isSorted)
           public
           view
           returns(bool found, uint256 index) {
    uint256 term;
    assembly{
      mstore(0x60,self_slot)
      switch isSorted
      case 1 {
        let high := sub(sload(self_slot),1)
        let mid := 0
        let low := 0
        for { } iszero(gt(low, high)) { } {
          mid := div(add(low,high),2)
          term := sload(add(sha3(0x60,0x20),div(mid,2)))

          switch mod(mid,2)
          case 1 {
            for { let j := 0 } lt(j, 4) { j := add(j, 1) } {
              term := div(term,4294967296)
            }
          }

          term := and(term,0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)

          switch lt(term,value)
          case 1 {
             low := add(mid,1)
          }
          case 0 {
            switch gt(term,value)
            case 1 {
              high := sub(mid,1)
            }
            case 0 {
              found := 1
              index := mid
              low := add(high,1)
            }
          }
        }
      }
      case 0 {
        for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
          term := sload(add(sha3(0x60,0x20),div(i,2)))
          switch mod(i,2)
          case 1 {
            for { let j := 0 } lt(j, 4) { j := add(j, 1) } {
              term := div(term,4294967296)
            }
          }

          term := and(term,0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)

          switch eq(term, value)
          case 1 {
            found := 1
            index := i
            i := sload(self_slot)
          }
        }
      }
    }
  }

  
  
  
  function getParentI(uint256 index) private pure returns (uint256 pI) {
    uint256 i = index - 1;
    pI = i/2;
  }

  
  
  
  function getLeftChildI(uint256 index) private pure returns (uint256 lcI) {
    uint256 i = index * 2;
    lcI = i + 1;
  }

  
  
  function heapSort(uint128[] storage self) public {
    uint256 end = self.length - 1;
    uint256 start = getParentI(end);
    uint256 root = start;
    uint256 lChild;
    uint256 rChild;
    uint256 swap;
    uint128 temp;
    while(start >= 0){
      root = start;
      lChild = getLeftChildI(start);
      while(lChild <= end){
        rChild = lChild + 1;
        swap = root;
        if(self[swap] < self[lChild])
          swap = lChild;
        if((rChild <= end) && (self[swap]<self[rChild]))
          swap = rChild;
        if(swap == root)
          lChild = end+1;
        else {
          temp = self[swap];
          self[swap] = self[root];
          self[root] = temp;
          root = swap;
          lChild = getLeftChildI(root);
        }
      }
      if(start == 0)
        break;
      else
        start = start - 1;
    }
    while(end > 0){
      temp = self[end];
      self[end] = self[0];
      self[0] = temp;
      end = end - 1;
      root = 0;
      lChild = getLeftChildI(0);
      while(lChild <= end){
        rChild = lChild + 1;
        swap = root;
        if(self[swap] < self[lChild])
          swap = lChild;
        if((rChild <= end) && (self[swap]<self[rChild]))
          swap = rChild;
        if(swap == root)
          lChild = end + 1;
        else {
          temp = self[swap];
          self[swap] = self[root];
          self[root] = temp;
          root = swap;
          lChild = getLeftChildI(root);
        }
      }
    }
  }

  
  
  function uniq(uint128[] storage self) public returns (uint256 length) {
    bool contains;
    uint256 index;

    for (uint256 i = 0; i < self.length; i++) {
      (contains, index) = indexOf(self, self[i], false);

      if (i > index) {
        for (uint256 j = i; j < self.length - 1; j++){
          self[j] = self[j + 1];
        }

        delete self[self.length - 1];
        self.length--;
        i--;
      }
    }

    length = self.length;
  }
}