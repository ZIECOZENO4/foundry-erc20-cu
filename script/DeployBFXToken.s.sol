// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {BFXToken} from "../src/BFXToken.sol";

contract DeployBFXToken is Script {
    uint256 constant INITIAL_SUPPLY = 1_000_000_303 * 10**18;
    
    function run() external returns (BFXToken) {
        vm.startBroadcast();
        BFXToken bfxToken = new BFXToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return bfxToken;
    }
}