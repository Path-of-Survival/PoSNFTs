// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PoSNFT.sol";
import "./NFTMetadata_template.sol";
import "./rng/IPoSUintVRFv2.sol";

contract TestPoSNFTRandomMetadata is PoSNFT, NFTMetadata
{
    address immutable randomness_supplier;
    uint[] metadata_modulo = [4, 5];

    constructor(address _randomness_supplier) PoSNFT("TestPoSNFTRandomMetadata", "TPNFT", "1.0", 0xb62d5f3eec692628cf4886db8dce6f37ac32d0879d85036958a73d37a360ccb9, 100)
    { 
        randomness_supplier = _randomness_supplier;
    }

    function mintByAdmin(address to, uint quantity) public virtual override
    {
        require(admins[_msgSender()] == true, "the caller does not have permissions");
        require(next_token_id + quantity <= FIRST_GAME_TOKEN_ID, "Exceeds reserved quantity");
        for(uint i=0; i < quantity; i++)
        {
            IPoSUintVRFv2(randomness_supplier).requestRandomUint(abi.encode(next_token_id));
            _mint(to, next_token_id++);
        }
    }

    function requestRandomness(uint token_id) public
    {
        require(admins[_msgSender()] == true, "the caller does not have permissions");
        require(_exists(token_id), "randomness request for nonexistent token");
        IPoSUintVRFv2(randomness_supplier).requestRandomUint(abi.encode(token_id));
    }

    function generateMetadata(uint token_id) public
    {
        require(_isempty(token_id), "metadata is already generated");
        uint seed = IPoSUintVRFv2(randomness_supplier).readRandomUint(address(this), abi.encode(token_id));
        uint[] memory metadata_values = getRandomNums(seed, metadata_modulo);
        MetadataStruct memory metadata = MetadataStruct((FACTION)(metadata_values[0]%metadata_modulo[0]), (RARITY)(metadata_values[1]%metadata_modulo[1]));
        addTokenMetadata(token_id, metadata);
    }

    function getRandomNums(uint seed, uint[] memory modulo) internal pure returns(uint[] memory)
    {
        uint[] memory result = new uint[](modulo.length);
        for(uint i=0; i<result.length; i++)
        {
            result[i] = (uint)(keccak256(abi.encodePacked(seed, i))) % modulo[i];
        }
        return result;
    }
}