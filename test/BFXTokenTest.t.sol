// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {BFXToken} from "../src/BFXToken.sol";
import {DeployBFXToken} from "../script/DeployBFXToken.s.sol";

contract BFXTokenTest is Test {
    BFXToken public bfxToken;
    DeployBFXToken public deployer;
    address public owner;
    address public user1;
    address public user2;

    uint256 public constant INITIAL_SUPPLY = 1_000_000_303 * 10**18;
    uint256 public constant MAX_SUPPLY = 2_000_000_303 * 10**18;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        bfxToken = new BFXToken(INITIAL_SUPPLY);
        deployer = new DeployBFXToken();
    }

function testDeployBFXToken() public {
    // Set up a mock private key for testing
    uint256 mockPrivateKey = 123456789; // Use a dummy value for testing

    // Mock the environment variable
    vm.setEnv("PRIVATE_KEY", vm.toString(mockPrivateKey));

    // Deploy the token
    BFXToken deployedToken = deployer.run();

    // Assert that the token was deployed successfully
    assertTrue(address(deployedToken) != address(0), "BFXToken not deployed");

    // Check initial supply
    assertEq(deployedToken.totalSupply(), INITIAL_SUPPLY, "Incorrect initial supply");

    // Check max supply
    assertEq(deployedToken.MAX_SUPPLY(), MAX_SUPPLY, "Incorrect max supply");

    // Check token name and symbol
    assertEq(deployedToken.name(), "BFXToken", "Incorrect token name");
    assertEq(deployedToken.symbol(), "BFX", "Incorrect token symbol");

    // Check that the deployer is the owner
    assertEq(deployedToken.owner(), vm.addr(mockPrivateKey), "Incorrect owner");
}
    function testInitialSupply() public view {
        assertEq(bfxToken.totalSupply(), INITIAL_SUPPLY);
        assertEq(bfxToken.balanceOf(owner), INITIAL_SUPPLY);
    }

    function testInitialSupplyExceedsMaxSupply() public {
        vm.expectRevert(BFXToken.MINTERROR__INITIALSUPPLYEXCEEDSMAXSUPPLY.selector);
        new BFXToken(MAX_SUPPLY + 1);
    }

    function testMint() public {
        uint256 amount = 5 * 10**18;
        vm.prank(user1);
        bfxToken.mint(amount);
        assertEq(bfxToken.balanceOf(user1), amount);
        assertEq(bfxToken.mintedTokens(user1), amount);
    }

    function testMintExceedsMaxSupply() public {
        uint256 amount = MAX_SUPPLY - INITIAL_SUPPLY + 1;
        vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXSUPPLY.selector);
        bfxToken.mint(amount);
    }

    function testMintExceedsMaxPerWallet() public {
        uint256 amount = bfxToken.MAX_MINT_PER_WALLET() + 1;
        vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXPERWALLET.selector);
        bfxToken.mint(amount);
    }

    function testTransfer() public {
        uint256 amount = 5 * 10**18;
        bfxToken.transfer(user1, amount);
        assertEq(bfxToken.balanceOf(user1), amount);
        assertEq(bfxToken.balanceOf(owner), INITIAL_SUPPLY - amount);
    }

    function testTransferBelowMinimum() public {
        uint256 amount = bfxToken.MIN_TRANSFER_AMOUNT() - 1;
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMTRANSFER.selector);
        bfxToken.transfer(user1, amount);
    }

    function testTransferBelowMinimumBalance() public {
        uint256 amount = INITIAL_SUPPLY - bfxToken.MIN_WALLET_BALANCE() + 1;
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMBALANCE.selector);
        bfxToken.transfer(user1, amount);
    }

    function testTransferFrom() public {
        uint256 amount = 5 * 10**18;
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        bfxToken.transferFrom(owner, user2, amount);
        assertEq(bfxToken.balanceOf(user2), amount);
        assertEq(bfxToken.balanceOf(owner), INITIAL_SUPPLY - amount);
    }

    function testTransferFromBelowMinimum() public {
        uint256 amount = bfxToken.MIN_TRANSFER_AMOUNT() - 1;
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMTRANSFER.selector);
        bfxToken.transferFrom(owner, user2, amount);
    }

    function testTransferFromBelowMinimumBalance() public {
        uint256 amount = INITIAL_SUPPLY - bfxToken.MIN_WALLET_BALANCE() + 1;
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMBALANCE.selector);
        bfxToken.transferFrom(owner, user2, amount);
    }

    function testOwnership() public view {
        assertEq(bfxToken.owner(), owner);
    }

    function testConstants() public view {
        assertEq(bfxToken.MAX_SUPPLY(), MAX_SUPPLY);
        assertEq(bfxToken.MAX_MINT_PER_WALLET(), 10 * 10**18);
        assertEq(bfxToken.MIN_TRANSFER_AMOUNT(), 2 * 10**18);
        assertEq(bfxToken.MIN_WALLET_BALANCE(), 2 * 10**18);
    }

    function testName() public view {
        assertEq(bfxToken.name(), "BFXToken");
    }

    function testSymbol() public view {
        assertEq(bfxToken.symbol(), "BFX");
    }

    function testDecimals() public view {
        assertEq(bfxToken.decimals(), 18);
    }

    function testMultipleMints() public {
        uint256 amount = 5 * 10**18;
        vm.startPrank(user1);
        bfxToken.mint(amount);
        bfxToken.mint(amount);
        vm.stopPrank();
        assertEq(bfxToken.balanceOf(user1), amount * 2);
        assertEq(bfxToken.mintedTokens(user1), amount * 2);
    }

    function testMintMaxAllowed() public {
        uint256 amount = bfxToken.MAX_MINT_PER_WALLET();
        vm.prank(user1);
        bfxToken.mint(amount);
        assertEq(bfxToken.balanceOf(user1), amount);
        assertEq(bfxToken.mintedTokens(user1), amount);
    }

    function testTransferExactMinimum() public {
        uint256 amount = bfxToken.MIN_TRANSFER_AMOUNT();
        bfxToken.transfer(user1, amount);
        assertEq(bfxToken.balanceOf(user1), amount);
    }

    function testTransferLeavingExactMinimumBalance() public {
        uint256 amount = INITIAL_SUPPLY - bfxToken.MIN_WALLET_BALANCE();
        bfxToken.transfer(user1, amount);
        assertEq(bfxToken.balanceOf(owner), bfxToken.MIN_WALLET_BALANCE());
    }

    function testTransferFromExactMinimum() public {
        uint256 amount = bfxToken.MIN_TRANSFER_AMOUNT();
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        bfxToken.transferFrom(owner, user2, amount);
        assertEq(bfxToken.balanceOf(user2), amount);
    }

    function testTransferFromLeavingExactMinimumBalance() public {
        uint256 amount = INITIAL_SUPPLY - bfxToken.MIN_WALLET_BALANCE();
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        bfxToken.transferFrom(owner, user2, amount);
        assertEq(bfxToken.balanceOf(owner), bfxToken.MIN_WALLET_BALANCE());
    }

}