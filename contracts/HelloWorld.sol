pragma solidity ^0.8.0;
contract HelloWorld {
    string public yourName;
    
    constructor(){
        yourName = "Unknown" ;
    }
    
    function setName(string memory nm) public{
        yourName = nm ;
    }
}