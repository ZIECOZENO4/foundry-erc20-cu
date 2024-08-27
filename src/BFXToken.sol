// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BFXToken is ERC20, Ownable {
    error MINTERROR__MORETHANMAXSUPPLY();
    error MINTERROR__MORETHANMAXPERWALLET();
    error MINTERROR__INITIALSUPPLYEXCEEDSMAXSUPPLY();
    error TRANSFERERROR__BELOWMINIMUMTRANSFER();
    error TRANSFERERROR__BELOWMINIMUMBALANCE();
    error BURNERROR__BELOWMINIMUMBALANCE();
    error BURNERROR__EXCEEDSBURNAMOUNT();

    uint256 public constant INITIAL_SUPPLY = 1_000_000_303 * 10**18;
    uint256 public constant MAX_SUPPLY = 2_000_000_303 * 10**18;
    uint256 public constant MAX_MINT_PER_WALLET = 10 * 10**18;
    uint256 public constant MIN_TRANSFER_AMOUNT = 2 * 10**18;
    uint256 public constant MIN_WALLET_BALANCE = 2 * 10**18;

    mapping(address => uint256) public mintedTokens;
    
    constructor(uint256 initialSupply) ERC20("BFXToken", "BFX") Ownable(msg.sender) {
        if (initialSupply > MAX_SUPPLY) {
            revert MINTERROR__INITIALSUPPLYEXCEEDSMAXSUPPLY();
        }
        _mint(msg.sender, initialSupply);
    }

    function mint(uint256 amount) public {
        if (totalSupply() + amount > MAX_SUPPLY) {
            revert MINTERROR__MORETHANMAXSUPPLY();
        }
        if (mintedTokens[msg.sender] + amount > MAX_MINT_PER_WALLET) {
            revert MINTERROR__MORETHANMAXPERWALLET();
        }
        _mint(msg.sender, amount);
        mintedTokens[msg.sender] += amount;
    }

    function burn(uint256 amount) public {
        if (balanceOf(msg.sender) - amount < MIN_WALLET_BALANCE) {
            revert BURNERROR__BELOWMINIMUMBALANCE();
        }
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public {
        if (balanceOf(account) - amount < MIN_WALLET_BALANCE) {
            revert BURNERROR__BELOWMINIMUMBALANCE();
        }
        uint256 currentAllowance = allowance(account, msg.sender);
        if (currentAllowance < amount) {
            revert BURNERROR__EXCEEDSBURNAMOUNT();
        }
        unchecked {
            _approve(account, msg.sender, currentAllowance - amount);
        }
        _burn(account, amount);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        if (amount < MIN_TRANSFER_AMOUNT) {
            revert TRANSFERERROR__BELOWMINIMUMTRANSFER();
        }
        if (balanceOf(msg.sender) - amount < MIN_WALLET_BALANCE) {
            revert TRANSFERERROR__BELOWMINIMUMBALANCE();
        }
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        if (amount < MIN_TRANSFER_AMOUNT) {
            revert TRANSFERERROR__BELOWMINIMUMTRANSFER();
        }
        if (balanceOf(from) - amount < MIN_WALLET_BALANCE) {
            revert TRANSFERERROR__BELOWMINIMUMBALANCE();
        }
        return super.transferFrom(from, to, amount);
    }
}