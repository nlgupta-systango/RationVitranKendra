// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
interface IRVK{
    // Events
    event registerUserEvent(address adsOfUser,bool isActive);
    event withdrawEvent(address adsOfUser,bool hasTaken,string item);
    event userRemovingEvent(address adsOfUser,bool isActive);
    event updateItemsPriceEvent(uint pulsesPrice,uint ricePrice,uint wheatPrice,string msg);
    
    enum rawItems{pulses,rice,wheat}

    function registerUser(address adsOfUser) external;
    function withDrawRation(rawItems item) external payable ;
    function removeUser(address toRemoveUser) external ;
    function charityRegistration(string memory _charityName,address _charityAddress,uint8 _charityShare) external;
    function removeCharity(address toRemoveCharity) external;
    function withDrawFund() external;
    function refilling(uint _pulses,uint _rice,uint _wheat) external;
    function updateItemsQuantity(uint8 _pulsesDistribute,uint8 _riceDistribute,uint8 _wheatDistribute) external;
    function changeDistributionTime(uint newtime)external; 
    function changeCharityWithdrawTime(uint newtime) external;
    function updateItemsPrice(uint _pulsesPrice,uint _ricePrice,uint _wheatPrice) external;
    
    
}