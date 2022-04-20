// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../access/AdminPrivileges.sol";

contract PoSNFT1 is ERC721Enumerable, AdminPrivileges
{
    uint private next_token_id = 1;

    constructor(string memory name, string memory symbol) ERC721(name, symbol)
    { }

    function mintByAdmin(address to) public onlyAdmins virtual
    {
        _mint(to, next_token_id);  
        next_token_id += 1;     
    }
}
