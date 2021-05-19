import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Caller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Api Caller'),
    );
  }
}

class FunkyNotification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyNotificationState();
}

class FunkyNotificationState extends State<FunkyNotification>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    position = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

    controller.forward();
  }

  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 32.0, right: 30),
            child: SlideTransition(
              position: position,
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Notification!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  OverlayEntry _overlayEntry;

  void _incrementCounter() async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      //anything after this will not be called if this has been called once before
      _overlayEntry = null;
    }
    // setState(() {
    //   _counter++;
    // });

    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return FunkyNotification();
    });

    Navigator.of(context)
        .overlay
        .insert(_overlayEntry);

    await Future.delayed(Duration(seconds: 3));
    if(_overlayEntry != null){
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

  }

  String textRes;
  bool loading = false;

  TextEditingController _textEditingController = new TextEditingController();

  void requestWithUrl(String url) async {
    final uri = Uri.parse(url);
    setState(() {
      loading = true;
    });
    var res = await http.Client().get(uri);
    print(res.body.toString());
    if(res.body != null){
      setState(() {
        textRes = res.body.toString();
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("last_request_url", url);
  }

  void getLastRequestUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final lastRequest = prefs.getString("last_request_url");
    setState(() {
      _textEditingController.text = lastRequest;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _textEditingController.text = 'https://testapi.io/api/tuannq3/test';

    getLastRequestUrl();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context).size.width;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   'You have pushed the button this many times:',
          // ),
          // Text(
          //   '$_counter',
          //   style: Theme.of(context).textTheme.headline4,
          // ),
          Container(
            width:  width,
            margin: EdgeInsets.only(left: 10,right: 10, top: 10),
            height:  120,
            child: TextFormField(
              // autocorrect: true,
              maxLines: 3,
              keyboardType:  TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              // maxLength: 1,
              decoration:
              InputDecoration(
                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  focusedErrorBorder:
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  enabledBorder:
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorStyle: TextStyle(color: Colors.red,),
                  border: InputBorder.none,
                  hintText: "Enter...",
                  hintStyle: TextStyle(
                    color: Color(0xff4D4D4D).withOpacity(0.5),
                  ),
                  isDense: true,
                  errorMaxLines: 2,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  errorText: ""
              ),
              controller: _textEditingController,
              // textAlign: alignLeft! ? TextAlign.left : TextAlign.center,
              cursorColor: Colors.blueAccent,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: (){
                requestWithUrl(_textEditingController.text);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)
                ),
                height: 50,
                width: width,
                margin: EdgeInsets.only(left: 10,right: 10, top: 20),
                child: Center(
                  child: Text('Request', style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          loading ? Center(
            child: Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.only(bottom: 10),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ) : Container(),
          textRes != null && textRes.isNotEmpty ?
          Container(
            width: width,
            margin: EdgeInsets.only(left: 10,right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Text(
              textRes ?? '',
              style: TextStyle(color: Colors.black),
            ),
          ) : Container()
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
