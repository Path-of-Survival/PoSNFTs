// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../templates/metadata/PoSNFTRandomMetadata1.sol";

contract ClanLandsTEST is PoSNFTRandomMetadata1
{

    constructor(uint[] memory metadata_structure) PoSNFTRandomMetadata1("ClanLandsTEST", "CTNFT", 0x9e5734B22830944426235637641247631570B1E7, metadata_structure)  
    { }

    function burn(uint256 token_id) public  
    {
        require(super._isApprovedOrOwner(_msgSender(), token_id), "caller is not owner nor approved");
        super._burn(token_id);
        _removeMetadata(token_id);
    }
    
    function _baseURI() internal view virtual override returns (string memory)
    {
        return "https://pos-nft-metadata.herokuapp.com/clan-lands/";
    }
   
}


