// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/InterestRate/InterestRateModel.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  * @title InterestRateModel Interface
  * @author Amplify
  */
abstract contract InterestRateModel {
	bool public isInterestRateModel = true;

    struct GracePeriod {
        uint256 fee;
        uint256 start;
        uint256 end;
    }

    /**
     * @notice Calculates the utilization rate of the market: `borrows / (cash + borrows)`
     * @param cash The amount of cash in the pool
     * @param borrows The amount of borrows in the pool
     * @return The utilization rate as a mantissa between [0, 1e18]
     */
    function utilizationRate(uint256 cash, uint256 borrows) external virtual pure returns (uint256);

    /**
     * @notice Calculates the borrow rate for a given interest rate and GracePeriod length
     * @param interestRate The interest rate as a percentage number between [0, 100]
     * @return The borrow rate as a mantissa between  [0, 1e18]
     */
    function getBorrowRate(uint256 interestRate) external virtual view returns (uint256);

    /**
     * @notice Calculates the penalty fee for a given days range
     * @param index The index of the grace period record
     * @return The penalty fee as a mantissa between [0, 1e18]
     */
    function getPenaltyFee(uint8 index) external virtual view returns (uint256);

    /**
     * @notice Returns the penalty stages array
     */
    function getGracePeriod() external virtual view returns (GracePeriod[] memory);
    function getGracePeriodSnapshot() external virtual view returns (GracePeriod[] memory, uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC721/IERC721.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);

    function balanceOf(address owner) external view returns (uint balance);
    function ownerOf(uint tokenId) external view returns (address owner);
    
    function transferFrom(address from, address to, uint tokenId) external;
    function approve(address to, uint tokenId) external;
}

interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint tokenId) external view returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Asset/AssetInterface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract AssetInterface is IERC721 {
    bool public isAssetsFactory = true;

    function getTokenInfo(uint256 _tokenId) external virtual view returns (uint256, uint256, uint256, uint256, string memory, string memory, address, bool);
    function markAsRedeemed(uint256 tokenId) external virtual;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/LossProvisionPool/LossProvisionInterface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract LossProvisionInterface {
    bool public isLossProvision = true;

    /**
     * @notice Calculates the percentage of the loan's principal that is paid as fee: `(lossProvisionFee + buyBackProvisionFee)`
     * @return The total fees percentage as a mantissa between [0, 1e18]
     */
    function getFeesPercent() external virtual view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20Base {
    function balanceOf(address owner) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address src, address dst, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
}

interface IERC20 is IERC20Base {
    function totalSupply() external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);

    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

interface IERC20Burnable is IERC20 {
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Controller/ControllerStorage.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




abstract contract ControllerStorage {
    uint256 public amptDepositAmount = 10e18;

    LossProvisionInterface public provisionPool;
    InterestRateModel public interestRateModel;
    IERC20 public amptToken;
    AssetInterface public assetsFactory;

    struct Borrower {
        uint256 debtCeiling;
        uint256 ratingMantissa;
        bool whitelisted;
        bool created;
    }
    mapping(address => Borrower) public borrowers;

    struct Application {
        address lender;
        uint256 depositAmount;
        uint256 mapIndex;
        bool created;
        bool whitelisted;
    }

    struct PoolInfo {
        address owner;
        bool isActive;
    }

    mapping(address => PoolInfo) public pools;
    mapping(address => mapping(address => Application)) internal poolApplicationsByLender;

    mapping(address => Application[]) public poolApplications;


    mapping(address => address[]) internal borrowerPools;
    mapping(address => address[]) internal lenderJoinedPools;
    mapping(address => mapping(address => bool)) internal lenderJoinedPoolsMap;
    mapping(address => mapping(address => bool)) public borrowerWhitelists;
}
