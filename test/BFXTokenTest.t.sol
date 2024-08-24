
// pragma solidity ^0.8.19;

// import {DeployBFXToken} from "../script/DeployBFXToken.s.sol";
// import {BFXToken} from "../src/BFXToken.sol";
// import {Test, console} from "forge-std/Test.sol";
// import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
// import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

// contract BFXTokenTest is Test, ZkSyncChainChecker {
//     uint256 constant BOB_STARTING_AMOUNT = 100 * 10**18;
// uint256 constant INITIAL_SUPPLY = 1_000_000_303 * 10**18;
//     uint256 constant MAX_MINT_PER_WALLET = 10 * 10**18;

//     BFXToken public bfxToken;
//     DeployBFXToken public deployer;
//     address public deployerAddress;
//     address bob;
//     address alice;

// function setUp() public {
//     deployer = new DeployBFXToken();
//     if (!isZkSyncChain()) {
//         bfxToken = deployer.run();
//     } else {
//         bfxToken = new BFXToken(INITIAL_SUPPLY);
//     }
    
//     // Verify the initial supply
//     assertEq(bfxToken.totalSupply(), INITIAL_SUPPLY, "Initial supply mismatch");

//     bob = makeAddr("bob");
//     alice = makeAddr("alice");

//     // Transfer to Bob using a smaller amount
//     uint256 bobAmount = 100 * 10**18; // Increased from 10 to 100 to meet minimum transfer amount
//     vm.prank(bfxToken.owner());
//     bfxToken.transfer(bob, bobAmount);

//     // Update BOB_STARTING_AMOUNT constant
//     // uint256 constant BOB_STARTING_AMOUNT = 100 * 10**18;

//     // Verify Bob's balance
//     assertEq(bfxToken.balanceOf(bob), bobAmount, "Bob's balance mismatch");
// }
//     function testInitialSupply() public view {
//         assertEq(bfxToken.totalSupply(), 1_000_000_303_000_000_000_000_000_000_000_000);
//     }

//     function testMint() public {
//         uint256 mintAmount = 50 * 10**18;
//         uint256 initialBalance = bfxToken.balanceOf(bob);
//         vm.prank(bob);
//         vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXSUPPLY.selector);
//         bfxToken.mint(mintAmount);
//         assertEq(bfxToken.balanceOf(bob), initialBalance);
//     }

// function testAllowances() public {
//     uint256 initialAllowance = 1000 * 10**18;
//     vm.prank(bob);
//     bfxToken.approve(alice, initialAllowance);

//     uint256 transferAmount = 500 * 10**18;
//     vm.prank(alice);
//     bfxToken.transferFrom(bob, alice, transferAmount);

//     assertEq(bfxToken.balanceOf(alice), transferAmount);
//     assertEq(bfxToken.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
//     assertEq(bfxToken.allowance(bob, alice), initialAllowance - transferAmount);
// }


//     function testTransfer() public {
//         uint256 transferAmount = 5 * 10**18;
//         uint256 bobInitialBalance = bfxToken.balanceOf(bob);
//         uint256 aliceInitialBalance = bfxToken.balanceOf(alice);

//         vm.prank(bob);
//         bfxToken.transfer(alice, transferAmount);

//         assertEq(bfxToken.balanceOf(bob), bobInitialBalance - transferAmount);
//         assertEq(bfxToken.balanceOf(alice), aliceInitialBalance + transferAmount);
//     }

//     function testFailTransferInsufficientBalance() public {
//         uint256 bobBalance = bfxToken.balanceOf(bob);
//         vm.prank(bob);
//         vm.expectRevert("ERC20: transfer amount exceeds balance");
//         bfxToken.transfer(alice, bobBalance + 1);
//     }

//     function testOwnershipTransfer() public {
//         address newOwner = makeAddr("newOwner");
//         vm.prank(bfxToken.owner());
//         bfxToken.transferOwnership(newOwner);
//         assertEq(bfxToken.owner(), newOwner);
//     }

//     function testFailNonOwnerTransferOwnership() public {
//         address newOwner = makeAddr("newOwner");
//         vm.prank(bob);
//         vm.expectRevert("Ownable: caller is not the owner");
//         bfxToken.transferOwnership(newOwner);
//     }

//     function testBalanceOfSpecificAddresses() public view {
//         assertEq(bfxToken.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 1_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0x1E212f3E10Cc989BA9330A2F0e482D2ab6fB6CF0), 1_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0xaffEfE9e043432D9F672cB62Ae9f2ca8D4d974E9), 1_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0x1C15f0f38E2C33CBFC585275a3336B68E80864fc), 100_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0x798644a207d4f043601606853E2f93070a9dbb03), 100_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0xB8622ea337FE15296Cb62b984E41dC6cda7E91b5), 100_000_000 * 10**18);
//     }

//     function testTransferFromSpecificAddresses() public {
//         uint256 transferAmount = 5 * 10**18;
//         vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
//         bfxToken.transfer(alice, transferAmount);

//         assertEq(bfxToken.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 1_000_000 * 10**18 - transferAmount);
//         assertEq(bfxToken.balanceOf(alice), transferAmount);
//     }

//     function testTransferToSpecificAddresses() public {
//         uint256 transferAmount = 5 * 10**18;
//         vm.prank(bob);
//         bfxToken.transfer(0x1E212f3E10Cc989BA9330A2F0e482D2ab6fB6CF0, transferAmount);

//         assertEq(bfxToken.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
//         assertEq(bfxToken.balanceOf(0x1E212f3E10Cc989BA9330A2F0e482D2ab6fB6CF0), 1_000_000 * 10**18 + transferAmount);
//     }

//     function testConstructor() public view {
//         assertEq(bfxToken.name(), "BFXToken");
//         assertEq(bfxToken.symbol(), "BFX");
//         assertEq(bfxToken.decimals(), 18);
//         assertEq(bfxToken.MAX_SUPPLY(), 1_000_000_303_000_000_000_000_000_000_000_000);
//         assertEq(bfxToken.MAX_MINT_PER_WALLET(), 10 * 10**18);
//     }

//     function testMintExceedingTotalSupply() public {
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - bfxToken.totalSupply();
//         uint256 exceedingAmount = remainingSupply + 1;
//         vm.prank(alice);
//         vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXSUPPLY.selector);
//         bfxToken.mint(exceedingAmount);
//     }

//     function testInitialTokenDistribution() public view {
//         assertEq(bfxToken.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 1_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0x1E212f3E10Cc989BA9330A2F0e482D2ab6fB6CF0), 1_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0xaffEfE9e043432D9F672cB62Ae9f2ca8D4d974E9), 1_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0x1C15f0f38E2C33CBFC585275a3336B68E80864fc), 100_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0x798644a207d4f043601606853E2f93070a9dbb03), 100_000_000 * 10**18);
//         assertEq(bfxToken.balanceOf(0xB8622ea337FE15296Cb62b984E41dC6cda7E91b5), 100_000_000 * 10**18);
//     }

//     function testMintExceedingLimit() public {
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - bfxToken.totalSupply();
//         uint256 mintAmount = remainingSupply + 1;
//         vm.prank(bob);
//         vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXSUPPLY.selector);
//         bfxToken.mint(mintAmount);
//     }

//     function testMintWithinLimits() public {
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - bfxToken.totalSupply();
//         uint256 mintAmount = remainingSupply > 5 * 10**18 ? 5 * 10**18 : remainingSupply;
//         uint256 initialBalance = bfxToken.balanceOf(alice);
//         vm.prank(alice);
//         bfxToken.mint(mintAmount);
//         assertEq(bfxToken.balanceOf(alice), initialBalance + mintAmount);
//         assertEq(bfxToken.mintedTokens(alice), mintAmount);
//     }

//     function testMultipleMints() public {
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - bfxToken.totalSupply();
//         uint256 firstMint = remainingSupply > 4 * 10**18 ? 4 * 10**18 : remainingSupply / 2;
//         uint256 secondMint = remainingSupply - firstMint > 6 * 10**18 ? 6 * 10**18 : remainingSupply - firstMint;

//         vm.startPrank(alice);
//         bfxToken.mint(firstMint);
//         if (secondMint > 0) {
//             bfxToken.mint(secondMint);
//         }
//         vm.stopPrank();

//         assertEq(bfxToken.mintedTokens(alice), firstMint + secondMint);
//         assertEq(bfxToken.balanceOf(alice), firstMint + secondMint);
//     }

//     function testMintZeroAmount() public {
//         uint256 initialBalance = bfxToken.balanceOf(alice);
//         vm.prank(alice);
//         bfxToken.mint(0);
//         assertEq(bfxToken.balanceOf(alice), initialBalance);
//         assertEq(bfxToken.mintedTokens(alice), 0);
//     }

//     function testMintAtMaxPerWalletLimit() public {
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - bfxToken.totalSupply();
//         uint256 mintAmount = bfxToken.MAX_MINT_PER_WALLET();
//         if (remainingSupply >= mintAmount) {
//             vm.startPrank(alice);
//             bfxToken.mint(mintAmount);
//             assertEq(bfxToken.mintedTokens(alice), mintAmount);
//             vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXPERWALLET.selector);
//             bfxToken.mint(1);
//             vm.stopPrank();
//         } else {
//             vm.skip(true);
//         }
//     }

//     function testMintExceedingPerWalletLimit() public {
//         uint256 mintAmount = bfxToken.MAX_MINT_PER_WALLET() + 1;
//         vm.prank(alice);
//         vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXPERWALLET.selector);
//         bfxToken.mint(mintAmount);
//     }

//     function testFuzzMintFailsAboveMaxPerWallet(uint256 amount) public {
//         vm.assume(amount > bfxToken.MAX_MINT_PER_WALLET());
//         vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXPERWALLET.selector);
//         bfxToken.mint(amount);
//     }

//     function testMathMaxSupplyInvariant() public {
//         uint256 initialSupply = bfxToken.totalSupply();
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - initialSupply;
//         uint256 mintAmount = Math.min(MAX_MINT_PER_WALLET, remainingSupply);
//         bfxToken.mint(mintAmount);
//         assertEq(bfxToken.totalSupply(), initialSupply + mintAmount);
//         if (bfxToken.totalSupply() == bfxToken.MAX_SUPPLY()) {
//             vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXSUPPLY.selector);
//             bfxToken.mint(1);
//         }
//     }

//     function testFuzzMint(uint256 amount) public {
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - bfxToken.totalSupply();
//         uint256 maxMintAmount = Math.min(bfxToken.MAX_MINT_PER_WALLET(), remainingSupply);
//         if (maxMintAmount > 0) {
//             amount = bound(amount, 1, maxMintAmount);
//             uint256 initialBalance = bfxToken.balanceOf(address(this));
//             bfxToken.mint(amount);
//             uint256 finalBalance = bfxToken.balanceOf(address(this));
//             assertEq(finalBalance, initialBalance + amount);
//             assertEq(bfxToken.mintedTokens(address(this)), amount);
//         } else {
//             vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXSUPPLY.selector);
//             bfxToken.mint(1);
//         }
//     }

//     function testFuzzMultipleMints(uint256[] calldata amounts) public {
//         vm.assume(amounts.length > 0 && amounts.length <= 10);
//         uint256 totalMinted = 0;
//         uint256 remainingSupply = bfxToken.MAX_SUPPLY() - bfxToken.totalSupply();
//         uint256 remainingWalletLimit = bfxToken.MAX_MINT_PER_WALLET();

//         for (uint256 i = 0; i < amounts.length; i++) {
//             uint256 maxMintAmount = Math.min(remainingWalletLimit, remainingSupply);
//             if (maxMintAmount > 0) {
//                 uint256 amount = bound(amounts[i], 1, maxMintAmount);
//                 bfxToken.mint(amount);
//                 totalMinted += amount;
//                 remainingSupply -= amount;
//                 remainingWalletLimit -= amount;
//             } else {
//                 break;
//             }
//             if (remainingSupply == 0 || remainingWalletLimit == 0) break;
//         }

//         assertEq(bfxToken.balanceOf(address(this)), totalMinted);
//         assertEq(bfxToken.mintedTokens(address(this)), totalMinted);
//     }

//     function testMathBalanceSum() public {
//         uint256 initialTotalSupply = bfxToken.totalSupply();
//         uint256 totalMinted = 0;
//         address[] memory recipients = new address[](10);

//         for (uint256 i = 0; i < 10; i++) {
//             recipients[i] = address(uint160(i + 1));
//             uint256 amount = (i + 1) * 10**18;
//             if (totalMinted + amount > bfxToken.MAX_SUPPLY() - initialTotalSupply) {
//                 amount = bfxToken.MAX_SUPPLY() - initialTotalSupply - totalMinted;
//             }
//             if (amount > 0) {
//                 bfxToken.mint(amount);
//                 totalMinted += amount;
//             }
//             if (totalMinted == bfxToken.MAX_SUPPLY() - initialTotalSupply) break;
//         }

//         uint256 sumOfBalances = 0;
//         for (uint256 i = 0; i < recipients.length; i++) {
//             sumOfBalances += bfxToken.balanceOf(recipients[i]);
//         }

//         assertEq(sumOfBalances, totalMinted);
//         assertEq(bfxToken.totalSupply(), totalMinted + initialTotalSupply);
//     }
// }
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {BFXToken} from "../src/BFXToken.sol";

contract BFXTokenTest is Test {
    BFXToken public bfxToken;
    address public owner;
    address public user1;
    address public user2;

    uint256 constant INITIAL_SUPPLY = 1_000_000_303 * 10**18;
    uint256 constant MAX_SUPPLY = 1_000_000_303_000_000_000_000_000_000_000_000;
    uint256 constant MAX_MINT_PER_WALLET = 10 * 10**18;
    uint256 constant MIN_TRANSFER_AMOUNT = 2 * 10**18;
    uint256 constant MIN_WALLET_BALANCE = 2 * 10**18;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        bfxToken = new BFXToken(INITIAL_SUPPLY);
    }

    // Deployment Tests
    function testInitialSupply() public {
        assertEq(bfxToken.totalSupply(), INITIAL_SUPPLY);
    }

    function testOwnership() public {
        assertEq(bfxToken.owner(), owner);
    }

    // Minting Tests
    function testMint() public {
        uint256 amount = 5 * 10**18;
        vm.prank(user1);
        bfxToken.mint(amount);
        assertEq(bfxToken.balanceOf(user1), amount);
    }

    function testMintExceedsMaxPerWallet() public {
        uint256 amount = MAX_MINT_PER_WALLET + 1;
        vm.prank(user1);
        vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXPERWALLET.selector);
        bfxToken.mint(amount);
    }

    function testMintExceedsMaxSupply() public {
        uint256 amount = MAX_SUPPLY - INITIAL_SUPPLY + 1;
        vm.prank(user1);
        vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXSUPPLY.selector);
        bfxToken.mint(amount);
    }

    // Transfer Tests
    function testTransfer() public {
        uint256 amount = 5 * 10**18;
        bfxToken.transfer(user1, amount);
        assertEq(bfxToken.balanceOf(user1), amount);
    }

    function testTransferBelowMinimum() public {
        uint256 amount = MIN_TRANSFER_AMOUNT - 1;
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMTRANSFER.selector);
        bfxToken.transfer(user1, amount);
    }

    function testTransferBelowMinimumBalance() public {
        uint256 initialBalance = bfxToken.balanceOf(owner);
        uint256 amount = initialBalance - MIN_WALLET_BALANCE + 1;
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMBALANCE.selector);
        bfxToken.transfer(user1, amount);
    }

    // TransferFrom Tests
    function testTransferFrom() public {
        uint256 amount = 5 * 10**18;
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        bfxToken.transferFrom(owner, user2, amount);
        assertEq(bfxToken.balanceOf(user2), amount);
    }

    function testTransferFromBelowMinimum() public {
        uint256 amount = MIN_TRANSFER_AMOUNT - 1;
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMTRANSFER.selector);
        bfxToken.transferFrom(owner, user2, amount);
    }

    function testTransferFromBelowMinimumBalance() public {
        uint256 initialBalance = bfxToken.balanceOf(owner);
        uint256 amount = initialBalance - MIN_WALLET_BALANCE + 1;
        bfxToken.approve(user1, amount);
        vm.prank(user1);
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMBALANCE.selector);
        bfxToken.transferFrom(owner, user2, amount);
    }

    // Fuzz Tests
    function testFuzzMint(uint256 amount) public {
        vm.assume(amount <= MAX_MINT_PER_WALLET);
        vm.assume(amount <= MAX_SUPPLY - INITIAL_SUPPLY);
        vm.prank(user1);
        bfxToken.mint(amount);
        assertEq(bfxToken.balanceOf(user1), amount);
    }

    function testFuzzTransfer(uint256 amount) public {
        vm.assume(amount >= MIN_TRANSFER_AMOUNT);
        vm.assume(amount <= INITIAL_SUPPLY - MIN_WALLET_BALANCE);
        bfxToken.transfer(user1, amount);
        assertEq(bfxToken.balanceOf(user1), amount);
    }

    // Mathematical Tests
    function testMathTotalSupply() public {
        uint256 mintAmount = MAX_SUPPLY - INITIAL_SUPPLY;
        vm.prank(user1);
        bfxToken.mint(mintAmount);
        assertEq(bfxToken.totalSupply(), MAX_SUPPLY);
    }

    function testMathMaxMintPerWallet() public {
        vm.startPrank(user1);
        for (uint256 i = 0; i < 10; i++) {
            bfxToken.mint(1 * 10**18);
        }
        vm.expectRevert(BFXToken.MINTERROR__MORETHANMAXPERWALLET.selector);
        bfxToken.mint(1);
        vm.stopPrank();
    }

    function testMathMinTransferAmount() public {
        uint256 amount = MIN_TRANSFER_AMOUNT;
        bfxToken.transfer(user1, amount);
        assertEq(bfxToken.balanceOf(user1), amount);

        vm.prank(user1);
        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMTRANSFER.selector);
        bfxToken.transfer(user2, amount - 1);
    }

    function testMathMinWalletBalance() public {
        uint256 initialBalance = bfxToken.balanceOf(owner);
        uint256 transferAmount = initialBalance - MIN_WALLET_BALANCE;
        bfxToken.transfer(user1, transferAmount);
        assertEq(bfxToken.balanceOf(owner), MIN_WALLET_BALANCE);

        vm.expectRevert(BFXToken.TRANSFERERROR__BELOWMINIMUMBALANCE.selector);
        bfxToken.transfer(user1, 1);
    }
}