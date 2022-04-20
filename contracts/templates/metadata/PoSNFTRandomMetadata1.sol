// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../../access/AdminPrivileges.sol";
import "../../rng/IPoSUintVRFv2.sol";
import "./NFTMetadataUint.sol";

contract PoSNFTRandomMetadata1 is ERC721Enumerable, AdminPrivileges, NFTMetadataUint
{
    uint private next_token_id = 1;

    IPoSUintVRFv2 randomness_supplier;
    uint[] metadata_modulo;

    constructor(string memory name, string memory symbol, address _randomness_supplier, uint[] memory _metadata_modulo) ERC721(name, symbol)
    { 
        metadata_modulo = _metadata_modulo;
        randomness_supplier = IPoSUintVRFv2(_randomness_supplier);
    }

    function mintByAdmin(address to) public onlyAdmins virtual
    {
        _mint(to, next_token_id);
        randomness_supplier.requestRandomUint(abi.encode(next_token_id));
        next_token_id += 1;
    }

    function requestRandomness(uint token_id) public
    {
        require(isAdmin(_msgSender()) == true, "the caller does not have permissions");
        require(_exists(token_id), "randomness request for nonexistent token");
        randomness_supplier.requestRandomUint(abi.encode(token_id));
    }

    function generateMetadata(uint token_id) public
    {
        require(_exists(token_id) && _metadataSize(token_id) == 0, "metadata is already generated");
        uint seed = randomness_supplier.readRandomUint(address(this), abi.encode(token_id));
        _setMetadata(token_id, getRandomNums(seed, metadata_modulo));
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

///////// TEST
    function getMetadata(uint token_id) public view returns(uint[] memory)
    {
        return _getMetadata(token_id);
    }
}
