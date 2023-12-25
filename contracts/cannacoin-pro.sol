// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Cannacoin is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);
    address public constant FEE_ADDRESS = 0x8114BeC86C8F56c1014f590E05cD7826054EcBdE;

    // Pangolin Exchange Addresses
    address public constant PANGOLIN_FACTORY = 0xefa94DE7a4656D787667C749f7E1223D71E9FD88;
    address public constant PANGOLIN_ROUTER = 0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106;

    event FeePaid(address indexed from, address indexed to, uint256 feeAmount);

    constructor() ERC20("Cannacoin PRO", "CPRO") Ownable(msg.sender) {
        _mint(FEE_ADDRESS, INITIAL_SUPPLY);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = 0;
        if (msg.sender == PANGOLIN_FACTORY || recipient == PANGOLIN_FACTORY ||
            msg.sender == PANGOLIN_ROUTER || recipient == PANGOLIN_ROUTER) {
            fee = calculateFee(amount);
            uint256 amountAfterFee = amount - fee;
            require(amount == amountAfterFee + fee, "Fee calculation error");
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

    function calculateFee(uint256 _value) private pure returns (uint256) {
        return _value * 42 / 10000; // 0.42% fee
    }
}
