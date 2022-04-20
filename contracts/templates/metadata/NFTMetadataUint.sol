// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTMetadataUint
{
    mapping(uint => uint[]) private metadata_map;

    constructor() 
    { }

    function _metadataSize(uint token_id) internal view returns(uint) 
    {
        return metadata_map[token_id].length;
    }

    function _getMetadata(uint token_id) internal view returns(uint[] memory) 
    {
        uint[] memory metadata = metadata_map[token_id];
        require(metadata.length > 0, "metadata not set");
        return metadata_map[token_id];
    }

    function _setMetadata(uint token_id, uint[] memory metadata) internal
    {
        require(metadata.length > 0, "metadata is empty");
        metadata_map[token_id] = metadata;
    }
    
    function _removeMetadata(uint token_id) internal
    {        
        metadata_map[token_id] = new uint[](0);
    } 
}


