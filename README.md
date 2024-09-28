# FarmersMarket Smart Contract
This Solidity contract allows farmers to list their products for sale and for customers to buy those products directly from the blockchain. The contract is designed for a decentralized marketplace where farmers can sell their vegetables or other products.

## Features
* Listing Products: Farmers can list products with a name and price (in wei).
* Buying Products: Users can purchase listed products by paying the specified price.
* Ownership Control: The contract owner has special permissions to manage the contract.
* Product Management: Each product is assigned a unique ID and has details like name, price, seller, and sold status.
* Farmer's Products: Farmers can view all products they have listed for sale.
## How It Works
### Contract Deployment
The contract is deployed by an owner, who will have control over certain functionalities within the contract. The owner is the address that deploys the contract.

### Key Functions
#### * listProduct:
   * Allows a farmer to list a product by providing a name and price (in wei).
   * The function increments the productIdCounter and stores the product details in a mapping.
   * Emits the ProductListed event when a product is successfully listed.
#### * buyProduct:
   * Allows a user to purchase a product by sending the required amount of Ether.
   * Transfers the payment to the seller's address and marks the product as sold.
   * Emits the ProductSold event when a product is purchased.
#### * getFarmerProducts:
   * Fetches all product IDs listed by a specific farmer.
### Events
* ProductListed: Emitted when a new product is listed by a farmer.
* ProductSold: Emitted when a product is sold to a buyer.
## Getting Started
1. Smart Contract: Create a new Solidity file (.sol extension) and paste the following code:
```
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
```
2. JavaScript File: Create a JavaScript file (app.js) and add the following code:
3. HTML File: Create an HTML file (index.html) and add the following code:
4. CSS File: Create a CSS file (style.css) and add the following code:
## Installation and Usage
1. Prerequisites: You will need the following to interact with this contract:
* A local or remote Ethereum node (e.g., Ganache, Infura)
* A development framework like Truffle or Hardhat
* MetaMask or another Web3 provider for interacting with the Ethereum network.
2. Compiling the Contract: You can compile the contract using the following command (if using Truffle):
```
truffle compile
```
3. Deploying the Contract: You can deploy the contract using:
```
truffle migrate
```
4. Interacting with the Contract: You can interact with the contract by:
* Listing a product by calling listProduct with a name and price (in wei).
* Buying a product by calling buyProduct and sending the required Ether.
##### Example
1. Listing a Product:
```
farmersMarket.listProduct("Tomatoes", 1000000000000000); // 0.001 Ether
```
2. Buying a Product:
```
farmersMarket.buyProduct(1, { value: 1000000000000000 }); // Send 0.001 Ether
```
### Contract Details
* Version: Solidity 0.8.0
* License: MIT
### Security Considerations
* Ensure that the product price is set appropriately as it is denominated in wei (the smallest denomination of Ether).
* Always verify product details and the seller's address before purchasing.
## Author
Yash Kumar
