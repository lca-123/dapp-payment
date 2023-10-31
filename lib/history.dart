import 'package:flutter/material.dart';

class HistoryTransfers extends StatefulWidget {
  const HistoryTransfers({super.key});

  @override
  State<HistoryTransfers> createState() => _HistoryTransfersState();
}

class _HistoryTransfersState extends State<HistoryTransfers> {
  late int _listnum;

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
        title: Text('Decay Transfers'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
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
                  Text('xxx'),
                  Text(''),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Amount:'),
                          Text(
                            '$index ETH',
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          _transferConfirm();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple, // 设置按钮的背景颜色
                        ),
                        child: const Text(
                          'confirm',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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

  void _transferConfirm() {}

  void _getTrnasfers() {
    setState(() {
      _listnum = 10;
    });
  }
}
