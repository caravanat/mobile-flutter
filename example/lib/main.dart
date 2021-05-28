import 'package:flutter/material.dart';
import 'package:jumio_mobile_sdk_flutter/jumio_mobile_sdk_flutter.dart';
import 'package:jumiomobilesdk_example/credentials.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(
          title: "Mobile SDK Demo App",
        ));
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState(title);
}

class _HomePageState extends State<HomePage> {
  final String title;

  _HomePageState(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child: Text("Start Netverify"),
                onPressed: () {
                  _startNetverify();
                },
              ),
              RaisedButton(
                child: Text("Start Document Verification"),
                onPressed: () {
                  startAuthentication();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startNetverify() async {
    await _logErrors(() async {
      await JumioMobileSDK.initNetverify(API_TOKEN, API_SECRET, DATACENTER, {
        "enableVerification": true,
        "enableIdentityVerification": true,
        "userReference": "39761479749", //What to set? Numero do documento no Digital, identificador do usuário (Ideal é o BTG ID)
        //merchantScanReference: regra pro identificador de usuário (eles usam date e cpf)
        "preselectedCountry": "BRA",
        "cameraPosition": "BACK",
        "documentTypes": ["DRIVER_LICENSE", "IDENTITY_CARD"],
        //Quais serão os docs aceitos?
        "enableWatchlistScreening": "ENABLED",
        "sendDebugInfoToJumio": true,
        "preselectedDocumentVariant": "PAPER"
        //"watchlistSearchProfile": "YOURPROFILENAME"
      });
      final result = await JumioMobileSDK.startNetverify();
      await _showDialogWithMessage("Netverify has completed. Result: $result");
    });
  }

  Future<void> startAuthentication() async {
    await _logErrors(() async {
      await JumioMobileSDK.initAuthentication(
          API_TOKEN, API_SECRET, DATACENTER, {
        "enrollmentTransactionReference": 'a74a4f26-9be4-434d-a320-cb87d7c542c0',
        "userReference": "11780859708",
      });
      final result = await JumioMobileSDK.startAuthentication();
      await _showDialogWithMessage(
          "Document verification completed with result: " + result.toString());
    });
  }

  Future<void> _logErrors(Future<void> Function() block) async {
    try {
      await block();
    } catch (error) {
      await _showDialogWithMessage(error.toString(), "Error");
    }
  }

  Future<void> _showDialogWithMessage(String message,
      [String title = "Result"]) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(message)),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
