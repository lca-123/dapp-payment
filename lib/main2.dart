import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 与以太坊账户交互
  final httpClient = Client();
  final web3Client = Web3Client('http://localhost:7545', httpClient);
  BigInt id = await web3Client.getChainId();

  final ethPrivateKey = EthPrivateKey.fromHex(privateKeyHex);
  final address = ethPrivateKey.address;
  // print(address);

  final balance = await web3Client.getBalance(address);
  print('Balance: ${balance.getInWei} ETH');

  // 与智能合约交互

  // 创建一个以太坊节点连接
  final EthereumAddress contractAddr = EthereumAddress.fromHex(contractAddress);

  // 创建智能合约实例
  final contract = DeployedContract(
    ContractAbi.fromJson(
        contractAbiJson, 'SimpleStorage'), // 替换 'MyContract' 为你的合约名称
    contractAddr,
  );

  final readFunction = contract.function('read');

  // 调用智能合约的 read 函数
  final result = await web3Client.call(
    contract: contract,
    function: readFunction,
    params: [],
  );
  print('The value is: $result');

  final writeFunction = contract.function('write');
  final newValue = BigInt.from(50); // 你可以将要写入的值替换为适当的值
// 替换为你的私钥
// 创建一个交易事务以调用智能合约的 write 函数
// 替换为你的私钥
  final transaction = Transaction.callContract(
    contract: contract,
    function: writeFunction,
    parameters: [newValue],
    from: address,
  );

// 发送交易

  final txHash = await web3Client.sendTransaction(ethPrivateKey, transaction,
      chainId: id.toInt());
  print('Transaction hash: $txHash');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ethereum Interaction'),
        ),
        body: Center(
          child: Text('Hello Ethereum!'),
        ),
      ),
    );
  }
}

final privateKeyHex =
    '0xc92e70ce3c6e3a370a9ca2037ec56fbd80b79b27d00be775fd09c7b8ed9ff1c8'; // 用你的私钥替换这里
final String contractAddress = "0x8beab76ba519758Db6e4d762B4096cfe6cAc23Cb";
final String contractAbiJson = '''
  [
      {
        "inputs": [],
        "name": "read",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "newValue",
            "type": "uint256"
          }
        ],
        "name": "write",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ]
  ''';
