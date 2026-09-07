import {ethers} from "hardhat";
import * as dotenv from "dotenv";

dotenv.config();

async function main() {
    const khdTokenAddress = process.env.KHD_TOKEN_ADDRESS;

    if (!khdTokenAddress || !ethers.isAddress(khdTokenAddress)) {
        throw new Error("KHD_TOKEN_ADDRESS must be a valid deployed token address");
    }
   
    console.log("Otw Terbang nih staking Kehed...");
   
    const stakingKehed = await ethers.deployContract("StakingKehed", [khdTokenAddress]);
    await stakingKehed.waitForDeployment();
   
    console.log(`Staking Kehed (KHD) meluncur di alamat: ${stakingKehed.target}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});