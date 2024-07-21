// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Post is ERC721URIStorage{

     
        string tokenuri;
        constructor() ERC721("Web3Gram", "P3") {
        }

        event minted(uint,string);
        
        function settokenuri(string memory _tokenuri) public {
        tokenuri=_tokenuri;
    }

      function tokenURI(uint _tokenId) public view override returns (string memory){
         require(_exists(_tokenId));
        return tokenuri;
    }
      
        function mint(string memory _tokenuri,uint _id,address to) public {
                    _safeMint(to, _id);
                    settokenuri(_tokenuri);    
                    tokenURI(_id);
                    emit minted(_id,_tokenuri);
        }
}