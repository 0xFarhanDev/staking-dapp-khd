import { ethers } from "hardhat";

async function main() {
  console.log("Mulai deploy contract ke Base Sepolia...")
  // Ganti "HelloWorld" dengan nama contract lu kalau beda
  const KHD = await ethers.getContractFactory("KehedCoin");
  const khd = await KHD.deploy();
  await khd.waitForDeployment();
  const khdAddress = await khd.getAddress();
  console.log(`Token Berhasil di deploy ke alamat: ${khdAddress}`);
  
  const Staking = await ethers.getContractFactory("StakingKehed");
  const staking = await Staking.deploy(khdAddress);
  await staking.waitForDeployment();

  const stakingAddress = await staking.getAddress();
  console.log(`Staking kehed berhasil di deploy ke alamat ${stakingAddress}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});