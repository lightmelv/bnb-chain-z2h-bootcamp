// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BadgerCoin is ERC20, Pausable, Ownable {
    constructor() ERC20("BadgerCoin", "BC") {
        _mint(msg.sender, 1000000000000000000000000); // initial supply of 1,000,000 tokens with 18 decimals
    }

    function pause() public onlyOwner {
        _pause();
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner {
        _unpause();
        emit Unpaused(msg.sender);
    }

    function transfer(address recipient, uint256 amount) public whenNotPaused override returns (bool) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused override returns (bool) {
        return super.transferFrom(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        return super.approve(spender, amount);
    }
}
