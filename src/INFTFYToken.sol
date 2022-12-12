// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract INFTFYToken is ERC721,  Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    event Mint(
        address indexed creator,
        uint256 indexed id,
        uint256 amount,
        string uri,
        string indexed studioName,
        address customer
    );

    mapping(uint256 => address) public creator;
    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("INFTFYToken", "INFTFY") {}

    function _beforeTokenMint(
        uint256 id,
        uint256 amount,
        string memory _tokenURI
    ) internal view {
        require(creator[id] == address(0), "Token is already minted");
        require(amount != 0, "Amount should be positive");
        require(bytes(_tokenURI).length > 0, "tokenURI should be set");
    }

     function mint(uint256 amount_, string memory uri,string memory studioName, address customer) external  onlyOwner()  returns (bool){
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
 
        _beforeTokenMint(tokenId, amount_, uri);

        creator[tokenId] = msg.sender;

        _setURI(tokenId, uri);

        emit Mint(msg.sender, tokenId, amount_, uri,studioName,customer);

        _safeMint(customer, tokenId);
        return true;
    }
 

    function tokenURI(uint256 tokenId) public  view  override(ERC721)
        returns (string memory)
    {
        return _tokenURIs[tokenId];
    }

     function _setURI(uint256 id, string memory _uri) internal {
        _tokenURIs[id] = _uri;
    }
}
