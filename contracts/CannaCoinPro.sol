// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CannaCoinPro is ERC20, Ownable {
    uint256 public constant TOTAL_SUPPLY = 100000000 * 10**18; // 100 million tokens

    address public constant DEPLOYER_ADDRESS = 0x8114BeC86C8F56c1014f590E05cD7826054EcBdE;
    address public constant POOL_ADDRESS = 0x3536b0152c91E60535508690a650C10bf09fe857;

    mapping(address => uint256) private _lockedBalances;
    mapping(address => uint256) private _unlockTimes;

    event LockedTokensReleased(address indexed account, uint256 amount);

    constructor() ERC20("CannacoinPRO", "CPRO") Ownable(msg.sender) {
        _lockedBalances[DEPLOYER_ADDRESS] = 1000000 * 10**18; // Lock 1 million tokens
        _unlockTimes[DEPLOYER_ADDRESS] = block.timestamp + 365 days;

        _mint(POOL_ADDRESS, TOTAL_SUPPLY - _lockedBalances[DEPLOYER_ADDRESS]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(_isUnlocked(msg.sender, amount), "CannaCoinPro: transfer amount exceeds unlocked balance");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(_isUnlocked(sender, amount), "CannaCoinPro: transfer amount exceeds unlocked balance");
        return super.transferFrom(sender, recipient, amount);
    }

    function releaseLockedTokens() public {
        require(block.timestamp >= _unlockTimes[msg.sender], "CannaCoinPro: tokens are still locked");
        uint256 amount = _lockedBalances[msg.sender];
        require(amount > 0, "CannaCoinPro: no locked tokens to release");

        _lockedBalances[msg.sender] = 0;
        _unlockTimes[msg.sender] = 0;
        _mint(msg.sender, amount);
        emit LockedTokensReleased(msg.sender, amount);
    }

    function lockedBalanceOf(address account) public view returns (uint256) {
        return _lockedBalances[account];
    }

    function unlockTimeOf(address account) public view returns (uint256) {
        return _unlockTimes[account];
    }

    function _isUnlocked(address account, uint256 amount) private view returns (bool) {
        uint256 unlockedBalance = balanceOf(account) - _lockedBalances[account];
        return amount <= unlockedBalance;
    }
}