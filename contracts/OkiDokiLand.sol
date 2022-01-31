// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./OkiDokiLandBuilding.sol";

/**

    @title A land factory.
    @author Fabio Giannelli
    @notice Contract usage: buy land, transfer them to your address.
    It's possible to buy land with building on it.
    Latter feature is available through {OkiDokiLandBuilding} contract.
    @dev Must be only used from test sidechains, not in production.

 */

contract OkiDokiLand is Initializable, 
    ERC721Upgradeable, 
    ERC721URIStorageUpgradeable, 
    OwnableUpgradeable {

    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeMath for uint8;

    event LandMinted(uint256 tokenId, uint8 x, uint8 y);

    uint8 MAX_LANDS_PER_DIM;
    uint8 LANDS_TOTAL_SUPPLY;
    
    CountersUpgradeable.Counter private _tokenIdCounter;
    uint8 x_offset;
    uint8 y_offset;

    // @dev: takes land, returns building
    mapping(uint8 => uint8) _getBuildingByLand;

    /**
        @dev Used once, for initial contract deployment. Not callably by anyone. 
        See {Initializable.sol} for details.
     */
    function initialize() initializer public {
        __ERC721_init("OkiDokiLand", "OKL");
        __ERC721URIStorage_init();
        __Ownable_init();
        MAX_LANDS_PER_DIM = 8;
        LANDS_TOTAL_SUPPLY = 64;
    }

    /**
        @dev A getter for building attached to a land.
        @param _landId land id
        @return the relative building id
     */
    function getBuildingByLand(uint8 _landId) public view returns(uint8) {
        return _getBuildingByLand[_landId];
    }

    /**
        @dev Builds building on a land. Callable from OkiDokiLandBuilding.
        @param _landId land id
        @param _buildingId building id
     */
    function buildOnLand(uint8 _landId, uint8 _buildingId) external onlyOwner {
        require(_getBuildingByLand[_landId] != _buildingId);
        _getBuildingByLand[_landId] = _buildingId;
    }

    /**
        @notice Public method for buying a land.
        @param uri land's URI
     */
    function buyLand(string memory uri) public payable {
        require(msg.value >= 0.02 ether);
        if (msg.value > 0.02 ether) {
            payable(msg.sender).transfer(msg.value - 0.02 ether);
        }
        address contractOwnerAddress = 0xE311D8babA1324348D972fa3F3A2D115b677b15A;
        payable(contractOwnerAddress).transfer(0.5 ether);
        mintLand(msg.sender, uri);
    }

    /**
        @dev Builds a building on a land. Called from:
             - {OkiDokiLand.buyLand}
             - {OkiDokiLandBuilding.buyLandAndBuilding}
             It's visibility is public due to allow OkiDokiLandBuilding 
             (that's not directly inheriting OkiDokiLand) calling.
        @param to land destination address
        @param uri land's URI
     */
    function mintLand(address to, string memory uri) public onlyOwner {
        require(_tokenIdCounter.current() < LANDS_TOTAL_SUPPLY, "Sorry, out of stock");
        require(y_offset < MAX_LANDS_PER_DIM, "Sorry, out of stock");

        /// @dev Verify x axis threshold
        if (x_offset < MAX_LANDS_PER_DIM) {

            /// @dev Verify y axis threshold
            safeMint(to, uri);
        } else {

            /**
                @dev If x hits axis threshold, let's verify for y.
                If y hits threshold too, it means that we reached max total supply.
             */ 
            require(y_offset < MAX_LANDS_PER_DIM, "Sorry, out of stock");
            resetXandIncrementY();
            safeMint(to, uri);
        }
    }

    /**
        @dev Updates the land matrix whenever "hits" the x axis threshold.
     */
    function resetXandIncrementY() private {
        x_offset = 0;
        y_offset.tryAdd(1);
    }

    /**
        @dev safe minting of a land. Private.
        @param to land's destination address
        @param uri land's URI
     */
    function safeMint(address to, string memory uri) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        emit LandMinted(tokenId, x_offset, y_offset);
        x_offset.tryAdd(1);
    }


    /// @dev The following functions are overrides required by Solidity.

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