import 'package:flutter/material.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/pages/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewPage extends StatefulWidget {
  final Restaurant restaurant;

  const ReviewPage({super.key, required this.restaurant});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;

  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _fetchUserName();
    }
  }

    Future<void> _fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          usernameController.text = data['username'] ?? '';
          isLoading = false;
        });
      } else  {
        debugPrint('User document does not exist'); 
        setState(() {
          isLoading = false;
          });
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('restaurants').doc(widget.restaurant.id).collection('reviews').add({
          'reviewerName': usernameController.text, 
          'comment': _commentController.text,
          'rating': _rating,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user!.uid,
        });
        Navigator.pop(context);
      } catch (e) {
        debugPrint('Error adding review: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Review',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a Review for ${widget.restaurant.name}',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: 'Comment',
                        labelStyle: TextStyle(color: TColor.primaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: TColor.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: TColor.primary),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a comment';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<double>(
                      value: _rating,
                      decoration: InputDecoration(
                        labelText: 'Rating',
                        labelStyle: TextStyle(color: TColor.primaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: TColor.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: TColor.primary),
                        ),
                      ),
                      items: [0.0, 1.0, 2.0, 3.0, 4.0, 5.0]
                          .map((double value) => DropdownMenuItem<double>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _addReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
