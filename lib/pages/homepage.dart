import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectgradingmarigold/pages/api.dart';
import 'package:projectgradingmarigold/pages/datasize.dart';
import 'package:http/http.dart' as http ;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;


late File images;
int sumpixs = 0;

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late File _image;
  File? imageFile;
  final picker = ImagePicker();
  var id;
  String detail = "";
  int sumpix = 0;
  var size;


  @override
  /*void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
      });
    });
  }*/

  // Model
  /*loadModel() async {
    await Tflite.loadModel(
        model: "assets/model/modelver3.tflite",
        labels: "assets/model/labels.txt");
  }*/

  _getFromCamera() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    //cropImage(image.path);
  }


  _getFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    //cropImage(image.path);
  }


  Future<void> uploadFile() async {
    var docFile = _image;
    var stream  = new http.ByteStream(_image.openRead());
    stream.cast();
    var length = await docFile.length(); // file length
    var mimeType = lookupMimeType(docFile.path); // mime type

    /*Map<String, String> headers = {
    //"Accept": "application/json",
    //"Authorization": "Bearer " + token
  }; // ignore this headers if there is no authentication*/

    // string to uri
    var uri = Uri.parse('http://34.125.105.79/test'); // xxx = API endpoint's URL

    // create multipart request
    var request = http.MultipartRequest('POST', uri);

    // multipart that takes file
    var multipartFileSign = http.MultipartFile(
      'file', // ตั้งชื่อว่า 'file', ฝั่ง API ต้องระบุถึงชื่อนี้
      stream,
      length,
      filename: p.basename(docFile.path),
    );

    // add file to multipart
    request.files.add(multipartFileSign);

    //add headers
    //request.headers.addAll(headers);

    //adding more params
    /*request.fields['loginId'] = '12';
request.fields['firstName'] = 'abc';
request.fields['lastName'] = 'efg';*/

    // send
    var response = await request.send();
    _handleResponse(response);
  }

  dynamic _handleResponse(http.StreamedResponse response) async {
    switch (response.statusCode) {
      case 200:

        var responseData = await response.stream.toBytes();


        String result = String.fromCharCodes(responseData);
        var re = Api.fromJson(jsonDecode(result));

        setState(() {
          sumpix = re.sumpix;
        });
        print(re.sumpix);
        break;
      default:
        throw Exception(
            'เกิดข้อผิดพลาดในการอัพโหลดไฟล์ (status code: ${response.statusCode})');
    }
  }





  // database type betta

  /*getMethod() async {
    String theUrl = 'http://34.125.105.79/test';
    var res = await http.get(Uri.parse(theUrl));
    var responseBody = json.decode(res.body);

    print(responseBody);

    return responseBody;
  }*/



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                                width: 80.0,
                                height: 80.0,
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
                          images = _image;
                          sumpixs = sumpix;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  Show()),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: 80.0,
                                height: 80.0,
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
                      SizedBox(width: size.width * 0.1),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  DataSizePage()),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                child: Image.asset("assets/images/data.png"),
                              ),
                            ),
                            const Text(
                              "ข้อมูลขนาดดอกดาวเรือง",
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
    );
  }

}

class Show extends StatefulWidget {
  const Show({Key? key }) : super(key: key);

  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height*0.01,
                ),
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
                      images,
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(8.0),
                  ),
                ),
                SizedBox(height: size.height*0.0001),
                Column(
                  children: [
                    Center(
                      child: Text(
                        'เกรด : $sumpixs',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.brown.shade700,
                        ),
                      ),

                    )
                  ],
                )
              ],
            ),


          ),
        )
    );
  }
}
