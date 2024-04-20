import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class FromSpeechToText extends StatefulWidget {
  const FromSpeechToText({Key? key}) : super(key: key);

  @override
  State<FromSpeechToText> createState() => _FromSpeechToTextState();
}

class _FromSpeechToTextState extends State<FromSpeechToText> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  final TextEditingController _notesController = TextEditingController();
  double _confidenceLevel = 0.0;
  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _confidenceLevel = result.confidence;
      if (result.finalResult) {
        _notesController.text = result.recognizedWords;
      }
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _confidenceLevel = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Assistant"),
        actions: [],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnabled
                        ? "Please tap on the microphone to start the voice assistant"
                        : "Permission denied for the microphone",
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: "Speak here...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null, // Allow multiple lines
                  keyboardType: TextInputType.multiline,
                  onTap: _startListening, // Start listening when tapped
                ),
              ),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Confidence : ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Listen',
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
