import {ethers} from "hardhat";

async function main() {
    const Kehed = await ethers.deployContract("KehedCoin");
    await Kehed.waitForDeployment();

    console.log(`Blegug sia Koin Kehed (KHD) meluncur di alamat: ${Kehed.target}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
