// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract StakingKehed is Ownable, Pausable, ReentrancyGuard {

    IERC20 public khdToken;
    uint256 public constant LOCK_DURATION = 60 seconds;
    uint256 public maxStakePerUser = 5000 * 10 ** 18;
    uint256 public withdrawalFeePercentage = 1;

    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public stakeTimestamp;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public lastClaimTimestamp;

    event Staked(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawn(address indexed user, uint256 amount, uint256 feeAmount, uint256 timestamp);
    event RewardClaimed(address indexed user, uint256 amount, uint256 timestamp);
    event Compounded(address indexed user, uint256 amount, uint256 timestamp);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        khdToken = IERC20(_tokenAddress);
    }
     function pause() external onlyOwner {
        _pause();
     }
     function unpause() external onlyOwner {
        _unpause();
     }
     function emergancyWithdrawToken(uint256 amount) external onlyOwner {
        khdToken.transfer(owner(), amount);
     }

    function stake(uint256 _amount) external whenNotPaused nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(
            stakedBalances[msg.sender] + _amount <= maxStakePerUser,
            "Kebanyakan KHD."
        );
    
        stakeTimestamp[msg.sender] = block.timestamp;

        if (stakedBalances[msg.sender] == 0) {
        lastClaimTimestamp[msg.sender] = block.timestamp;
        }

        khdToken.transferFrom(msg.sender, address(this), _amount);
        stakedBalances[msg.sender] += _amount;

        emit Staked(msg.sender, _amount, block.timestamp);

    }
    function calculateRewards(address user) public view returns (uint256) {
        if (stakedBalances[user] == 0) return 0;
        return (stakedBalances[user] * 10) / 100;
    }

    function withdraw() external whenNotPaused nonReentrant {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "Saldo Kurang Blegug");
        
        uint256 reward = 0;
        if (block.timestamp >= lastClaimTimestamp[msg.sender] + 60 seconds) {
            reward = calculateRewards(msg.sender);
        }
        stakedBalances[msg.sender] = 0;
        lastClaimTimestamp[msg.sender] = 0;

        uint256 feeAmount = (stakedAmount * withdrawalFeePercentage) / 100;
        uint256 amountToUser = stakedAmount - feeAmount;

        require(
            khdToken.transfer(owner(), feeAmount),
            "Gagal Kirim Pajak ke Owner"
        );
        require(
            khdToken.transfer(msg.sender, amountToUser), 
            "Gagal kembaliin Modal");
            if (reward > 0) {
                require(khdToken.transfer(msg.sender, reward), "Gagal kirim reward");
                emit RewardClaimed(msg.sender, reward, block.timestamp);
            }

        emit Withdrawn(msg.sender, amountToUser, feeAmount, block.timestamp);
    }

    function claimReward() external whenNotPaused nonReentrant {
        uint256 reward = (stakedBalances[msg.sender] * 10) / 100;
        require(reward > 0, "Lu gak punya saldo yang di stake Blegug");
        require(
            khdToken.balanceOf(address(this)) >= reward,
            "Saldo reward staking tidak cukup"
        );
        require(
            block.timestamp >= lastClaimTimestamp[msg.sender] + 60 seconds,
            "Sabar Blegugg, Belum 60 detik udah mau Claim lagi aja"
        );
    
        lastClaimTimestamp[msg.sender] = block.timestamp;

        khdToken.transfer(msg.sender, reward);

        emit RewardClaimed(msg.sender, reward, block.timestamp);
    }

    function autoCompound() external whenNotPaused nonReentrant{
        uint256 reward = (stakedBalances[msg.sender] * 10) / 100;
        require(reward > 0, "Gak ada reward yang di-compound");
        require(
            khdToken.balanceOf(address(this)) >= reward,
            "Saldo reward staking tidak cukup"
        );
        require(
            block.timestamp >= lastClaimTimestamp[msg.sender] + 60 seconds,
            "Kalo mau Sugih Harus Sabar,Belum 60 detik"
        );
        
        lastClaimTimestamp[msg.sender] = block.timestamp;

        stakedBalances[msg.sender] += reward;
        
        emit Compounded(msg.sender, reward, block.timestamp);
    }
    function updadeMaxStake(uint256 _newMax) external onlyOwner {
        maxStakePerUser = _newMax;
    }
}