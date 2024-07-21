// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./Post.sol";
contract Web3Gram{
    
    struct pin{
        uint id;
        string uri;
        string caption;
        address payable author;
        uint tips;
        uint mintPrice;
        bool enableMint;
        bool isDeleted;
        string hash1;
        string hash2;
    }
    address public owner;
    constructor(){
        owner=msg.sender;
    }

    mapping(uint=>pin)public pins;
    mapping(uint=>address)public pintoAuthor;

    uint public pinsCount;
    Post post = new Post();
    
    event Posted(uint,string,string,address,uint,uint,uint,bool,bool);
    event Tipped(uint,address,address payable,uint);
    event Minted(uint,address);
    event Deleted(uint,bool);

    function postPin(string calldata _uri,string calldata _caption,bool _mintenable,string calldata _hash1,string calldata _hash2)public{
        require(bytes(_uri).length>0,"URL should be valid");
        require(msg.sender != address(0),"Msg.sender must exist");
        //require(_price>0,"Mint price should be greater than zero");

        pinsCount++;
        pins[pinsCount]=pin(
                    pinsCount,
                    _uri,
                    _caption,
                    payable(msg.sender),
                    0,
                    1 ether,
                    _mintenable,
                    false,
                    _hash1,
                    _hash2);
        pintoAuthor[pinsCount]=msg.sender;
        emit Posted( pinsCount,_uri,_caption,msg.sender,0,0,1 ether,_mintenable,false);

       
    }

    function tipPin(uint _id)external payable{
        require(_id > 0 && _id <= pinsCount,"Invalid ID");
        require(msg.value>0 ,"Tip amount should be more than zero");
        address payable to=pins[_id].author;
        require(msg.sender != to ,"Authors cant tip their own pins");
        to.transfer(msg.value);
        pins[_id].tips +=msg.value;

        emit Tipped(_id,msg.sender,pins[_id].author,msg.value);
    }

 
function onMint(uint _id) external payable {

        require(_id > 0 && _id <= pinsCount,"Invalid ID");
        require(!pins[_id].isDeleted,"Pin deleted");
        require(pins[_id].enableMint,"Minting not eneabled");
         pin memory _pin=pins[_id];
        require(msg.value == _pin.mintPrice,"Not enough ether");
        post.mint(_pin.uri,_id,msg.sender);
        _pin.author.transfer(msg.value);
        emit Minted(_id,msg.sender);
    }


function deletePin(uint _id)external {
        require(_id <=pinsCount,"Invalid id");
        require(pintoAuthor[_id] == msg.sender,"Only authors can delete a post");
        pins[_id].isDeleted=true;
        emit Deleted(_id, pins[_id].isDeleted);   
     }
    
function showallpins()external view returns(pin[] memory){
            require(pinsCount>0,"No posts");
            uint counter=0;
            pin[] memory _pins=new pin[](pinsCount);
            for(uint i=0;i<pinsCount;i++){
            if(!pins[i+1].isDeleted && pins[i+1].author != address(0)){
            _pins[counter]=pins[i+1];
            counter++;
            }
        }
        return _pins;
    }
function showmypins()external view returns(pin[] memory){
            require(pinsCount>0,"No posts");
            uint counter=0;
            pin[] memory _pins=new pin[](pinsCount);
            for(uint i=0;i<pinsCount;i++){
            if(!pins[i+1].isDeleted && pintoAuthor[i+1]==msg.sender){
            _pins[counter]=pins[i+1];
            counter++;
            }
        }
        return _pins;
    }
function showuserpins(address _user)external view returns(pin[] memory){
            require(pinsCount>0,"No posts");
            uint counter=0;
            pin[] memory _pins=new pin[](pinsCount);
            for(uint i=0;i<pinsCount;i++){
            if(!pins[i+1].isDeleted && pintoAuthor[i+1]==_user){
            _pins[counter]=pins[i+1];
            counter++;
            }
        }
        return _pins;
    }
function comparestrings(string memory s1,string memory s2) internal pure returns (bool){
         if(keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))){
             return true;
         }
         else{
             return false;
         }
    }
function search(string calldata hash)external view returns (pin[]memory){
     uint counter=0;
            pin[] memory _pins=new pin[](pinsCount);
            for(uint i=0;i<pinsCount;i++){
            if((!pins[i+1].isDeleted )&& (comparestrings(pins[i+1].hash1,hash) || comparestrings(pins[i+1].hash1,hash)) ){
            _pins[counter]=pins[i+1];
            counter++;
            }
        }
        return _pins;
}


}

