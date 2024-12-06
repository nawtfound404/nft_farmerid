// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SoulBoundFarmerNFT is ERC721 {
    uint256 private farmerIdCounter;
    address private _owner;
    mapping(uint256 => bool) private _soulBoundTokens;
    mapping(uint256 => bool) private _farmerExists;

    struct Farmer {
        uint256 farmerId;
        string subsidyType;
        uint256 subsidyAmount;
        uint256 issueDate;
        uint256 validityPeriod;
        string governmentApprovalId;
        string usageStatus;
        string farmerSignature;
        string governmentSignature;
        string location;
        address owner;
    }

    Farmer[] public allFarmers;
    mapping(address => Farmer[]) public farmerRecords;

    event FarmerNFTMinted(uint256 indexed farmerId, address indexed owner, string subsidyType);

    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    constructor() ERC721("SoulBoundFarmerNFT", "SBFNFT") {
        _owner = msg.sender;
    }

    // Mint a new soul-bound NFT for a farmer
    function mintFarmerNFT(
        address recipient,
        string memory subsidyType,
        uint256 subsidyAmount,
        uint256 issueDate,
        uint256 validityPeriod,
        string memory governmentApprovalId,
        string memory usageStatus,
        string memory farmerSignature,
        string memory governmentSignature,
        string memory location
    ) public returns (uint256) {
        uint256 newFarmerId = farmerIdCounter++;
        _mint(recipient, newFarmerId);
        _farmerExists[newFarmerId] = true;

        Farmer memory newFarmer = Farmer({
            farmerId: newFarmerId,
            subsidyType: subsidyType,
            subsidyAmount: subsidyAmount,
            issueDate: issueDate,
            validityPeriod: validityPeriod,
            governmentApprovalId: governmentApprovalId,
            usageStatus: usageStatus,
            farmerSignature: farmerSignature,
            governmentSignature: governmentSignature,
            location: location,
            owner: recipient
        });

        allFarmers.push(newFarmer);
        farmerRecords[recipient].push(newFarmer);
        _soulBoundTokens[newFarmerId] = true;

        emit FarmerNFTMinted(newFarmerId, recipient, subsidyType);

        return newFarmerId;
    }

    // Fetch details of a specific Farmer NFT by farmerId
    function getFarmerNFT(uint256 farmerId) public view returns (Farmer memory) {
        require(_farmerExists[farmerId], "Farmer does not exist");
        return allFarmers[farmerId];
    }

    // Simulate downloading data as a string for a specific farmerId
    function downloadFarmerNFTData(uint256 farmerId) public view returns (string memory) {
        require(_farmerExists[farmerId], "Farmer does not exist");

        Farmer memory farmer = allFarmers[farmerId];

        // Create a string with the farmer details to simulate download
        return string(
            abi.encodePacked(
                "Farmer ID: ", uint2str(farmer.farmerId), 
                ", Subsidy Type: ", farmer.subsidyType,
                ", Subsidy Amount: ", uint2str(farmer.subsidyAmount),
                ", Issue Date: ", uint2str(farmer.issueDate),
                ", Validity Period: ", uint2str(farmer.validityPeriod),
                ", Government Approval ID: ", farmer.governmentApprovalId,
                ", Usage Status: ", farmer.usageStatus,
                ", Farmer Signature: ", farmer.farmerSignature,
                ", Government Signature: ", farmer.governmentSignature,
                ", Location: ", farmer.location,
                ", Owner: ", toAsciiString(farmer.owner)
            )
        );
    }

    // Custom transfer function, preventing soul-bound NFT transfers
    function customTransfer(address from, address to, uint256 farmerId) public {
        require(!_soulBoundTokens[farmerId], "This token is soul-bound and cannot be transferred.");
        transferFrom(from, to, farmerId);
    }

    // Helper function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // Helper function to convert address to ASCII string
    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(42);
        s[0] = '0';
        s[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint160(x) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i + 2] = char(hi);
            s[2*i + 3] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
