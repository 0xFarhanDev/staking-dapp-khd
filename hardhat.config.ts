import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox"; // Ini yang bikin kita gak perlu import ethers manual lagi
import * as dotenv from "dotenv";

dotenv.config();

const privateKey = process.env.PRIVATE_KEY?.trim();
const normalizedPrivateKey = privateKey
  ? privateKey.startsWith("0x")
    ? privateKey
    : `0x${privateKey}`
  : undefined;

const config: HardhatUserConfig = {
  solidity: "0.8.28", // Pastikan versi ini sama dengan versi di dalam file .sol lu
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_URL || process.env.ALCHEMY_RPC_URL || "",
      accounts: normalizedPrivateKey ? [normalizedPrivateKey] : [],
    },
    baseSepolia: {
      url: "https://sepolia.base.org",
      accounts: normalizedPrivateKey ? [normalizedPrivateKey] : [],
    }
  }
};

export default config;