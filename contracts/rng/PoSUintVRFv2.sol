// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./IPoSUintVRFv2.sol";

contract PoSUintVRFv2 is VRFConsumerBaseV2, Ownable, IPoSUintVRFv2
{
    VRFCoordinatorV2Interface COORDINATOR;
    LinkTokenInterface LINKTOKEN;
    address constant vrfCoordinator = 0x6A2AAd07396B36Fe02a22b33cf443582f682c82f;
    address constant link_address = 0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06;
    bytes32 gasKeyHash = 0xd4bb89654db74673a187bd804519e65e3f71a52bc55f11da7601a13dcf505314;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint64 s_subscriptionId;
    mapping (address => bool) public consumers;

    mapping (uint => bytes32) request_to_data_hash;
    mapping (bytes32 => uint) random_uint;
    mapping (bytes32 => uint) request_epoch;

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) 
    {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link_address);
        s_subscriptionId = subscriptionId;
    }

    function requestRandomUint(bytes memory data) external
    {
        require(consumers[_msgSender()] == true, "the caller does not have permissions");
        bytes32 data_hash = keccak256(abi.encode(_msgSender(), data));
        require(random_uint[data_hash] == 0 && request_epoch[data_hash] < block.timestamp - 1 days, "forbidden randomness re-request");
        uint request_id = COORDINATOR.requestRandomWords(gasKeyHash, s_subscriptionId, requestConfirmations, callbackGasLimit, 1);
        request_to_data_hash[request_id] = data_hash;
        request_epoch[data_hash] = block.timestamp;
        emit Requested(_msgSender(), data, request_id);
    }
  
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override 
    {
        random_uint[request_to_data_hash[requestId]] = randomWords[0];
        emit Fulfilled(requestId, randomWords[0]);
    }

    function readRandomUint(address sender, bytes memory data) public override view returns(uint)
    {
        bytes32 data_hash = keccak256(abi.encode(sender, data));
        require(request_epoch[data_hash] != 0 && random_uint[data_hash] != 0, "not ready");
        return random_uint[data_hash];
    }

    function addConsumer(address consumer) external onlyOwner
    {
        consumers[consumer] = true;
    }

    function removeConsumer(address consumer) external onlyOwner
    {
        consumers[consumer] = false;
    }

    function setGasLimit(uint32 new_gas_limit) external onlyOwner
    {
        callbackGasLimit = new_gas_limit;
    }

    function setGasPriceLimit(bytes32 hash) external onlyOwner
    {
        gasKeyHash = hash;
    }

    function setNetworkConfirmations(uint16 new_request_confirmations) external onlyOwner
    {
        requestConfirmations = new_request_confirmations;
    }

    function setSubscriptionId(uint64 new_subscription_id) external onlyOwner
    {
        s_subscriptionId = new_subscription_id;
    }
}