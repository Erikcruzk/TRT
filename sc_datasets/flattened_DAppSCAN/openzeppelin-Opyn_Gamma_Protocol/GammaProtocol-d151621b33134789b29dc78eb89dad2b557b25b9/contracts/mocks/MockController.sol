// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/interfaces/OtokenInterface.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

interface OtokenInterface {
    function underlyingAsset() external view returns (address);

    function strikeAsset() external view returns (address);

    function collateralAsset() external view returns (address);

    function strikePrice() external view returns (uint256);

    function expiryTimestamp() external view returns (uint256);

    function isPut() external view returns (bool);

    function init(
        address _addressBook,
        address _underlyingAsset,
        address _strikeAsset,
        address _collateralAsset,
        uint256 _strikePrice,
        uint256 _expiry,
        bool _isPut
    ) external;

    function mintOtoken(address account, uint256 amount) external;

    function burnOtoken(address account, uint256 amount) external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/mocks/MockController.sol

/**
 * SPDX-License-Identifier: UNLICENSED
 */
pragma solidity 0.6.10;

// import "../packages/oz/upgradeability/VersionedInitializable.sol";

/**
 * @author Opyn Team
 * @notice Upgradeable Controller that can mock minting and burning calls from controller.
 */
contract MockController {
    /// @notice addressbook address
    address public addressBook;
    address public owner;

    /**
     * @dev this function is invoked by the proxy contract when this contract is added to the
     * AddressBook.
     * @param _addressBook the address of the AddressBook
     **/
    function initialize(address _addressBook, address _owner) external {
        addressBook = _addressBook;
        owner = _owner;
    }

    /**
     * @dev this function is used to test if controller can mint otokens
     */
    function testMintOtoken(
        address _otoken,
        address _account,
        uint256 _amount
    ) external {
        OtokenInterface(_otoken).mintOtoken(_account, _amount);
    }

    /**
     * @dev this function is used to test if controller can burn otokens
     */
    function testBurnOtoken(
        address _otoken,
        address _account,
        uint256 _amount
    ) external {
        OtokenInterface(_otoken).burnOtoken(_account, _amount);
    }
}
