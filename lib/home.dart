import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'trasfer.dart';

class HomePage extends StatefulWidget {
  final String privateKey;

  const HomePage({Key? key, required this.privateKey}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BigInt _balance = BigInt.from(-1);
  @override
  void initState() {
    super.initState();
    _getBalance(widget.privateKey);
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
        title: Text('Home Page'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.2,
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
                      Text('address:'),
                      Text(_getAddress(widget.privateKey)),
                      Text(''),
                      Text('Balance:'),
                      _balance == BigInt.from(-1)
                          ? Text('')
                          : Text(
                              '$_balance ETH',
                              style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                ),
              ),
              Container(),
              Transfer(
                privateKey: widget.privateKey,
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getAddress(String privateKey) {
    final ethPrivateKey = EthPrivateKey.fromHex(privateKey);
    final address = ethPrivateKey.address;
    return address.toString();
  }

  Future<BigInt> _getBalance(String privateKey) async {
    final httpClient = Client();
    final web3Client = Web3Client('http://localhost:8545', httpClient);
    final ethPrivateKey = EthPrivateKey.fromHex(privateKey);
    final address = ethPrivateKey.address;

    final balance = await web3Client.getBalance(address);
    // await Future.delayed(Duration(seconds: 5));
    setState(() {
      _balance = balance.getInEther;
    });

    return balance.getInEther;
  }

  Future<void> _onRefresh() async {
    final temp = await _getBalance(widget.privateKey);
    setState(() {
      _balance = temp;
    });
  }
}
