import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _publicKeyController = TextEditingController();
  final TextEditingController _privateKeyController = TextEditingController();
  String content = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    // 获取屏幕的宽度和高度
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                children: [
                  TextField(
                      controller: _publicKeyController,
                      decoration:
                          const InputDecoration(label: Text(' public key'))),
                  Container(
                    height: screenHeight * 0.01,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.02,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                children: [
                  TextField(
                      controller: _privateKeyController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(label: Text(' private key'))),
                  Container(
                    height: screenHeight * 0.01,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.01,
          ),
          TextButton(
              onPressed: () {
                if (isVaild(
                    _publicKeyController.text, _privateKeyController.text)) {
                  // 在当前页面跳转到新页面
                  setState(() {
                    content = '';
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              privateKey: _privateKeyController.text,
                            )),
                  );
                } else {
                  setState(() {
                    content = 'wrong key';
                  });
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple // 设置按钮的背景颜色
                  ),
              child: const Text(
                'login',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
          Text(content)
        ],
      )),
    );
  }

  bool isVaild(String public, String private) {
    final ethPrivateKey = EthPrivateKey.fromHex(private);
    final address = ethPrivateKey.address;
    return public.toLowerCase() == address.toString();
  }
}
