import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:mappo/components/myButton.dart'; // Import the MyTextField widget
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({super.key});

  @override
  State<AddRestaurantPage> createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _foodTypeController = TextEditingController();
  final TextEditingController _restaurantTypeController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = path.basename(image.path);
      final storageRef = FirebaseStorage.instance.ref().child('restaurant_images/$fileName');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _addRestaurant() async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _foodTypeController.text.isEmpty ||
        _restaurantTypeController.text.isEmpty ||
        _rateController.text.isEmpty ||
        _ratingController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields and select an image')),
      );
      return;
    }

    try {
      final imageUrl = await _uploadImage(_image!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('restaurants').add({
        'name': _nameController.text,
        'address': _addressController.text,
        'foodType': _foodTypeController.text,
        'restaurantType': _restaurantTypeController.text,
        'image': imageUrl,
        'rate': _rateController.text,
        'rating': _ratingController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurant added successfully')),
      );

      Navigator.pop(context); // Go back to the previous page
    } catch (e) {
      print('Error adding restaurant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Restaurant"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add New Restaurant",
                      style: TextStyle(color: TColor.secondaryText, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _nameController,
                      hintText: "Restaurant Name",
                      obscureText: false,
                      icon: const Icon(Icons.restaurant),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _addressController,
                      hintText: "Address",
                      obscureText: false,
                      icon: const Icon(Icons.location_on),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _foodTypeController,
                      hintText: "Food Type",
                      obscureText: false,
                      icon: const Icon(Icons.fastfood),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _restaurantTypeController,
                      hintText: "Restaurant Type",
                      obscureText: false,
                      icon: const Icon(Icons.category),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 246, 164),
                            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.image, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(
                                _image == null ? "Pick Image" : "Image Selected",
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_image != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Image.file(_image!, height: 150),
                      ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _rateController,
                      hintText: "Rate",
                      obscureText: false,
                      icon: const Icon(Icons.star),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _ratingController,
                      hintText: "Rating",
                      obscureText: false,
                      icon: const Icon(Icons.rate_review),
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: _addRestaurant,
                      text: "Add",
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
