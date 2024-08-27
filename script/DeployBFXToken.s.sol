// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {BFXToken} from "../src/BFXToken.sol";

contract DeployBFXToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000_303 * 10**18;
    uint256 public constant MAX_SUPPLY = 2_000_000_303 * 10**18;
    
    function run() public returns (BFXToken) {
        uint256 deployerPrivateKey;
        if (bytes(vm.envString("PRIVATE_KEY")).length > 0) {
            deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        } else {
            // Use a default private key for testing
            deployerPrivateKey = 0x1;
        }
        
        vm.startBroadcast(deployerPrivateKey);
        BFXToken bfxToken = new BFXToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return bfxToken;
    }
}