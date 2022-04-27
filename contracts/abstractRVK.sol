// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "./interfaceRVK.sol";
abstract contract abstractRVK is IRVK{
    address public owner;
    modifier onlyOwner() {
        require(owner == msg.sender,"not Owner");
        _;
    }


}