import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:read_aloudapp/Utils/pick_doc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();

  FlutterTts flutterTts = FlutterTts();

  void speak({String? text}) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);

    try {
      await flutterTts.speak(text!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void stop() async {
    await flutterTts.stop();
  }

  void pause() async {
    await flutterTts.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Aloud', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.stop,
              color: Colors.white,
            ),
            onPressed: () {
              stop();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              controller.clear();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.mic,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                print(controller.text);
                speak(text: controller.text);
              }
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 148, 58, 183),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: controller,
          maxLines: MediaQuery.of(context).size.height.toInt(),
          decoration: const InputDecoration(
              border: InputBorder.none, label: Text("Text to read...")),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            pickDocument().then((value) async {
              if (value != '') {
                // get the file and decode using pdf_text
                PDFDoc doc = await PDFDoc.fromPath(value!);
                final text = await doc.text;
                controller.text = text;
              }
            });
          },
          label: const Text("Pick file here")),
    );
  }
}
