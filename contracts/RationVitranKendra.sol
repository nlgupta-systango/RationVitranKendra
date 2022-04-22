// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract RationVitranKendra {    
    address public owner;
    uint public totalPulses=10000;
    uint public totalRice=10000;
    uint public totalWheat=10000;
    uint8 public pulsesDistribute=5;
    uint8 public riceDistribute=5;
    uint8 public wheatDistribute=5;
    uint public nextDueTimePeriod=2592000;// 30 days =2592000 sec.
    struct PulsesStr {
        uint256 time;
        uint256 nextDue;
        uint userPulses;
    }

    struct RiceStr {
        uint256 time;
        uint256 nextDue;
        uint userRice;
    }
    
    struct WheatStr {
        uint256 time;
        uint256 nextDue;
        uint userWheat;
    }

    struct User{
        address userAddress;
        bool isActive; //status of user
        PulsesStr pulsesInfo;
        RiceStr riceInfo;
        WheatStr wheatInfo;
    }

    struct Charity{
        string charityName;
        address charityAddress;
        uint8 charityShare;
        bool isActive;
    }
    
    mapping(address => User) public userMap;
    mapping(address => Charity) public charityMap;
    enum rawItems{pulses,rice,wheat}
    constructor() {
        owner = msg.sender;
    }
    event registerUserEvent(address adsOfUser,bool isActive);
    event withdrawEvent(address adsOfUser,bool hasTaken,string item);
    event userRemovingEvent(address adsOfUser,bool isActive);
   
    function registerUser(address adsOfUser) public onlyOwner {
        PulsesStr memory tempPulses = PulsesStr(0, 0,0);
        RiceStr memory tempRice = RiceStr(0, 0,0);
        WheatStr memory tempWheat = WheatStr(0, 0,0);
        User memory tempUserStr = User(adsOfUser, true, tempPulses,tempRice,tempWheat);
        userMap[adsOfUser] = tempUserStr;
        emit registerUserEvent(adsOfUser,true);
    }

    function withDrawRation(rawItems item) public payable {
        require(userMap[msg.sender].isActive, "RationVitranKendra: not registered");
        require(msg.value>=10000,"RationVitranKendra: provide Required amount");
        if(item==rawItems.pulses){
            _withDrawPulses();
            emit withdrawEvent(msg.sender,true,"pulses");

        }else if(item==rawItems.rice){
            _withDrawRice();
            emit withdrawEvent(msg.sender,true,"rice");


        }else if(item==rawItems.wheat){
            _withDrawWheat();
            emit withdrawEvent(msg.sender,true,"wheat");

        }
    }
        

    function _withDrawPulses() internal {
         require(
            block.timestamp > userMap[msg.sender].pulsesInfo.nextDue,
            "RationVitranKendra: early pulses withdraw request issue"
        );
        require(totalPulses>=5,"RationVitranKendra: insufficient pulses ");
        userMap[msg.sender].pulsesInfo.userPulses+=pulsesDistribute;
        totalPulses-=pulsesDistribute;
        // 30 days in second=nextDueTimePeriod
        userMap[msg.sender].pulsesInfo.nextDue = block.timestamp + nextDueTimePeriod;
        userMap[msg.sender].pulsesInfo.time = block.timestamp;
    }

    function _withDrawRice() internal {
         require(
            block.timestamp > userMap[msg.sender].riceInfo.nextDue,
            "RationVitranKendra: early rice withdraw request issue"
        );
        require(totalRice>=5,"RationVitranKendra: insufficient rice ");
        userMap[msg.sender].riceInfo.userRice+=riceDistribute;
        totalRice-=riceDistribute;
        // 30 days in second=nextDueTimePeriod
        userMap[msg.sender].riceInfo.nextDue = block.timestamp + nextDueTimePeriod;
        userMap[msg.sender].riceInfo.time = block.timestamp;
    }

    function _withDrawWheat() internal {
         require(
            block.timestamp > userMap[msg.sender].wheatInfo.nextDue,
            "RationVitranKendra: early wheat withdraw request issue"
        );
        require(totalWheat>=5,"RationVitranKendra: insufficient wheat ");
        userMap[msg.sender].wheatInfo.userWheat+=wheatDistribute;
        totalWheat-=wheatDistribute;
        // 30 days in second=nextDueTimePeriod
        userMap[msg.sender].wheatInfo.nextDue = block.timestamp + nextDueTimePeriod;
        userMap[msg.sender].wheatInfo.time = block.timestamp;
    }

    function removeUser(address toRemoveUser) public onlyOwner {
        userMap[toRemoveUser].isActive=false;
        emit userRemovingEvent(toRemoveUser,false);
       
    }

    function charityRegistration(string memory _charityName,address _charityAddress,uint8 _charityShare) public onlyOwner{
        charityMap[_charityAddress].charityName=_charityName;
        charityMap[_charityAddress].charityAddress=_charityAddress;
        charityMap[_charityAddress].charityShare=_charityShare;
        charityMap[_charityAddress].isActive=true;
    }

    function removeCharity(address toRemoveCharity) public onlyOwner{
        require(charityMap[toRemoveCharity].isActive==true,"RationVitranKendra: already inactive charity");
        charityMap[toRemoveCharity].isActive=false;

    } 

    function withDrawFund() public {
        require(charityMap[msg.sender].isActive==true,"RationVitranKendra: not Registered charity");
        require(address(this).balance>0);
        address payable charityAddress=payable(msg.sender);
        charityAddress.transfer((address(this).balance*charityMap[msg.sender].charityShare)/100);
    }

    function refilling(uint _pulses,uint _rice,uint _wheat) public onlyOwner{
        totalPulses+=_pulses;
        totalRice+=_rice;
        totalWheat+=_wheat;
    }

    function updateItemsQuantity(uint8 _pulsesDistribute,uint8 _riceDistribute,uint8 _wheatDistribute) public onlyOwner{
        pulsesDistribute=_pulsesDistribute;
        riceDistribute=_riceDistribute;
        wheatDistribute=_wheatDistribute;
    }

    function getContractBal() public view returns(uint){
        return address(this).balance;
    }

    function changeDistributionTime(uint newtime)public onlyOwner{
        nextDueTimePeriod=newtime;
    }
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

}
