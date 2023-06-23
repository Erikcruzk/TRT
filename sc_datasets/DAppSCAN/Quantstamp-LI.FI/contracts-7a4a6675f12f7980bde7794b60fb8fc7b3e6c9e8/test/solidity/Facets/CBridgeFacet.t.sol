// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import { DSTest } from "ds-test/test.sol";
import { console } from "../utils/Console.sol";
import { DiamondTest, LiFiDiamond } from "../utils/DiamondTest.sol";
import { Vm } from "forge-std/Vm.sol";
import { CBridgeFacet } from "lifi/Facets/CBridgeFacet.sol";
import { ILiFi } from "lifi/Interfaces/ILiFi.sol";
import { LibSwap } from "lifi/Libraries/LibSwap.sol";
import { ERC20 } from "solmate/tokens/ERC20.sol";
import { UniswapV2Router02 } from "../utils/Interfaces.sol";

// Stub CBridgeFacet Contract
contract TestCBridgeFacet is CBridgeFacet {
    function addDex(address _dex) external {
        mapping(address => bool) storage dexAllowlist = ls.dexAllowlist;

        if (dexAllowlist[_dex]) {
            return;
        }

        dexAllowlist[_dex] = true;
        ls.dexs.push(_dex);
    }

    function setFunctionApprovalBySignature(bytes32 signature) external {
        mapping(bytes32 => bool) storage dexFuncSignatureAllowList = ls.dexFuncSignatureAllowList;
        if (dexFuncSignatureAllowList[signature]) return;
        dexFuncSignatureAllowList[signature] = true;
    }
}

contract CBridgeFacetTest is DSTest, DiamondTest {
    address internal constant CBRIDGE_ROUTER = 0x5427FEFA711Eff984124bFBB1AB6fbf5E3DA1820;
    address internal constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant USDC_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant WHALE = 0x72A53cDBBcc1b9efa39c834A540550e23463AAcB;
    ILiFi.LiFiData internal lifiData = ILiFi.LiFiData("", "", address(0), address(0), address(0), address(0), 0, 0);

    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    LiFiDiamond internal diamond;
    TestCBridgeFacet internal cBridge;
    ERC20 internal usdc;
    ERC20 internal dai;
    UniswapV2Router02 internal uniswap;

    function setUp() public {
        diamond = createDiamond();
        cBridge = new TestCBridgeFacet();
        usdc = ERC20(USDC_ADDRESS);
        dai = ERC20(DAI_ADDRESS);
        uniswap = UniswapV2Router02(UNISWAP_V2_ROUTER);

        bytes4[] memory functionSelectors = new bytes4[](5);
        functionSelectors[0] = cBridge.initCbridge.selector;
        functionSelectors[1] = cBridge.startBridgeTokensViaCBridge.selector;
        functionSelectors[2] = cBridge.swapAndStartBridgeTokensViaCBridge.selector;
        functionSelectors[3] = cBridge.addDex.selector;
        functionSelectors[4] = cBridge.setFunctionApprovalBySignature.selector;

        addFacet(diamond, address(cBridge), functionSelectors);

        cBridge = TestCBridgeFacet(address(diamond));
        cBridge.initCbridge(CBRIDGE_ROUTER, 1);
        cBridge.addDex(address(uniswap));
        cBridge.setFunctionApprovalBySignature(hex"38ed173900000000000000000000000000000000000000000000000000000000");
    }

    // struct CBridgeData {
    //     uint32 maxSlippage;
    //     uint64 dstChainId;
    //     uint64 nonce;
    //     uint256 amount;
    //     address receiver;
    //     address token;
    // }

    function testCanBridgeTokens() public {
        vm.startPrank(WHALE);
        usdc.approve(address(cBridge), 10_000 * 10**usdc.decimals());
        CBridgeFacet.CBridgeData memory data = CBridgeFacet.CBridgeData(
            5000,
            100,
            1,
            10_000 * 10**usdc.decimals(),
            WHALE,
            USDC_ADDRESS
        );
        cBridge.startBridgeTokensViaCBridge(lifiData, data);
        vm.stopPrank();
    }

    function testCanSwapAndBridgeTokens() public {
        vm.startPrank(WHALE);

        // Swap DAI -> USDC
        address[] memory path = new address[](2);
        path[0] = DAI_ADDRESS;
        path[1] = USDC_ADDRESS;

        uint256 amountOut = 1_000 * 10**usdc.decimals();

        // Calculate DAI amount
        uint256[] memory amounts = uniswap.getAmountsIn(amountOut, path);
        uint256 amountIn = amounts[0];

        CBridgeFacet.CBridgeData memory data = CBridgeFacet.CBridgeData(5000, 100, 1, amountOut, WHALE, USDC_ADDRESS);

        LibSwap.SwapData[] memory swapData = new LibSwap.SwapData[](1);
        swapData[0] = LibSwap.SwapData(
            address(uniswap),
            address(uniswap),
            DAI_ADDRESS,
            USDC_ADDRESS,
            amountIn,
            abi.encodeWithSelector(
                uniswap.swapExactTokensForTokens.selector,
                amountIn,
                amountOut,
                path,
                address(cBridge),
                block.timestamp + 20 minutes
            )
        );

        // Approve DAI
        dai.approve(address(cBridge), amountIn);
        cBridge.swapAndStartBridgeTokensViaCBridge(lifiData, swapData, data);
        vm.stopPrank();
    }
}
