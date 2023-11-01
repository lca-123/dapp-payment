import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'abi.dart';

class Transfer extends StatefulWidget {
  final String privateKey;

  const Transfer({Key? key, required this.privateKey}) : super(key: key);

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final TextEditingController _toAddress = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  bool _isDecay = true;
  String massage = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    // 获取屏幕的宽度和高度
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      height: screenHeight * 0.30,
      width: screenWidth * 0.99,
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
            Text('Transfer'),
            Container(
              child: Column(
                children: [
                  TextField(
                    controller: _toAddress,
                    decoration: InputDecoration(label: Text('address')),
                  ),
                  TextField(
                    controller: _amount,
                    decoration: InputDecoration(label: Text('amount(ETH)')),
                  )
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.01,
            ),
            Container(
                child: Row(
              children: [
                Row(
                  children: [
                    Text('delay'),
                    Container(
                      width: screenWidth * 0.01,
                    ),
                    Switch(
                        value: _isDecay,
                        onChanged: (value) {
                          setState(() {
                            _isDecay = value;
                          });
                          print(_isDecay);
                        }),
                  ],
                ),
                Container(
                  width: screenWidth * 0.35,
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await transfer();
                      setState(() {
                        _toAddress.text = '';
                        _amount.text = '';
                        massage = 'transfer complete';
                      });
                    } catch (e) {
                      setState(() {
                        massage = 'transfer fail';
                      });
                    }

                    await Future.delayed(const Duration(seconds: 5));
                    setState(() {
                      massage = '';
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // 设置按钮的背景颜色
                  ),
                  child: const Text(
                    'transfer',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )),
            Text(
              massage,
            )
          ],
        ),
      ),
    );
  }

  Future<void> transfer() async {
    if (_isDecay == true) {
      print('delay transfer ${_amount.text} ETH to ${_toAddress.text}');
      await decayTransfer();
    } else {
      print('instant transfer ${_amount.text} ETH to ${_toAddress.text}');
      await instantTransfer();
    }
  }

  Future<void> instantTransfer() async {
    final httpClient = Client();
    final web3Client = Web3Client('http://localhost:8545', httpClient);
    BigInt id = await web3Client.getChainId();
    final ethPrivateKey = EthPrivateKey.fromHex(widget.privateKey);
    final fromaddress = ethPrivateKey.address;
    final toaddress = EthereumAddress.fromHex(_toAddress.text);
    final amount = EtherAmount.fromBase10String(EtherUnit.ether, _amount.text);
    final transaction =
        Transaction(from: fromaddress, to: toaddress, value: amount);

    final txHash = await web3Client.sendTransaction(ethPrivateKey, transaction,
        chainId: id.toInt());
    print('Transaction hash: $txHash');
  }

  Future<void> decayTransfer() async {
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

    final writeFunction = contract.function('buyerAdd');
    final to = EthereumAddress.fromHex(_toAddress.text);
    final newValue = BigInt.parse(_amount.text);

    final transaction = Transaction.callContract(
        contract: contract,
        function: writeFunction,
        parameters: [to],
        from: address,
        value: EtherAmount.fromBigInt(EtherUnit.ether, newValue));
    final txHash = await web3Client.sendTransaction(ethPrivateKey, transaction,
        chainId: id.toInt());
    print('Transaction hash: $txHash');
  }
}
