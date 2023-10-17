// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/test/resources/compatibility/contracts_linked_libraries/LinkedLibrary3.sol

pragma solidity ^0.5.3;

library LinkedLibrary3 {
  struct Struct {
    uint256 field;
  }

  function get(Struct storage s) public view returns (uint256) {
    return s.field;
  }

  function increase(Struct storage s) public {
    if (s.field == 0) {
      s.field = 1;
    }
    s.field *= 2;
  }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/test/resources/compatibility/contracts_linked_libraries/LinkedLibrary2.sol

pragma solidity ^0.5.3;

library LinkedLibrary2 {
  using LinkedLibrary3 for LinkedLibrary3.Struct;

  struct Struct {
    LinkedLibrary3.Struct s;
  }

  function get(Struct storage s) public view returns (uint256) {
    return s.s.get();
  }

  function increase(Struct storage s) public {
    s.s.increase();
  }
}