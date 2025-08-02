// CustomERC20.sol

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CustomERC20 is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    // Make _transfer virtual so you can override it
    function _transfer(address from, address to, uint256 amount) internal virtual override {
        super._transfer(from, to, amount);
    }
}
