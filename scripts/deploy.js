// scripts/deploy.js

const { ethers } = require("hardhat");

async function main() {
    // Define the deployer's wallet using a dummy private key
    const deployer = new ethers.Wallet(
        "0x883ab16485d303b64b35d58a04b0d2e0652c472f8d31d8eda426a8346083434b",
        ethers.provider
    );

    console.log("Deploying contract with account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    // Compile and deploy the contract
    const SoulBoundFarmerNFT = await ethers.getContractFactory("SoulBoundFarmerNFT", deployer);
    const contract = await SoulBoundFarmerNFT.deploy();

    await contract.deployed();
    console.log("Contract deployed to address:", contract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
