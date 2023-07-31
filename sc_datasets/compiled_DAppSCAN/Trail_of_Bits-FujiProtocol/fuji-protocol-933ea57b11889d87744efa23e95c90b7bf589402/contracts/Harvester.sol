// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-FujiProtocol/fuji-protocol-933ea57b11889d87744efa23e95c90b7bf589402/contracts/interfaces/IFujiAdmin.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IFujiAdmin {
  function validVault(address _vaultAddr) external view returns (bool);

  function getFlasher() external view returns (address);

  function getFliquidator() external view returns (address);

  function getController() external view returns (address);

  function getTreasury() external view returns (address payable);

  function getVaultHarvester() external view returns (address);

  function getSwapper() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-FujiProtocol/fuji-protocol-933ea57b11889d87744efa23e95c90b7bf589402/contracts/interfaces/IHarvester.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IHarvester {
  struct Transaction {
    address to;
    bytes data;
  }

  function getHarvestTransaction(uint256 _farmProtocolNum, bytes memory _data)
    external
    returns (address claimedToken, Transaction memory transaction);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-FujiProtocol/fuji-protocol-933ea57b11889d87744efa23e95c90b7bf589402/contracts/Harvester.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract VaultHarvester is IHarvester {
  /**
   * @dev Called by the Vault to harvest farmed tokens at baselayer Protocols
   * @param _farmProtocolNum: Number assigned to Protocol for farming
   */
  function getHarvestTransaction(uint256 _farmProtocolNum, bytes memory _data)
    external
    view
    override
    returns (address claimedToken, Transaction memory transaction)
  {
    if (_farmProtocolNum == 0) {
      transaction.to = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
      transaction.data = abi.encodeWithSelector(
        bytes4(keccak256("claimComp(address)")),
        msg.sender
      );
      claimedToken = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
    } else if (_farmProtocolNum == 1) {
      uint256 harvestType = abi.decode(_data, (uint256));

      if (harvestType == 0) {
        // claim
        (, address[] memory assets) = abi.decode(_data, (uint256, address[]));
        transaction.to = 0xd784927Ff2f95ba542BfC824c8a8a98F3495f6b5;
        transaction.data = abi.encodeWithSelector(
          bytes4(keccak256("claimRewards(address[],uint256,address)")),
          assets,
          type(uint256).max,
          msg.sender
        );
      } else if (harvestType == 1) {
        //
        transaction.to = 0x4da27a545c0c5B758a6BA100e3a049001de870f5;
        transaction.data = abi.encodeWithSelector(bytes4(keccak256("cooldown()")));
      } else if (harvestType == 2) {
        //
        transaction.to = 0x4da27a545c0c5B758a6BA100e3a049001de870f5;
        transaction.data = abi.encodeWithSelector(
          bytes4(keccak256("redeem(address,uint256)")),
          msg.sender,
          type(uint256).max
        );
        claimedToken = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
      }
    }
  }
}
