// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract NFTMetadata
{
    enum FACTION { Keepers_Of_The_Flame, Ministry_of_mind, The_golden_heart, The_scintillions }
    enum RARITY { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

    struct MetadataStruct
    {
        FACTION _faction;
        RARITY _rarity;
    }

    MetadataStruct[] private tokens_metadata;
    mapping(uint => uint) private _index_to_token_id;
    mapping(uint => uint) private _token_id_to_index;

    function _isempty(uint token_id) internal view returns(bool) 
    {
        return _token_id_to_index[token_id] == 0;
    }

    function getMetadata(uint token_id) internal view returns(MetadataStruct memory) 
    {
        require(_token_id_to_index[token_id] > 0, "metadata not set");
        return tokens_metadata[_token_id_to_index[token_id] - 1];
    }

    function addTokenMetadata(uint token_id, MetadataStruct memory metadata) internal
    {
        _index_to_token_id[tokens_metadata.length] = token_id;
        _token_id_to_index[token_id] = tokens_metadata.length + 1;
        tokens_metadata.push(metadata);
    }
    
    function removeTokenMetadata(uint token_id) internal
    {        
        MetadataStruct memory last_token_metadata = tokens_metadata[tokens_metadata.length - 1];
        uint last_token_id = _index_to_token_id[tokens_metadata.length - 1];

        uint toremove_index = _token_id_to_index[token_id] - 1;

        tokens_metadata[toremove_index] = last_token_metadata; 
        _index_to_token_id[toremove_index] = last_token_id;
        _token_id_to_index[last_token_id] = toremove_index + 1; 
      
        delete _token_id_to_index[token_id];
        delete _index_to_token_id[tokens_metadata.length - 1];
        tokens_metadata.pop();
    } 
}


