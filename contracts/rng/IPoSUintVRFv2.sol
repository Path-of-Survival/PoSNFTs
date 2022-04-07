// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPoSUintVRFv2
{
    function requestRandomUint(bytes memory data) external;

    function readRandomUint(address sender, bytes memory data) external view returns(uint);

    event Requested(address indexed _sender, bytes indexed _data, uint indexed _request_id);

    event Fulfilled(uint indexed _request_id, uint _random_uint);
}