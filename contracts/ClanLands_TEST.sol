// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./NFTMetadata_template.sol";

contract ClanLandsTEST is Ownable, ERC721Enumerable, NFTMetadata
{
  
    constructor() ERC721("ClanLandsTEST", "CTNFT") 
    { }
    
    function mint(address account, uint token_id, FACTION _faction, RARITY _rarity) public onlyOwner
    {
        _mint(account, token_id);
        addTokenMetadata(token_id, MetadataStruct(_faction, _rarity) );
    }

    function burn(uint256 token_id) public  
    {
        require(super._isApprovedOrOwner(_msgSender(), token_id), "caller is not owner nor approved");
        super._burn(token_id);
        removeTokenMetadata(token_id);
    }
    
    function _baseURI() internal view virtual override returns (string memory)
    {
        return "https://my_domain.com/";
    }
   
}


