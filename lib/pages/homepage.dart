import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectgradingmarigold/pages/api.dart';
import 'package:projectgradingmarigold/pages/datasize.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;


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
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    //cropImage(image.path);
  }

  _getFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    //cropImage(image.path);
  }

  Future<void> uploadFile() async {
    var docFile = _image;
    var stream = http.ByteStream(_image.openRead());
    stream.cast();
    var length = await docFile.length(); // file length
    var mimeType = lookupMimeType(docFile.path); // mime type

    /*Map<String, String> headers = {
    //"Accept": "application/json",
    //"Authorization": "Bearer " + token
  }; // ignore this headers if there is no authentication*/

    // string to uri
    var uri =
    Uri.parse('http://34.125.105.79/test'); // xxx = API endpoint's URL

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
                        onTap: () async {
                          await _getFromCamera();
                          await uploadFile();
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowResultsPage(
                                  images: _image,
                                  sumpixs: sumpix,
                                )),
                          );
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
                              style: TextStyle(
                                  color: Colors.brown, fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.1),
                      InkWell(
                        onTap: () async {
                          await _getFromGallery();
                          await uploadFile();
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowResultsPage(
                                  images: _image,
                                  sumpixs: sumpix,
                                )),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                child:
                                Image.asset("assets/images/gallicon.png"),
                              ),
                            ),
                            const Text(
                              "เลือกรูปภาพ",
                              style: TextStyle(
                                  color: Colors.brown, fontSize: 14.0),
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
                            MaterialPageRoute(
                                builder: (context) => DataSizePage()),
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
                              style: TextStyle(
                                  color: Colors.brown, fontSize: 14.0),
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
                    style: TextStyle(color: Colors.brown, fontSize: 18.0),
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

class ShowResultsPage extends StatefulWidget {
  const ShowResultsPage({Key? key, required this.images, required this.sumpixs})
      : super(key: key);

  final File images;
  final int sumpixs;


  @override
  State<ShowResultsPage> createState() => _ShowResultsPageState();
}

class _ShowResultsPageState extends State<ShowResultsPage> {
  String? grade;
  final picker = ImagePicker();
  late File _image;
  int sumpix = 0;

  _getFromCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    //cropImage(image.path);
  }

  _getFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    //cropImage(image.path);
  }

  Future<void> uploadFile() async {
    var docFile = _image;
    var stream = http.ByteStream(_image.openRead());
    stream.cast();
    var length = await docFile.length(); // file length
    var mimeType = lookupMimeType(docFile.path); // mime type

    /*Map<String, String> headers = {
    //"Accept": "application/json",
    //"Authorization": "Bearer " + token
  }; // ignore this headers if there is no authentication*/

    // string to uri
    var uri =
    Uri.parse('http://34.125.105.79/test'); // xxx = API endpoint's URL

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

  // ค้นหาเกรด
  String findGrade(int sumpixs) {
    if(sumpixs > 60000){
      return "ERROR";
    }
    else if(sumpixs > 5000 && sumpixs <= 15000) {
      return "S";
    }
    else if(sumpixs >= 15001 && sumpixs <= 20000) {
      return "M";
    }
    else if(sumpixs >= 20001 && sumpixs <= 30000){
      return "L";
    }
    else if(sumpixs > 30000) {
      return "XL";
    }
    else if (sumpixs < 5000) {
      return "far";
    }
    return "undefined";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    grade = findGrade(widget.sumpixs);

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
                  height: size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ผลการทำนาย",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.brown.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.001),
                Container(
                  width: double.infinity,
                  height: size.height * 0.45,
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(
                      widget.images,
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(8.0),
                  ),
                ),
                SizedBox(height: size.height * 0.0001),
                Column(
                  children: [
                    Center(
                      child: findAnswer(),
                    ),
                    SizedBox(height: size.height * 0.0001),
                    TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DataSizePage()),
                        ), child: Text('แสดงข้อมูลดอกดาวเรือง',style: TextStyle(fontSize: 20.0,color: Colors.blueGrey),)),
                    SizedBox(height: size.height*0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await _getFromCamera();
                            await uploadFile();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowResultsPage(
                                    images: _image,
                                    sumpixs: sumpix,
                                  )),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              width: 90.0,
                              height: 90.0,
                              child: Image.asset("assets/images/camicon.png"),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.1),
                        InkWell(
                          onTap: () async {
                            await _getFromGallery();
                            await uploadFile();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowResultsPage(
                                    images: _image,
                                    sumpixs: sumpix,
                                  )),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              width: 90.0,
                              height: 90.0,
                              child: Image.asset("assets/images/gallicon.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: size.width * 0.1),
                    TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()),
                        ), child: Text('กลับสู่หน้าหลัก',style: TextStyle(fontSize: 25.5,color: Colors.red),)),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget findAnswer() {
    if (grade!.contains("far")) {
      return Text(
        'รูปภาพอยู่ไกลเกินไป',
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.brown.shade700,
        ),
      );
    } else if (grade!.contains("colse")) {
      return Text(
        'รูปภาพอยู่ใกล้เกินไป',
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.brown.shade700,
        ),
      );
    } else if (grade!.contains("undefined")) {
      return Text(
        "ไม่สามารถระบุได้",
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.brown.shade700,
        ),
      );
    }else if (grade!.contains("ERROR")) {
      return Text(
        "รูปภาพนี้ไม่ใช่ดอกดาวเรือง",
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.brown.shade700,
        ),
      );
    }
    return Text(
      'เกรด : $grade',
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.brown.shade700,
      ),
    );
  }
}
