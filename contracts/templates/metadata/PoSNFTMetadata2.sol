// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../../access/AdminPrivileges.sol";
import "./NFTMetadataUint.sol";

contract PoSNFTMetadata2 is ERC721Enumerable, AdminPrivileges, NFTMetadataUint
{
    constructor(string memory name, string memory symbol) ERC721(name, symbol)
    { }

    function mintByAdmin(address to, uint token_id, uint[] memory metadata) public onlyAdmins virtual
    {
        _mint(to, token_id);
        _setMetadata(token_id, metadata);     
    }
}