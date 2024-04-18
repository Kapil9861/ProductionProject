import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class FromSpeechToText extends StatefulWidget {
  const FromSpeechToText({super.key});

  @override
  State<FromSpeechToText> createState() => _FromSpeechToTextState();
}

class _FromSpeechToTextState extends State<FromSpeechToText> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = "";
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

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
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
                child: Text(
                  _wordsSpoken,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Confidence : ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
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
