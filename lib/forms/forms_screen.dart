import 'package:ecom_app/forms/form_class.dart';
import 'package:ecom_app/forms/user_review_screen.dart';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:ecom_app/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({Key? key}) : super(key: key);

  static const String id = 'forms_screen';

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final FormClass _formClass = FormClass();
  final FirebaseService _service = FirebaseService();
  final _formKey = GlobalKey<FormState>();

  final _brandTextController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathrooms = TextEditingController();
  final _furnishing = TextEditingController();
  final _constructionStatus = TextEditingController();
  final _buildingSqft = TextEditingController();
  final _carpetSqft = TextEditingController();
  final _totalFLoors = TextEditingController();

  validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (provider.listUrls.isNotEmpty) {
        provider.dataToFirestore.addAll({
          'category': provider.selectedCategory,
          'subCat': provider.selectedSubCategory,
          'brand': _brandTextController.text,
          'type': _typeController.text,
          'bedrooms': _bedroomsController.text,
          'bathrooms': _bathrooms.text,
          'furnishing': _furnishing.text,
          'constructionStatus': _constructionStatus.text,
          'buildingSqft': _buildingSqft.text,
          'carpetSqft': _carpetSqft.text,
          'totalFloors': _totalFLoors.text,
          'price': _priceController.text,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'sellerUid': _service.user!.uid,
          'images': provider.listUrls,
          'postedAt': DateTime.now().microsecondsSinceEpoch,
          'favourite': [],
        });

        Navigator.pushNamed(context, UserReviewScreen.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image not uploaded'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all the required fields.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showBrandDialog(list, textController) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formClass.appBar(_provider),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            textController.text = list[index];
                          });
                          Navigator.pop(context);
                        },
                        title: Text(list[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    showFormDialog(list, textController) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formClass.appBar(_provider),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          textController.text = list[index];
                        });
                        Navigator.pop(context);
                      },
                      title: Text(list[index]),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text(
          'Add some details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_provider.selectedCategory} > ${_provider.selectedSubCategory}',
                ),
                if (_provider.selectedSubCategory == 'Mobile Phone')
                  InkWell(
                    onTap: () {
                      showBrandDialog(
                          _provider.doc['brands'], _brandTextController);
                    },
                    child: TextFormField(
                      controller: _brandTextController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Brand',
                      ),
                    ),
                  ),
                if (_provider.selectedSubCategory == 'Accessories' ||
                    _provider.selectedSubCategory == 'Tablets' ||
                    _provider.selectedSubCategory ==
                        'For Sale: House & Apartments' ||
                    _provider.selectedSubCategory ==
                        'For Rent: House & Apartments')
                  InkWell(
                    onTap: () {
                      if (_provider.selectedSubCategory == 'Accessories') {
                        showFormDialog(_formClass.accessories, _typeController);
                      }
                      if (_provider.selectedSubCategory == 'Tablets') {
                        showFormDialog(_formClass.tablets, _typeController);
                      }
                      if (_provider.selectedSubCategory ==
                              'For Sale: House & Apartments' ||
                          _provider.selectedSubCategory ==
                              'For Rent: House & Apartments') {
                        showFormDialog(
                            _formClass.apartmentType, _typeController);
                      }
                    },
                    child: TextFormField(
                      controller: _typeController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                      ),
                    ),
                  ),
                if (_provider.selectedSubCategory ==
                        'For Sale: House & Apartments' ||
                    _provider.selectedSubCategory ==
                        'For Rent: House & Apartments')
                  Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showFormDialog(
                                _formClass.numbers, _bedroomsController);
                          },
                          child: TextFormField(
                            controller: _bedroomsController,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Bedrooms',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showFormDialog(_formClass.numbers, _bathrooms);
                          },
                          child: TextFormField(
                            controller: _bathrooms,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Bathrooms',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showFormDialog(_formClass.furnishing, _furnishing);
                          },
                          child: TextFormField(
                            controller: _furnishing,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Furnishing',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showFormDialog(
                                _formClass.consStatus, _constructionStatus);
                          },
                          child: TextFormField(
                            controller: _constructionStatus,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Construction Status',
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _buildingSqft,
                          keyboardType: TextInputType.number,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Building SQFT',
                          ),
                        ),
                        TextFormField(
                          controller: _carpetSqft,
                          keyboardType: TextInputType.number,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Carpet SQFT',
                          ),
                        ),
                        TextFormField(
                          controller: _totalFLoors,
                          keyboardType: TextInputType.number,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Total Floors',
                          ),
                        ),
                      ],
                    ),
                  ),
                TextFormField(
                  autofocus: false,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Price*', prefixText: 'Rs '),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field.';
                    }
                    if (value.length < 5) {
                      return 'Require minimum price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                      labelText: 'Add Title*',
                      helperText: 'Mention the key features(e.g Brand, Model)'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLength: 4000,
                  minLines: 2,
                  maxLines: 30,
                  decoration: const InputDecoration(
                    labelText: 'Description*',
                    helperText:
                        'Include condition, features, reason for selling',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field.';
                    }
                    if (value.length < 30) {
                      return 'Needs atleast 30 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                const Divider(color: Colors.grey),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: (_provider.listUrls.isNotEmpty)
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'No images selected',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : GalleryImage(
                          imageUrls: _provider.listUrls,
                        ),
                ),
                const SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ImagePickerWidget();
                        });
                  },
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Container(
                      height: 40.0,
                      child: Center(
                        child: Text(_provider.listUrls.isNotEmpty
                            ? 'Upload more Images'
                            : 'Upload Image'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80.0),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  validate(_provider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
