// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyIPFSNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public maxNFTs;
    uint256 public remainingMintableNFTs;

    struct myNFT {
        address owner;
        string tokenURI;
        uint256 tokenId;
    }
    
    myNFT [] public nftCollection;

    event NewFilecoinNFTMinted(address sender, uint256 tokenId, string tokenURI);
    event RemainingMintableNFTChange(uint256 remainingMintableNFTs);

    constructor() ERC721 ("Napa Workshop", "Filecoin Starter NFTs") {
        console.log("This is my NFT contract");
        maxNFTs=100;
    }

    function mintMyNFT(string memory ipfsURI) public {
        require(_tokenIds.current() < maxNFTs);
        uint256 newItemId = _tokenIds.current();

        myNFT memory newNFT = myNFT ({
            owner: msg.sender,
            tokenURI: ipfsURI,
            tokenId: newItemId
        });

        _safeMint(msg.sender, newItemId);
    
        _setTokenURI(newItemId, ipfsURI);
    
        _tokenIds.increment();

        remainingMintableNFTs = maxNFTs-_tokenIds.current();

        nftCollection.push(newNFT);

        emit NewFilecoinNFTMinted(msg.sender, newItemId, ipfsURI);
        emit RemainingMintableNFTChange(remainingMintableNFTs);
    }

    function getNFTCollection() public view returns (myNFT [] memory) {
        return nftCollection;
    }

    function getRemainingMintableNFTs() public view returns (uint256) {
        return remainingMintableNFTs;
    }
}