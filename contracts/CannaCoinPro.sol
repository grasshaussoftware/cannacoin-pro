// CannaCoinPro.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CannaCoinPro is ERC20, ReentrancyGuard, Ownable {
    uint256 public constant TOTAL_SUPPLY = 100000000 * 10**18; // 100 million tokens with 18 decimals

    address public constant DEPLOYER_ADDRESS = 0x8114BeC86C8F56c1014f590E05cD7826054EcBdE;
    address public constant POOL_ADDRESS = 0x3536b0152c91E60535508690a650C10bf09fe857;
    address public constant PANGOLIN_ROUTER = 0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106; // address verified 12-26-2023
    address public constant TRADER_JOE_ROUTER = 0x60aE616a2155Ee3d9A68541Ba4544862310933d4; // address verified 12-26-2023
    address public constant YETISWAP_ROUTER = 0x262DcFB36766C88E6A7a2953c16F8defc40c378A; // address verified 12-26-2023
    

    event FeePaid(address indexed from, address indexed to, uint256 feeAmount);

    constructor() ERC20("CannacoinPRO", "CPRO") Ownable(msg.sender) {
        _mint(DEPLOYER_ADDRESS, 1000000 * 10**18); // Mint 1 million tokens to DEPLOYER_ADDRESS
        _mint(POOL_ADDRESS, 99000000 * 10**18);    // Mint 99 million tokens to POOL_ADDRESS
    }

    function transfer(address recipient, uint256 amount) public override nonReentrant returns (bool) {
        uint256 fee = isDexTransaction(_msgSender(), recipient) ? calculateDexFee(amount) : calculateStandardFee(amount);
        uint256 amountAfterFee = amount;
        if (fee > 0) {
            require(balanceOf(_msgSender()) >= fee, "Insufficient balance for fee");
            _transfer(_msgSender(), POOL_ADDRESS, fee);
            emit FeePaid(_msgSender(), POOL_ADDRESS, fee);
            amountAfterFee = amount - fee;
        }
        _transfer(_msgSender(), recipient, amountAfterFee);
        return true;
    }

    function isDexTransaction(address sender, address recipient) private pure returns (bool) {
        return sender == PANGOLIN_ROUTER || recipient == PANGOLIN_ROUTER ||
               sender == TRADER_JOE_ROUTER || recipient == TRADER_JOE_ROUTER ||
               sender == YETISWAP_ROUTER || recipient == YETISWAP_ROUTER;
    }

    function calculateDexFee(uint256 _value) private pure returns (uint256) {
        return (_value * 42) / 1000; // 4.2% fee
    }

    function calculateStandardFee(uint256 _value) private pure returns (uint256) {
        return (_value * 42) / 1000000; // 0.00042% fee
    }
}
