// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
// 0xa74f530483F03c81E91809dAdDC689E62061a50c
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {

    address payable owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemSold;

    uint256 listPrice = 0.01 ether; 

    constructor() ERC721("NFTMarketplace", "NFTM") {
        owner = payable(msg.sender);
    }

    struct ListedToken {
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }

    mapping(uint256 => ListedToken) public idToListedTokens;


    function updateListPrice(uint _listPrice) public payable {
        require(msg.sender == owner, "Only owner can update list price");
        listPrice = _listPrice;
    }
    function getListPrice() public view  returns (uint256) {
        return listPrice;
    }
    function getLatestIdToListedToken() public view returns (ListedToken memory) {
        return idToListedTokens[_tokenIds.current()];
    }
    function getListedForTokenId(uint _tokenId) public view  returns (ListedToken memory) {
        return idToListedTokens[_tokenId];
    }
    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIds.current();
    }
    function getTokenPrice(uint _tokenId) public view returns (uint256) {
        return idToListedTokens[_tokenId].price;
    }


    function createToken(string memory tokenURI, uint price) public payable returns(uint){
        require(msg.value == listPrice, "Price must be equal to list price");
        require(price > 0, "Price must be greater than 0");
        _tokenIds.increment();
        _safeMint(msg.sender, _tokenIds.current());
        // safe mint (checks that the token can be sent to the address ie the address is a valid one)
        _setTokenURI(_tokenIds.current(), tokenURI);

        createListedToken(_tokenIds.current(),price);

        return _tokenIds.current();
    }

    function createListedToken(uint _tokenId,uint _price) private {
        ListedToken memory listedToken = ListedToken(_tokenId, payable(address(this)), payable(msg.sender), _price, true);
        idToListedTokens[_tokenId] = listedToken;

        _transfer(msg.sender, address(this), _tokenId);
    }

    function getAllNFTS() view public returns (ListedToken[] memory) {
        ListedToken[] memory listedTokens = new ListedToken[](_tokenIds.current());
        for (uint i = 0; i < _tokenIds.current(); i++) {
            listedTokens[i] = idToListedTokens[i+1];
        }
        return listedTokens;
    }
    function getMyNFTs() public view returns (ListedToken[] memory) {
       uint totalNfts = _tokenIds.current();
       uint myNFTCount =0;
       for(uint i=0; i<totalNfts; i++){
           if(idToListedTokens[i+1].owner == msg.sender || idToListedTokens[i+1].seller == msg.sender){
               myNFTCount++;
           }
       }
         ListedToken[] memory myNFTs = new ListedToken[](myNFTCount);
         uint myNFTCounter =0;
        for (uint i = 0; i < totalNfts; i++) {
            if(idToListedTokens[i+1].owner == msg.sender || idToListedTokens[i+1].seller == msg.sender){
            myNFTs[myNFTCounter] = idToListedTokens[i+1];
            myNFTCounter++;
            }
        }
        return myNFTs;
    }

    function executeSale(uint _tokenId) public payable{
        require(msg.value ==getTokenPrice(_tokenId),"Price for the token must be payed");

        address seller = idToListedTokens[_tokenId].seller;
        address buyer = msg.sender;
        idToListedTokens[_tokenId].currentlyListed = true;
        idToListedTokens[_tokenId].seller = payable(buyer);
        _itemSold.increment();

        _transfer(address(this), buyer, _tokenId);

        approve(address(this),_tokenId);

        payable(owner).transfer(listPrice);
        payable(seller).transfer(msg.value - listPrice);
        
    }

        
}