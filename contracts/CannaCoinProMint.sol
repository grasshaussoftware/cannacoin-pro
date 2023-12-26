// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CannaCoinProMint is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);

    constructor(address initialOwner) ERC20("Cannacoin PRO", "CPRO") Ownable(initialOwner) {
        _mint(initialOwner, INITIAL_SUPPLY);
    }
}
