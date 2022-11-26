// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract INFTFYToken is Initializable, ERC1155Upgradeable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;

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

    function initialize() public initializer {
        __ERC1155_init("");
        __Ownable_init();
    }

    function _beforeTokenMint(
        uint256 id,
        uint256 amount,
        string memory _tokenURI
    ) internal view {
        require(creator[id] == address(0), "Token is already minted");
        require(amount != 0, "Amount should be positive");
        require(bytes(_tokenURI).length > 0, "tokenURI should be set");
    }

    function mint(uint256 amount_, string memory tokenURI,string memory studioName, address customer) external  onlyOwner()  returns (bool){
        _tokenIds.increment();
        uint256 id_ = _tokenIds.current();
        _beforeTokenMint(id_, amount_, tokenURI);

        creator[id_] = msg.sender;

        _setURI(id_, tokenURI);

        emit Mint(msg.sender, id_, amount_, tokenURI,studioName,customer);

        _mint(customer, id_, amount_, "");

        return true;
    }

     function uri(uint256 id)
        public
        view
        override(ERC1155Upgradeable)
        returns (string memory)
    {
        return _tokenURIs[id];
    }

    function _setURI(uint256 id, string memory _uri) internal {
        _tokenURIs[id] = _uri;
    }

}
