// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingKehed {

    IERC20 public khdToken;
    uint256 public constant LOCK_DURATION = 60 seconds;

    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public stakeTimestamp;
    mapping(address => uint256) public rewards;

    constructor(address _tokenAddress) {
        khdToken = IERC20(_tokenAddress);
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        if (stakedBalances[msg.sender] == 0) {
            stakeTimestamp[msg.sender] = block.timestamp;
        }
        khdToken.transferFrom(msg.sender, address(this), _amount);
        stakedBalances[msg.sender] += _amount;

    }

    function withdraw(uint256 amount) external {
        require(stakedBalances[msg.sender] >= amount, "Saldo Kurang Blegug");

        require(
            block.timestamp >= stakeTimestamp[msg.sender] + LOCK_DURATION,
            "Masih Lock Blegug, sabar ya"
        );
        stakedBalances[msg.sender] -= amount;
        khdToken.transfer(msg.sender, amount);
    }

    function claimReward() external {
        uint256 reward = (stakedBalances[msg.sender] * 10) / 100;
        require(reward > 0, "Lu gak punya saldo yang di stake Blegug");

        khdToken.transfer(msg.sender, reward);
    }
    function autoCompound() external {
        uint256 reward = (stakedBalances[msg.sender] * 10) / 100;
        require(reward > 0, "Gak ada reward yang di-compound");
        stakedBalances[msg.sender] += reward;
    }
}