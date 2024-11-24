import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(PostApp());
}

class PostApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map<String, dynamic>? _post; // Holds the fetched post data
  bool _isLoading = false; // Tracks loading state

  Future<void> fetchRandomPost() async {
    setState(() {
      _isLoading = true;
      _post = null;
    });

    try {
      // Generate a random post ID between 1 and 100
      final int postId = Random().nextInt(100) + 1;

      // Fetch data from JSONPlaceholder
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));

      if (response.statusCode == 200) {
        setState(() {
          _post = json.decode(response.body); // Parse the JSON response
        });
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error) {
      // Handle errors
      setState(() {
        _post = {'title': 'Error', 'body': 'Failed to fetch post.'};
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Post Fetcher'),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading spinner
            : _post != null
                ? PostDisplay(post: _post!) // Display fetched post
                : const Text(
                    'Press the button to fetch a random post!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchRandomPost,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class PostDisplay extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDisplay({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Post ID: ${post['id']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Title:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            post['title'],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text(
            'Body:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            post['body'],
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
