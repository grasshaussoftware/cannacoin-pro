// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CannaCoinProFees is ERC20, Ownable {
    address public constant FEE_ADDRESS =
        0x3536b0152c91E60535508690a650C10bf09fe857;
    address public constant PANGOLIN_ROUTER =
        0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106;
    address public constant TRADER_JOE_ROUTER =
        0x60aE616a2155Ee3d9A68541Ba4544862310933d4;
    address public constant YETISWAP_ROUTER =
        0x262DcFB36766C88E6A7a2953c16F8defc40c378A;

    event FeePaid(address indexed from, address indexed to, uint256 feeAmount);

    constructor() ERC20("Cannacoin PRO", "CPRO") Ownable(msg.sender) {}

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        uint256 fee = 0;
        if (isDexTransaction(msg.sender, recipient)) {
            fee = calculateDexFee(amount);
        }
        uint256 amountAfterFee = amount - fee;
        _transfer(_msgSender(), recipient, amountAfterFee);
        if (fee > 0) {
            _transfer(_msgSender(), FEE_ADDRESS, fee);
            emit FeePaid(_msgSender(), FEE_ADDRESS, fee);
        }
        return true;
    }

    function isDexTransaction(
        address sender,
        address recipient
    ) private pure returns (bool) {
        return
            sender == PANGOLIN_ROUTER ||
            recipient == PANGOLIN_ROUTER ||
            sender == TRADER_JOE_ROUTER ||
            recipient == TRADER_JOE_ROUTER ||
            sender == YETISWAP_ROUTER ||
            recipient == YETISWAP_ROUTER;
    }

    function calculateDexFee(uint256 _value) private pure returns (uint256) {
        return (_value * 42) / 1000;
    }
}
