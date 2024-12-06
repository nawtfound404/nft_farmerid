require('dotenv').config();
const { ethers } = require("hardhat");

async function main() {
    // Set up the provider
    const provider = new ethers.providers.JsonRpcProvider("http://localhost:8545");

    // Private keys for Ganache accounts
    const privateKey1 = "0xb7ae085a1ebff554e69dae8e4c37ab16dcfa41c4f8d05248cae6fdb32eb796e7";
    const privateKey2 = "0xc86c1c75135347ac2353bb917f1416f450befb7dc615f3311e49bafea4ab6ac7";

    // Signers
    const signer1 = new ethers.Wallet(privateKey1, provider);
    const signer2 = new ethers.Wallet(privateKey2, provider);

    // Your deployed contract address
    const contractAddress = "0x030300790864b14AaF582C181620Ac26C0700508"; 

    // Create a contract instance
    const SoulBoundFarmerNFT = await ethers.getContractFactory("SoulBoundFarmerNFT");
    const soulBoundNFT = SoulBoundFarmerNFT.attach(contractAddress);

    // Mint a new Farmer NFT
    async function mintFarmerNFT(
        signer, recipient, subsidyType, subsidyAmount, issueDate, validityPeriod, 
        governmentApprovalId, usageStatus, farmerSignature, governmentSignature, location
    ) {
        console.log(`Minting NFT for ${recipient}...`);
        const contractWithSigner = soulBoundNFT.connect(signer);
        const tx = await contractWithSigner.mintFarmerNFT(
            recipient, subsidyType, subsidyAmount, issueDate, validityPeriod, 
            governmentApprovalId, usageStatus, farmerSignature, governmentSignature, location
        );
        console.log("Transaction submitted. Waiting for confirmation...");

        const receipt = await tx.wait();
        console.log(`NFT minted with transaction hash: ${receipt.transactionHash}`);
    }

    // Fetch details of a specific Farmer NFT by tokenId
    async function getFarmerNFT(signer, tokenId) {
        console.log(`Fetching details for Farmer NFT with Token ID ${tokenId}...`);
        const farmerNFTDetails = await soulBoundNFT.connect(signer).getFarmerNFT(tokenId);
        console.log("Farmer NFT Details:", farmerNFTDetails);
    }

    // Simulate downloading Farmer NFT data as a string
    async function downloadFarmerNFTData(signer, tokenId) {
        console.log(`Downloading data for Farmer NFT with Token ID ${tokenId}...`);
        const data = await soulBoundNFT.connect(signer).downloadFarmerNFTData(tokenId);
        console.log("Farmer NFT Data:", data);
    }

    // Mint a new Farmer NFT with sample data
    const recipient = "0xa84d0D1527607F9961E6981d3902E561850352C3";
    const subsidyType = "Seed";
    const subsidyAmount = 1000;
    const issueDate = 1640995200; // Unix timestamp format (for example)
    const validityPeriod = 365; // Period in days
    const governmentApprovalId = "GOVAPPROVAL123";
    const usageStatus = "Unused";
    const farmerSignature = "FarmerSignatureSample";
    const governmentSignature = "GovernmentSignatureSample";
    const location = "Village XYZ";

    await mintFarmerNFT(signer1, recipient, subsidyType, subsidyAmount, issueDate, validityPeriod, governmentApprovalId, usageStatus, farmerSignature, governmentSignature, location);

    // Fetch and display the minted Farmer NFT details (Assuming tokenId 0)
    await getFarmerNFT(signer1, 0);

    // Download Farmer NFT data (Assuming tokenId 0)
    await downloadFarmerNFTData(signer1, 0);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
