
// 02.08.2025
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/CustomERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PROGUZMIR is ERC20, Ownable(msg.sender) {
    // 🔒 Blacklist mapping
    mapping(address => bool) private _blacklist;

    // 🔁 Reflection (dividend) toggle, default: false
    bool private _reflectionEnabled = false;
    uint256 private _reflectionFee = 2; // 2%

    constructor() ERC20("PROGUZMIR", "PROUZ") {
        _mint(msg.sender, 100_000_000 * 10 ** decimals());
    }

    // 🔥 Burn tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // 🧾 Mint new tokens (onlyOwner)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // ⛔ Manage blacklist (onlyOwner)
    function setBlacklist(address user, bool status) public onlyOwner {
        _blacklist[user] = status;
    }

    function isBlacklisted(address user) public view returns (bool) {
        return _blacklist[user];
    }

    // 🔁 Enable/disable reflection (onlyOwner)
    function setReflectionEnabled(bool status) public onlyOwner {
        _reflectionEnabled = status;
    }

    function isReflectionEnabled() public view returns (bool) {
        return _reflectionEnabled;
    }

    // ⚙️ Transfer hook with blacklist and optional reflection logic
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal override
        {
        require(!_blacklist[from], "Sender is blacklisted");
        require(!_blacklist[to], "Recipient is blacklisted");
        super._beforeTokenTransfer(from, to, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        if (_reflectionEnabled && sender != owner() && recipient != owner()) {
            uint256 fee = (amount * _reflectionFee) / 100;
            uint256 netAmount = amount - fee;
            super._transfer(sender, address(this), fee); // hold fees in contract for now
            super._transfer(sender, recipient, netAmount);
        } else {
            super._transfer(sender, recipient, amount);
        }
    }
}
