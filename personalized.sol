// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol';

contract Burnpfs is ERC721,ERC721Burnable, Ownable {
    uint256 public mintPrice = 0 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isMintEnabled;
    string private _baseTokenURI = "https://peach-worldwide-trout-968.mypinata.cloud/ipfs/QmPAVixDZMWHEoWweiPQQciUvKogvbwSafNF77XgFzPjmE";

        
    constructor(address initialOwner) payable ERC721('complexlityXarbitrum', 'CXA') Ownable(initialOwner){
        maxSupply = 2**256 - 1;
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        require(newPrice >= 0, "Mint price cannot be negative");
        mintPrice = newPrice;
    }

    function toggleIsMintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

     function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _baseTokenURI;
    }

     function setbaseURI(string memory _newBaseURI) external  onlyOwner returns (string memory) {
        return _baseTokenURI = _newBaseURI;
    }
    
     function contractURI() external view returns (string memory) {
        return _baseTokenURI;
    }


    function setMaxSupply(uint _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    function getBaseURI() external view  onlyOwner returns (string memory)  {
        return _baseTokenURI;
    }

    function mint() external payable {
        require(msg.value == mintPrice, "Wrong value");   
        internalMint(msg.sender);
    }
    function mintFor(address user) external onlyOwner {
        internalMint(user);
    }

    function internalMint(address _addr) internal {
        require(isMintEnabled, "Mint must be enabled");
        require(balanceOf(_addr) < 1, "exceeds");
        totalSupply++;
        uint256 tokenId = totalSupply;
        
        _safeMint(_addr, tokenId);
    }

    function withdraw(address _addr) external onlyOwner(){
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }

}