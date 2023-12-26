// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Cannacoin is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);
    uint256 public constant AUTHORSHIP_HOLDING = 1000000 * (10 ** 18);
    address public constant LIQUIDITY_POOL_ADDRESS = 0xYourTeammateAddress; // Replace with your teammate's address
    address public constant PANGOLIN_FACTORY = 0xefa94DE7a4656D787667C749f7E1223D71E9FD88;
    address public constant PANGOLIN_ROUTER = 0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106;

    event FeePaid(address indexed from, address indexed to, uint256 feeAmount);

    constructor() ERC20("Cannacoin PRO", "CPRO") {
        _mint(msg.sender, INITIAL_SUPPLY - AUTHORSHIP_HOLDING);
        _mint(msg.sender, AUTHORSHIP_HOLDING); // Mint authorship holding to contract owner
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = calculateTransactionFee(amount);
        if (msg.sender == PANGOLIN_FACTORY || recipient == PANGOLIN_FACTORY ||
            msg.sender == PANGOLIN_ROUTER || recipient == PANGOLIN_ROUTER) {
            fee += calculatePangolinFee(amount); // Additional fee for Pangolin DEX swaps
        }

        uint256 amountAfterFee = amount - fee;
        _transfer(_msgSender(), recipient, amountAfterFee);
        if (fee > 0) {
            _transfer(_msgSender(), LIQUIDITY_POOL_ADDRESS, fee);
            emit FeePaid(_msgSender(), LIQUIDITY_POOL_ADDRESS, fee);
        }

        return true;
    }

    function calculateTransactionFee(uint256 _value) private pure returns (uint256) {
        return _value * 42 / 10000000; // 0.00042% fee
    }

    function calculatePangolinFee(uint256 _value) private pure returns (uint256) {
        return _value * 42 / 1000; // 4.2% fee for Pangolin DEX swaps
    }
}
