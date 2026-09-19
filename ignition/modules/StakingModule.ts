import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("StakingModule", (m) => {
  const tokenAddress = "0x26E0B47471293cB01bfbE058bFB14939733BFb09";

  const staking = m.contract("StakingKehed", [tokenAddress]);

  return { staking };
});