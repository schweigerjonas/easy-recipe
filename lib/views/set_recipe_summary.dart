import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/creation_model.dart';

class SetRecipeSummary extends StatefulWidget {
  const SetRecipeSummary({super.key});

  @override
  State<SetRecipeSummary> createState() => _SetRecipeSummaryState();
}

class _SetRecipeSummaryState extends State<SetRecipeSummary> {
  final summaryController = TextEditingController();

  Reference storageRef = FirebaseStorage.instance.ref();
  final picker = ImagePicker();
  File? _image;
  String? _imageUrl;

  @override
  void dispose() {

    super.dispose();
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadImage(String recipeTitle) async {
    if (_image == null && (_imageUrl == null || _imageUrl!.isEmpty)) return;

    recipeTitle = recipeTitle.toLowerCase().replaceAll(" ", "-");
    storageRef = storageRef.child('recipe-images/$recipeTitle');

    if (_image != null) {
      await storageRef.putFile(_image!);
    } else {
      await storageRef.putString(_imageUrl!, format: PutStringFormat.dataUrl);
    }

    _imageUrl = await storageRef.getDownloadURL();


    // TODO: Show Snackbar after successfully uploading the complete recipe
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Summary',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: ListView(
              children: [
                const Text(
                  'Summary',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: summaryController,
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: <Widget>[
                    Container(
                      height: 320.0,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                      child: _image == null
                          ? const Center(child: Text("Choose or create an Image for your Recipe"))
                          : Image.file(_image!),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: getImageFromGallery,
                          icon: const Icon(Icons.image_search),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          onPressed: getImageFromCamera,
                          icon: const Icon(Icons.photo_camera_outlined),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<CreationModel>(context, listen: false)
                      .setPageIndex(2);
                },
                child: const Text('Back'),
              ),
              Consumer<CreationModel>(
                builder: (context, creation, _) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () async {
                    // TODO: handle no image selected
                    creation.setSummary("<p>${summaryController.text}<p>");
                    await uploadImage(creation.getRecipeTitle());
                    creation.setImageUrl(_imageUrl!);
                    creation.setScore(0.0);
                    creation.setId();
                    creation.setPageIndex(4);
                  },
                  child: const Text('Next Step'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
