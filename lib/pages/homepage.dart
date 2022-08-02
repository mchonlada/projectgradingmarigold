import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late File _image;
  File? imageFile;
  List? _output;
  final picker = ImagePicker();
  String _name = "";
  String _confidence = "";
  var id;
  String detail = "";


  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
      });
    });
  }

  // Model
  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model/modelver3.tflite",
        labels: "assets/model/labels.txt");
  }

  _getFromCamera() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
    //cropImage(image.path);
  }

  _getFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
    //cropImage(image.path);
  }

  classifyImage(File _image) async {
    var output = await Tflite.runModelOnImage(
        path: _image.path,
        numResults: 3,
        threshold: 0.05,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output!;
      String str = _output![0]['label'];
      _name = str.substring(0);
      _confidence = _output != null ? (_output![0]['confidence']*100.0).toString().substring(0,5) + "%" : "";

    });
    print(_output);
  }


  @override
  void dispose() {
    var close = Tflite.close();
    super.dispose();
  }

  // database type betta

  /*getMethod() async {
    String theUrl = 'https://aithaibetta.000webhostapp.com/getdatatype.php';
    var res = await http.get(Uri.parse(theUrl));
    var responseBody = json.decode(res.body);

    print(responseBody);

    return responseBody;
  }*/



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _output == null
        ? Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/2.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.040),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),

                  SizedBox(height: size.height * 0.001),
                  const Padding(
                    padding: EdgeInsets.all(150.0),
                  ),
                  // button camera / gallery
                  SizedBox(height: size.height * 0.02),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _getFromCamera();
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                child: Image.asset("assets/images/camicon.png"),
                              ),
                            ),
                            const Text(
                              "ถ่ายรูป",
                              style: TextStyle(color: Colors.brown, fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.1),
                      InkWell(
                        onTap: () {
                          _getFromGallery();
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                child: Image.asset("assets/images/gallicon.png"),
                              ),
                            ),
                            const Text(
                              "เลือกรูปภาพ",
                              style: TextStyle(color: Colors.brown, fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    "เพื่อคัดแยกเกรดดาวเรือง",
                    style:
                    TextStyle(color: Colors.brown, fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        : Scaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height*0.01),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ผลการทำนาย",
                      style:TextStyle(
                        fontSize: 30.0,
                        color: Colors.brown.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height*0.001),
              Container(
                width: double.infinity,
                height: size.height*0.45,
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.all(8.0),
                ),
              ) ,
              SizedBox(height: size.height*0.0001),
              Column(
                children: [
                  Center(
                    child: Text(
                      "ดาวเรืองเกรด : $_name",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.brown.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height*0.01),
              Center(
                child: Text(
                  "ความแม่นยำ : $_confidence",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.brown.shade700,
                  ),
                ),
              ),
              SizedBox(height: size.height*0.01),

              SizedBox(height: size.height*0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _getFromCamera();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 120.0,
                        height: 120.0,
                        child: Image.asset("assets/images/camicon.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.1),
                  InkWell(
                    onTap: () {
                      _getFromGallery();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 120.0,
                        height: 120.0,
                        child: Image.asset("assets/images/gallicon.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

