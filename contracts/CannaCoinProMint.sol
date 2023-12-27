// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CannaCoinProMint is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);

    constructor() ERC20("CannacoinPRO", "CPRO") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}
