// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Cannacoin is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** 18);
    address public liquidityPoolAddress;

    // Pangolin Exchange Addresses
    address public constant PANGOLIN_FACTORY = 0xefa94DE7a4656D787667C749f7E1223D71E9FD88;
    address public constant PANGOLIN_ROUTER = 0xE54Ca86531e17Ef3616d22Ca28b0D458b6C89106;

    event FeePaid(address indexed from, address indexed to, uint256 feeAmount);
    event LiquidityPoolAddressChanged(address indexed oldAddress, address indexed newAddress);

    constructor(address _liquidityPoolAddress) 
        ERC20("Cannacoin PRO", "CPRO") 
        Ownable(0x8114BeC86C8F56c1014f590E05cD7826054EcBdE) {
        
        require(_liquidityPoolAddress != address(0), "Liquidity pool address cannot be zero");
        liquidityPoolAddress = _liquidityPoolAddress;
        _mint(_liquidityPoolAddress, INITIAL_SUPPLY);
    }

    function updateLiquidityPoolAddress(address _newAddress) public onlyOwner {
        require(_newAddress != address(0), "New address cannot be the zero address");
        emit LiquidityPoolAddressChanged(liquidityPoolAddress, _newAddress);
        liquidityPoolAddress = _newAddress;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // Check if transaction involves Pangolin Exchange
        if (msg.sender == PANGOLIN_ROUTER || recipient == PANGOLIN_ROUTER || 
            msg.sender == PANGOLIN_FACTORY || recipient == PANGOLIN_FACTORY) {
            
            uint256 fee = calculateFee(amount);
            uint256 amountAfterFee = amount - fee;
            
            require(amount == amountAfterFee + fee, "Fee calculation error");
            _transfer(_msgSender(), recipient, amountAfterFee);
            if (fee > 0) {
                _transfer(_msgSender(), liquidityPoolAddress, fee);
            }
            emit FeePaid(_msgSender(), liquidityPoolAddress, fee);
        } else {
            _transfer(_msgSender(), recipient, amount);
        }

        return true;
    }

    function calculateFee(uint256 _value) private pure returns (uint256) {
        return _value * 42 / 1000; // 4.2% fee
    }
}
