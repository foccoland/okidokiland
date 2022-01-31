// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**

    @title Interface for allow {OkiDokiLand} usage in this file.
    @author Fabio Giannelli
    @dev Feel free to use it for building on a land

 */

abstract contract OkiDokiLandInterface {
    function getBuildingByLand(uint8 _landId) external view virtual returns(uint8);
    function buildOnLand(uint8 _landId, uint8 _buildingId) virtual external;
}


/**

    @title A buildings factory.
    @author Fabio Giannelli
    @notice Contract usage: buy buildings, transfer them to your address,
    buy lands with single building on it.
    @dev Must be only used from test sidechains, not in production.

 */

contract OkiDokiLandBuilding is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeMath for uint8;

    event BuildingMinted(uint256 tokenId);
    event BuildingAttached(uint256 buildingTokenId, uint256 landTokenId);

    uint8 BUILDINGS_TOTAL_SUPPLY;

    CountersUpgradeable.Counter private _tokenIdCounter;

    mapping(address => uint8) ownerBuildingCount;
    mapping(uint256 => address) getOwnerByBuilding;
    mapping(uint => uint) getLandByBuilding;

    function initialize() initializer public {
        __ERC721_init("OkiDokilandBuilding", "BBLDN");
        __ERC721URIStorage_init();
        __Ownable_init();
        BUILDINGS_TOTAL_SUPPLY = 100;
    }    

    function putBuildingOnLand(uint8 landTokenId, uint8 buildingTokenId) internal {
        // TODO: before deploy get OkiDokiLand contract address!
        address okiDokilandAddr = 0xFcDE9bb746c9D2A89C671C10bdE8e1b2395Dc0C3;
        OkiDokiLandInterface landInterface = OkiDokiLandInterface(okiDokilandAddr);
        landInterface.buildOnLand(landTokenId, buildingTokenId);
    }

    function mintBuilding(address to, string memory uri) public onlyOwner {
        require((_tokenIdCounter.current()) < BUILDINGS_TOTAL_SUPPLY, "Buildings out of stock");
        safeMint(to, uri);
    }

    function buyBuildingOnly(address to, string memory uri) public payable {

    }

    function buyLandAndBuilding(address to, string memory uri) public payable {

    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        emit BuildingMinted(tokenId);
    }

     // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
