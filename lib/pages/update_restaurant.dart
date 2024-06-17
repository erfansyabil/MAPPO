import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/components/myTextField.dart';
import 'package:mappo/components/myButton.dart';
import 'package:mappo/pages/classes.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class UpdateRestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

  const UpdateRestaurantPage({super.key, required this.restaurant});

  @override
  _UpdateRestaurantPageState createState() => _UpdateRestaurantPageState();
}

class _UpdateRestaurantPageState extends State<UpdateRestaurantPage> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _foodTypeController;
  late TextEditingController _restaurantTypeController;
  late TextEditingController _rateController;
  late TextEditingController _ratingController;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.restaurant.id);
    _nameController = TextEditingController(text: widget.restaurant.name);
    _addressController = TextEditingController(text: widget.restaurant.address);
    _foodTypeController = TextEditingController(text: widget.restaurant.foodType);
    _restaurantTypeController = TextEditingController(text: widget.restaurant.restaurantType);
    _rateController = TextEditingController(text: widget.restaurant.rate);
    _ratingController = TextEditingController(text: widget.restaurant.rating.toString());
  }

  Future<void> _pickImage() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('Storage permission is required to pick an image.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

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
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> updateRestaurant(String restaurantId) async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _foodTypeController.text.isEmpty ||
        _restaurantTypeController.text.isEmpty ||
        _rateController.text.isEmpty ||
        _ratingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
        if (imageUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
          return;
        }
      }

      final updateData = {
        'name': _nameController.text,
        'address': _addressController.text,
        'foodType': _foodTypeController.text,
        'restaurantType': _restaurantTypeController.text,
        'rate': _rateController.text,
        'rating': _ratingController.text,
      };

      if (imageUrl != null) {
        updateData['image'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .update(updateData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurant updated successfully')),
      );

      Navigator.pop(context); // Go back to the previous page
    } catch (e) {
      debugPrint('Error updating restaurant: $e');
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
        title: const Text('Update Restaurant'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
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
                      "Update Restaurant",
                      style: TextStyle(color: TColor.secondaryText, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _idController,
                      hintText: "Restaurant ID",
                      obscureText: false,
                      icon: const Icon(Icons.perm_identity),
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
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
                              const Icon(Icons.image, color: Color.fromARGB(255, 0, 0, 0)),
                              const SizedBox(width: 10),
                              Text(
                                _image == null ? "Pick Image" : "Image Selected",
                                style: const TextStyle(color:  Color.fromARGB(255, 0, 0, 0)),
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
                      onTap: () {
                        updateRestaurant(widget.restaurant.id);
                      },
                      text: "Update",
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
