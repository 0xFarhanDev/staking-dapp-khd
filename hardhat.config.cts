import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox"; // Ini yang bikin kita gak perlu import ethers manual lagi
import "@openzeppelin/hardhat-upgrades";
import * as dotenv from "dotenv";

dotenv.config();

const privateKey = process.env.PRIVATE_KEY?.trim();
const normalizedPrivateKey = privateKey
  ? privateKey.startsWith("0x")
    ? privateKey
    : `0x${privateKey}`
  : undefined;

const config: any = {
  solidity: "0.8.28", // Pastikan versi ini sama dengan versi di dalam file .sol lu
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_URL || process.env.ALCHEMY_RPC_URL || "https://rpc.sepolia.org",
      accounts: normalizedPrivateKey ? [normalizedPrivateKey] : [],
    },
    baseSepolia: {
      url: "https://sepolia.base.org",
      accounts: normalizedPrivateKey ? [normalizedPrivateKey] : [],
    },
  },
  etherscan: {
    apiKey: process.env.BASESCAN_API_KEY || process.env.ETHERSCAN_API_KEY || "NKWQU6AJYV57DC7WIWDU8BCBNSJPT9DVX6",
      },
  sourcify: {
    enabled: false
      }
  };

export default config;