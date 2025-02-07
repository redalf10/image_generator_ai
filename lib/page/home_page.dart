import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _queryController = TextEditingController();
  final StabilityAI _ai = StabilityAI();

  final String apiKey =
      'sk-HM4xE6SBVvQQuCFopz3okDSHcSGVSCFteJCeBPmdLWN6xZUk'; // Replace with secure key management.
  final ImageAIStyle imageAIStyle = ImageAIStyle.anime;

  Uint8List? _generatedImage;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _generate(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Uint8List image = await _ai.generateImage(
        prompt: query,
        apiKey: apiKey,
        imageAIStyle: imageAIStyle,
      );
      setState(() {
        _generatedImage = image;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate image: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    _queryController.clear();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: _buildGenerateButton(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Fred AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildQueryInput(),
                const SizedBox(height: 100),
                _buildImageDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQueryInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
      ),
      child: TextField(
        controller: _queryController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Enter your prompt',
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildImageDisplay() {
    if (_isLoading) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xfffebc06),
          ),
          child: const Column(
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text('Generating...'),
            ],
          ),
        ),
      );
    } else if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    } else if (_generatedImage != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: Colors.white,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(_generatedImage!),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'No image generated yet.',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          String query = _queryController.text.trim();
          if (query.isNotEmpty) {
            _generate(query);
          } else {
            if (kDebugMode) {
              print('Query is empty!');
            }
            setState(() {
              _errorMessage = 'Please enter a prompt to generate an image.';
            });
          }
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xfffebc06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
            ),
          ),
          child: const Center(
            child: Text(
              'Generate',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
