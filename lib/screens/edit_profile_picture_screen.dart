import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class EditProfilePictureScreen extends StatefulWidget {
  const EditProfilePictureScreen({super.key});

  @override
  State<EditProfilePictureScreen> createState() => _EditProfilePictureScreenState();
}

class _EditProfilePictureScreenState extends State<EditProfilePictureScreen> {
  File? _profileImage;
  File? _tempImage; // holds newly picked image before confirmation

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profileImagePath');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _profileImage = File(path);
        _tempImage = File(path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _tempImage = File(pickedFile.path);
    });
  }

  bool get _hasChanged {
    if (_tempImage == null && _profileImage == null) return false;
    if (_tempImage == null || _profileImage == null) return true;
    return _tempImage!.path != _profileImage!.path;
  }

  Future<void> _confirmImage() async {
    if (_tempImage == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('No image selected to confirm.')),
      );
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final name = basename(_tempImage!.path);
    final savedImage = await _tempImage!.copy('${directory.path}/$name');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', savedImage.path);

    setState(() {
      _profileImage = savedImage;
      _tempImage = savedImage;
    });

    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text('Profile picture saved!')),
    );

    Navigator.pop(context as BuildContext); // Go back to previous screen (MainMenuScreen)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Picture')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _tempImage != null
                ? CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(_tempImage!),
                  )
                : const CircleAvatar(
                    radius: 60,
                    child: Icon(Icons.person, size: 50),
                  ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload),
              label: const Text('Upload New Picture'),
            ),
            const SizedBox(height: 30),
            if (_hasChanged)
              ElevatedButton(
                onPressed: _confirmImage,
                child: const Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}