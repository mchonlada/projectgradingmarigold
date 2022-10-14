
import 'package:flutter/material.dart';

class DataSizePage extends StatefulWidget {
  const DataSizePage({Key? key}) : super(key: key);

  @override
  State<DataSizePage> createState() => _DataSizePageState();
}

class _DataSizePageState extends State<DataSizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/show.png"),
          fit: BoxFit.fill,
        ),
      ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                          'ข้อมูลขนาดดอกดาวเรือง',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.brown.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),

        ),
    ),
      ),
    );
  }
}
