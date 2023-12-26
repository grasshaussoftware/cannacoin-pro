// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Cannacoin is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);
    address public constant FEE_ADDRESS = 0x8114BeC86C8F56c1014f590E05cD7826054EcBdE;

    // DEX Addresses
    address public constant PANGOLIN_FACTORY = 0xefa94DE7a4656D787667C749f7E1223D71E9FD88;
    address public constant PANGOLIN_ROUTER = 0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106;
    address public constant TRADER_JOE_ROUTER = 0xYourTraderJoeRouterAddress; // Replace with Trader Joe Router address
    address public constant YETISWAP_ROUTER = 0xYourYetiSwapRouterAddress; // Replace with YetiSwap Router address

    event FeePaid(address indexed from, address indexed to, uint256 feeAmount);

    constructor() ERC20("Cannacoin PRO", "CPRO") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = 0;
        if (isDexTransaction(msg.sender, recipient)) {
            fee = calculateDexFee(amount); // 4.2% fee for DEX transactions
            uint256 amountAfterFee = amount - fee;
            _transfer(_msgSender(), recipient, amountAfterFee);
        } else {
            _transfer(_msgSender(), recipient, amount);
        }

        if (fee > 0) {
            _transfer(_msgSender(), FEE_ADDRESS, fee);
            emit FeePaid(_msgSender(), FEE_ADDRESS, fee);
        }

        return true;
    }

    function isDexTransaction(address sender, address recipient) private view returns (bool) {
        return sender == PANGOLIN_FACTORY || recipient == PANGOLIN_FACTORY ||
               sender == PANGOLIN_ROUTER || recipient == PANGOLIN_ROUTER ||
               sender == TRADER_JOE_ROUTER || recipient == TRADER_JOE_ROUTER ||
               sender == YETISWAP_ROUTER || recipient == YETISWAP_ROUTER;
    }

    function calculateDexFee(uint256 _value) private pure returns (uint256) {
        return _value * 42 / 1000; // 4.2% fee
    }
}
