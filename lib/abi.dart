const contractAddress = '0x1857Ee1f3670BC3CA1593D520F74c84F8C878358';
const contractABI = '''[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "purchases",
      "outputs": [
        {
          "internalType": "address",
          "name": "buyerAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "sellerAddress",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        },
        {
          "internalType": "bool",
          "name": "isReceived",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_seller",
          "type": "address"
        }
      ],
      "name": "buyerAdd",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_seller",
          "type": "address"
        }
      ],
      "name": "buyerConfirm",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getUnconfirmedTransactions",
      "outputs": [
        {
          "components": [
            {
              "internalType": "address",
              "name": "buyerAddress",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "sellerAddress",
              "type": "address"
            },
            {
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "internalType": "bool",
              "name": "isReceived",
              "type": "bool"
            }
          ],
          "internalType": "struct Purchase.PurchaseInfo[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    }
  ]''';
