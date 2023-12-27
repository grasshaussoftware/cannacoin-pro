// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CannaCoinProMint is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);

    constructor() ERC20("Cannacoin PRO", "CPRO") {
    _mint(msg.sender, INITIAL_SUPPLY);
}
}