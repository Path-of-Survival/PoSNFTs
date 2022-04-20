// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../../access/AdminPrivileges.sol";
import "./NFTMetadataUint.sol";

contract PoSNFTMetadata1 is ERC721Enumerable, AdminPrivileges, NFTMetadataUint
{
    constructor(string memory name, string memory symbol) ERC721(name, symbol)
    { }

    function mintByAdmin(address to, uint[] memory metadata) public onlyAdmins virtual
    {
        uint token_id = totalSupply() + 1;
        _mint(to, token_id);
        _setMetadata(token_id, metadata);     
    }
}
