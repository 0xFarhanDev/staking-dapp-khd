/// <reference types="mocha" />

import { time } from "@nomicfoundation/hardhat-toolbox/network-helpers.js";
import { expect } from "chai";
import hre from "hardhat";

describe("StakingKehed", function () {
  async function deployFixture() {
    const [admin, user] = await hre.ethers.getSigners();

    const Token = await hre.ethers.getContractFactory("KehedCoin");
    const token = await Token.deploy();

    const Staking = await hre.ethers.getContractFactory("StakingKehed");
    const staking = await hre.upgrades.deployProxy(
      Staking,
      [token.target, admin.address],
      { initializer: "initialize",
        unsafeAllow: ["constructor"]
       }
    );

    await token.transfer(user.address, hre.ethers.parseEther("1000"));
    await token.connect(user).approve(staking.target, hre.ethers.parseEther("1000"));

    return { admin, user, token, staking };
  }

  it("should send withdrawal fee to the admin, not back to the staker", async function () {
    const { admin, user, token, staking } = await deployFixture();
    const stakeAmount = hre.ethers.parseEther("100");

    await staking.connect(user).stake(stakeAmount);
    await time.increase(30);

    const adminBefore = await token.balanceOf(admin.address);
    const userBefore = await token.balanceOf(user.address);

    await staking.connect(user).withdraw();

    const adminAfter = await token.balanceOf(admin.address);
    const userAfter = await token.balanceOf(user.address);

    const fee = (stakeAmount * 1n) / 100n;
    const principal = stakeAmount - fee;

    expect(adminAfter - adminBefore).to.equal(fee);
    expect(userAfter - userBefore).to.equal(principal);
  });

  it("should prevent reward claims before 60 seconds", async function () {
    const { user, token, staking } = await deployFixture();
    const stakeAmount = hre.ethers.parseEther("100");

    await staking.connect(user).stake(stakeAmount);
    await time.increase(30);

    await expect(staking.connect(user).claimReward()).to.be.revertedWith(
      "Sabar Blegugg, Belum 60 detik udah mau Claim lagi aja"
    );

    const userBalanceAfter = await token.balanceOf(user.address);
    expect(userBalanceAfter).to.equal(hre.ethers.parseEther("900"));
  });
});
