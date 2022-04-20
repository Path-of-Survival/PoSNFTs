// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../access/AdminPrivileges.sol";

contract PoSNFT2 is ERC721Enumerable, AdminPrivileges
{
    constructor(string memory name, string memory symbol) ERC721(name, symbol)
    { }

    function mintByAdmin(address to, uint token_id) public onlyAdmins virtual
    {
        _mint(to, token_id);    
    }
}
