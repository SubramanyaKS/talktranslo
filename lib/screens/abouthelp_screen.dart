import 'package:flutter/material.dart';
import 'package:talktranslo/utils/constant.dart';
import 'package:talktranslo/utils/language.dart';
// import 'package:url_launcher/url_launcher.dart';

class AbouthelpScreen extends StatefulWidget {
  const AbouthelpScreen({super.key});

  @override
  State<AbouthelpScreen> createState() => _AbouthelpScreenState();
}

class _AbouthelpScreenState extends State<AbouthelpScreen> {
  final String appVersion = "1.0.0";

  // Future<void> _launchUrl(String url) async {
  //  Uri uri= Uri.parse(url);
  //   if (!await launchUrl(uri)) {
  //     throw Exception('Could not launch $uri');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,title: Text("About & Help", style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(HEADING.toUpperCase(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
            ),
            SizedBox(height: 8),
            Center(child: Text("Version: $appVersion", style: TextStyle(fontSize: 16))),
            SizedBox(height: 20),
            Text("About our Application",style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(ABOUT),
            SizedBox(height: 20),
            Text("Frequently Asked Questions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: questionAnswer.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ExpansionTile(
                  title: Text(questionAnswer[index]["Q"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(questionAnswer[index]["A"]!),
                    ),
                  ],
                ),
              );
            },
          ),
        ),


            // Text(
            //     "Q: How do I translate text?\nA: Simply enter text and press 'Translate'.",
            //     style: TextStyle(fontSize: 16)),
            // SizedBox(height: 10),
            // Text(
            //     "Q: How do I enable speech translation?\nA: Go to 'Speech & Audio' settings and enable voice output.",
            //     style: TextStyle(fontSize: 16)),
            // SizedBox(height: 20),
            //
            // Text("Need Help?",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // ElevatedButton(
            //   onPressed: () => _launchUrl("mailto:phasepics@gmail.com"),
            //   child: Text("Contact Support"),
            // ),
            // ElevatedButton(
            //   onPressed: () => _launchUrl("https://subramanyaks.github.io"),
            //   child: Text("Visit Website"),
            // ),
          ],
        ),
      ),
    );
  }
}
