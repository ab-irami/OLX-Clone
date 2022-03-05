import 'dart:io';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:galleryimage/galleryimage.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  static const String id = 'image_picker_widget';

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _uploading = false;

  Future getImage() async {
    final XFile? pickImage =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {
        print('No file selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    Future<String> uploadFile() async {
      File file = File(_image!.path);
      String imageName =
          'productImage/${DateTime.now().microsecondsSinceEpoch}';
      late String downloadURL;
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadURL =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();

        if (downloadURL != null) {
          setState(() {
            _image = null;
            _provider.getImages(downloadURL);
          });
        }
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.code} and cancelled')),
        );
      }
      return downloadURL;
    }

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Upload Images',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (_image != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          icon: const Icon(
                            Icons.clear,
                          ),
                        ),
                      ),
                    Container(
                      height: 120.0,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image == null
                            ? const Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.grey,
                              )
                            : Image.file(_image!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (_provider.listUrls.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GalleryImage(
                      imageUrls: _provider.listUrls,
                    ),
                  ),
                const SizedBox(
                  height: 10.0,
                ),
                if (_image != null)
                  Row(
                    children: [
                      Expanded(
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              _uploading = true;
                              uploadFile().then((url) {
                                if (url != null) {
                                  _uploading = false;
                                }
                              });
                            });
                          },
                          child: const Text(
                            'Save',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: Colors.red,
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImage,
                        style: NeumorphicStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          _provider.listUrls.isNotEmpty
                              ? 'Upload more Images'
                              : 'Upload Image',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (_uploading)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
