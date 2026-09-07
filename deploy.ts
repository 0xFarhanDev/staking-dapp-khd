import { ethers } from "hardhat";

async function main() {
  // Ganti "HelloWorld" dengan nama contract lu kalau beda
  const HelloWorld = await ethers.getContractFactory("HelloWorld");
  
  console.log("Mulai deploy contract ke Sepolia...");
  const helloWorld = await HelloWorld.deploy("Halo dari proyek baru!");

  // Tunggu sampai proses deploy selesai di blockchain
  await helloWorld.waitForDeployment();

  console.log(`Contract berhasil di-deploy ke alamat: ${await helloWorld.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});