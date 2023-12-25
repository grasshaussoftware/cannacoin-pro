// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Cannacoin
 * @dev ERC20 Token with a custom transfer function to support a transfer fee, total supply of 100 million.
 */
contract Cannacoin is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);
    address public liquidityPoolAddress;

    event FeePaid(address indexed from, address indexed to, uint256 feeAmount);
    event LiquidityPoolAddressChanged(address indexed oldAddress, address indexed newAddress);

    constructor(address _liquidityPoolAddress) ERC20("Cannacoin PRO", "CPRO") Ownable(_liquidityPoolAddress) {
        require(_liquidityPoolAddress != address(0), "Liquidity pool address cannot be zero");
        liquidityPoolAddress = _liquidityPoolAddress;
        _mint(_liquidityPoolAddress, INITIAL_SUPPLY);
    }

    function updateLiquidityPoolAddress(address _newAddress) public onlyOwner {
        require(_newAddress != address(0), "New address cannot be the zero address");
        emit LiquidityPoolAddressChanged(liquidityPoolAddress, _newAddress);
        liquidityPoolAddress = _newAddress;
    }

    // Custom transfer function with fee
    function transferWithFee(address recipient, uint256 amount) public returns (bool) {
        uint256 fee = calculateFee(amount);
        uint256 amountAfterFee = amount - fee;
        
        require(amount == amountAfterFee + fee, "Fee calculation error");
        _transfer(_msgSender(), recipient, amountAfterFee);
        if (fee > 0) {
            _transfer(_msgSender(), liquidityPoolAddress, fee);
        }
        emit FeePaid(_msgSender(), liquidityPoolAddress, fee);

        return true;
    }

    function calculateFee(uint256 _value) private pure returns (uint256) {
        return _value * 42 / 1000; // 4.2% fee
    }
}
