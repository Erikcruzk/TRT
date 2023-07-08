// File: ../sc_datasets/DAppSCAN/QuillAudits-SushiSwap-BentoBox/bentobox-c2e150b16b8764ebfe2e1e6e267ae14e10738065/contracts/libraries/BoringMath.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
// a library for performing overflow-safe math, updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math)
library BoringMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {require((c = a + b) >= b, "BoringMath: Add Overflow");}
    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {require((c = a - b) <= a, "BoringMath: Underflow");}
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {require(b == 0 || (c = a * b)/b == a, "BoringMath: Mul Overflow");}
    function to128(uint256 a) internal pure returns (uint128 c) {
        require(a <= uint128(-1), "BoringMath: uint128 Overflow");
        c = uint128(a);
    }
}

library BoringMath128 {
    function add(uint128 a, uint128 b) internal pure returns (uint128 c) {require((c = a + b) >= b, "BoringMath: Add Overflow");}
    function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {require((c = a - b) <= a, "BoringMath: Underflow");}
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-SushiSwap-BentoBox/bentobox-c2e150b16b8764ebfe2e1e6e267ae14e10738065/contracts/interfaces/IOracle.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IOracle {
    // Get the latest exchange rate, if no valid (recent) rate is available, return false
    function get(bytes calldata data) external returns (bool, uint256);
    function peek(bytes calldata data) external view returns (bool, uint256);
    function symbol(bytes calldata data) external view returns (string memory);
    function name(bytes calldata data) external view returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-SushiSwap-BentoBox/bentobox-c2e150b16b8764ebfe2e1e6e267ae14e10738065/contracts/oracles/PeggedOracle.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;


contract PeggedOracle is IOracle {
    using BoringMath for uint256;

    function getDataParameter(uint256 rate) public pure returns (bytes memory) { return abi.encode(rate); }

    // Get the exchange rate
    function get(bytes calldata data) public override returns (bool, uint256) {
        uint256 rate = abi.decode(data, (uint256));
        return (rate != 0, rate);
    }

    // Check the exchange rate without any state changes
    function peek(bytes calldata data) public override view returns (bool, uint256) {
        uint256 rate = abi.decode(data, (uint256));
        return (rate != 0, rate);
    }

    function name(bytes calldata) public override view returns (string memory) {
        return "Pegged";
    }

    function symbol(bytes calldata) public override view returns (string memory) {
        return "PEG";
    }
}
