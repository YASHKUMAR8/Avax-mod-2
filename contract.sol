// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FarmersMarket {
    address public owner;
    uint public productIdCounter;
    
    struct Product {
        uint id;
        string name;
        uint price; // price in wei
        address payable seller;
        bool isSold;
    }

    mapping(uint => Product) public products;
    mapping(address => uint[]) public farmerProducts;

    event ProductListed(uint id, string name, uint price, address seller);
    event ProductSold(uint id, address buyer);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function listProduct(string memory _name, uint _price) public {
        require(_price > 0, "Price must be greater than zero");
        productIdCounter++;
        products[productIdCounter] = Product(productIdCounter, _name, _price, payable(msg.sender), false);
        farmerProducts[msg.sender].push(productIdCounter);
        emit ProductListed(productIdCounter, _name, _price, msg.sender);
    }

    function buyProduct(uint _productId) public payable {
        Product storage product = products[_productId];
        require(product.id == _productId, "Product not found");
        require(msg.value >= product.price, "Insufficient payment");
        require(!product.isSold, "Product already sold");

        product.seller.transfer(msg.value);
        product.isSold = true;
        emit ProductSold(_productId, msg.sender);
    }

    function getFarmerProducts(address farmer) public view returns (uint[] memory) {
        return farmerProducts[farmer];
    }
}
