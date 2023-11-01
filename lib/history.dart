import 'package:demo3/home.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'abi.dart';

class HistoryTransfers extends StatefulWidget {
  final String privateKey;

  const HistoryTransfers({Key? key, required this.privateKey})
      : super(key: key);

  @override
  State<HistoryTransfers> createState() => _HistoryTransfersState();
}

class _HistoryTransfersState extends State<HistoryTransfers> {
  late int _listnum = 0;
  late List data = [];

  @override
  void initState() {
    super.initState();
    _getTrnasfers();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    // 获取屏幕的宽度和高度
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Delay Transfers'),
      ),
      body: _listnum == 0
          ? const Text('')
          : ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.99,
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // 圆角的半径
                      border: Border.all(
                        color: Colors.grey, // 边框颜色
                        width: 1.0, // 边框宽度
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('address:'),
                        Text(
                          data[index][1].toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(''),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('Amount:'),
                                Text(
                                  '${data[index][2].toString()} ETH',
                                  style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                            height: screenHeight * 0.15,
                                            width: screenWidth * 0.8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                    '''Clicking on the button below will confirm the transaction. If you are certain that you need to confirm the transaction, please click on the button below.'''),
                                                Container(
                                                  height: screenHeight * 0.01,
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      _transferConfirm(
                                                          data[index][1]
                                                              .toString());
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    } catch (e) {}
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .deepPurple, // 设置按钮的背景颜色
                                                  ),
                                                  child: const Text(
                                                    'confirm',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurple, // 设置按钮的背景颜色
                              ),
                              child: const Text(
                                'confirm',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: _listnum,
            ),
    );
  }

  void _transferConfirm(String toAddress) async {
    final httpClient = Client();
    final web3Client = Web3Client('http://localhost:8545', httpClient);
    BigInt id = await web3Client.getChainId();
    final ethPrivateKey = EthPrivateKey.fromHex(widget.privateKey);

    final address = ethPrivateKey.address;

    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(contractAddress);

    final contract = DeployedContract(
      ContractAbi.fromJson(contractABI, 'Purchase'),
      contractAddr,
    );
    final writeFunction = contract.function('buyerConfirm');
    final to = EthereumAddress.fromHex(toAddress);
    final transaction = Transaction.callContract(
      contract: contract,
      function: writeFunction,
      parameters: [to],
      from: address,
    );
    final txHash = await web3Client.sendTransaction(ethPrivateKey, transaction,
        chainId: id.toInt());
    print('Transaction hash: $txHash');
  }

  Future<void> _getTrnasfers() async {
    final httpClient = Client();
    final web3Client = Web3Client('http://localhost:8545', httpClient);

    final ethPrivateKey = EthPrivateKey.fromHex(widget.privateKey);
    final address = ethPrivateKey.address;

    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(contractAddress);

    final contract = DeployedContract(
      ContractAbi.fromJson(contractABI, 'Purchase'),
      contractAddr,
    );

    final readFunction = contract.function('getUnconfirmedTransactions');

    final result = await web3Client.call(
      contract: contract,
      function: readFunction,
      params: [],
    );

    List<dynamic> temp = [];
    for (int i = 0; i < result[0].length; i++) {
      if (result[0][i][0].toString() == address.toString().toLowerCase()) {
        result[0][i][2] = result[0][i][2] ~/ BigInt.from(1000000000000000000);
        temp.add(result[0][i]);
      }
    }

    setState(() {
      _listnum = temp.length;
      data = temp;
    });
  }
}
