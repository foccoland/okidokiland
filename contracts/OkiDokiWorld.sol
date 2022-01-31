// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract OkiDokiWorld is Initializable, ERC1155Upgradeable, OwnableUpgradeable, ERC1155BurnableUpgradeable {

    using SafeMath for uint;
    
    uint256 public constant LAND = 0;
    uint256 public constant BUILDING = 1;

    uint16 TOTAL_SUPPLY_EACH;

    /// @dev total supply for lands and buildings (the same)
    uint[] private supplies;

    /// @dev initial minted amount of lands and buildings
    uint[] private minted;

    /// @dev prices for lands and buildings
    uint[] private prices;

    function initialize() initializer public {
        __ERC1155_init("https://gateway.pinata.cloud/ipfs/QmUx24Fu7XGvhi1gFEgWcCy7i6BFUtej4pHqBMwuvHCM8p/{id}.json");
        __Ownable_init();
        __ERC1155Burnable_init();
        minted = [0, 0];
        prices = [0.0005 ether, 0.0003 ether];
        TOTAL_SUPPLY_EACH = 3;
        supplies = [TOTAL_SUPPLY_EACH, TOTAL_SUPPLY_EACH];
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(uint256 id, uint256 amount, string memory newuri)
        public
        payable
        onlyOwner
    {
        require(id < supplies.length && id >= 0, "Required token doesn't exists. Only lands (id 0) or buildings. (id 1).");
        require(minted[id] + amount <= supplies[id], "Not enough tokens. Your request can't be satisfied.");
        require(msg.value >= amount * prices[id], "Not enough ether sent.");
        setURI(newuri);
        _mint(msg.sender, id, amount, "");
        minted[id].tryAdd(1);
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts)
        public
        payable
        onlyOwner
    {
        for(uint i = 0; i < ids.length; i++) {
            uint id = ids[i]; // LAND or BUILDING
            require(id < supplies.length && id >= 0, "Required token doesn't exists. Only lands (id 0) or buildings. (id 1).");
            require(minted[id] + amounts[id] <= supplies[id], "Not enough tokens. Your request can't be satisfied.");
            require(msg.value >= amounts[id] * prices[id], "Not enough ether sent.");
        }
        _mintBatch(msg.sender, ids, amounts, "");
    }

    function mySafeBatchTransferFrom(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public onlyOwner payable {
        super.safeBatchTransferFrom(msg.sender, to, ids, amounts, "");
    }
}
