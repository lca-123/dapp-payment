import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BigInt _counter = BigInt.from(0);

  final TextEditingController _controller = TextEditingController();

  Future<BigInt> printBalance(String privateKeyHex) async {
    final httpClient = Client();
    final web3Client = Web3Client('http://localhost:8545', httpClient);

    final ethPrivateKey = EthPrivateKey.fromHex(privateKeyHex);
    final address = ethPrivateKey.address;
    // print(address);

    final balance = await web3Client.getBalance(address);
    print('Balance: ${balance.getInWei} ETH');
    return balance.getInWei;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              obscureText: true,
              decoration: const InputDecoration(label: Text('请输入查询的私钥')),
            ),
            TextButton(
              onPressed: () async {
                var temp = await printBalance(_controller.text);
                setState(() {
                  _counter = temp;
                });
              },
              child: Text('查询'),
            ),
            Text(
              '这个账户的余额为: $_counter Wei',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
