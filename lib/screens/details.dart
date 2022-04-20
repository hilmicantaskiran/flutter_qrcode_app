import 'package:flutter/material.dart';
import 'package:flutter_qrcode_app/assets/style/palette.dart';
import 'package:flutter_qrcode_app/screens/home.dart';
import 'package:flutter_qrcode_app/screens/qrcode.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.qrText}) : super(key: key);

  final String qrText;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        shadowColor: Colors.transparent,
        backgroundColor: Palette.greyToDark[400],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  parseVCardFromString(widget.qrText),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Palette.greyToDark[400],
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRCodePage(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Scan QR Code Again'),
            ),
          ],
        ),
      ),
    );
  }
}

parseVCardFromString(String qrText) {
  try {
    var begin = qrText.split('BEGIN:VCARD');
    var end = begin[1].split('END:VCARD');
    var vCard = end[0];
    var vCardList = vCard.split('\n');
    var vCardString = 'Name: ${vCardList[3].split(':')[1]}\n'
        'Title: ${vCardList[4].split(':')[1]}\n'
        'Organization: ${vCardList[5].split(':')[1]}\n'
        'Email: ${vCardList[6].split(':')[1]}\n';
    return vCardString;
  } catch (e) {
    return qrText;
  }
}
