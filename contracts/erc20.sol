// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
abstract contract IRVK{
    
    function name() public virtual view returns (string memory);
    function symbol() public virtual view returns (string memory);
    function decimals() public virtual view returns (uint8);
    function totalSupply() public virtual view returns (uint256);
    function balanceOf(address _owner) public virtual view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public virtual view returns (uint256 remaining);
    function x()public{

    }

}
contract RVK is IRVK{
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    uint public _totalSupply;
    address public _minter;
    mapping(address=>uint) balances;
    constructor(){
        _name="RationVitranKendra";
        _symbol="RVK";
        _decimals=1;
        _totalSupply=200;
        _minter=0x7Fd333E334D0459d742ed31D82CC6b8f7353763D;
        balances[_minter]=_totalSupply;
    }

    function name() public override view returns (string memory){
         return _name;
    }

    function symbol() public override view returns (string memory){
        return _symbol;

    }
    
    function decimals() public override view returns (uint8){
        return _decimals;
    }

    function totalSupply() public override view returns (uint256){
        return _totalSupply;

    }

    function balanceOf(address _owner) public override view returns (uint256 balance){
        return balances[_owner];
    }

     function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(balances[_from] >= _value);
        balances[_from] -= _value; 
        balances[_to] += _value;
        return true;
    }
    

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        return transferFrom(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
        return 0;
    }

    function mint(uint amount) public returns (bool) {
        require(msg.sender == _minter);
        balances[_minter] += amount;
        _totalSupply += amount;
        return true;
    }

}