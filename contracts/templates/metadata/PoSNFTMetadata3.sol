// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../../access/AdminPrivileges.sol";
import "./NFTMetadataUint.sol";

contract PoSNFTMetadata3 is ERC721Enumerable, AdminPrivileges, NFTMetadataUint
{
    uint private next_token_id = 1;

    constructor(string memory name, string memory symbol) ERC721(name, symbol)
    { }

    function mintByAdmin(address to, uint[] memory metadata) public onlyAdmins virtual
    {
        _mint(to, next_token_id);
        _setMetadata(next_token_id, metadata);
        next_token_id += 2;
    }
    
    function mintByAdmin(address to, uint token_id, uint[] memory metadata) public onlyAdmins virtual
    {
        require(token_id % 2 == 0, "invalid tokenId");
        _mint(to, token_id);
        _setMetadata(token_id, metadata);
    }
}