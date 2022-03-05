import 'package:ecom_app/forms/user_review_screen.dart';
import 'package:ecom_app/provider/cat_provider.dart';
import 'package:ecom_app/services/firebase_services.dart';
import 'package:ecom_app/widgets/image_picker_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

class SellerCarForm extends StatefulWidget {
  const SellerCarForm({Key? key}) : super(key: key);

  static const String id = 'seller_car_form';

  @override
  State<SellerCarForm> createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  final FirebaseService _service = FirebaseService();

  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _fuelController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _kmController = TextEditingController();
  final _noOfOwnerController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final String _address = '';

  validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (provider.listUrls.isNotEmpty) {
        provider.dataToFirestore.addAll({
          'category': provider.selectedCategory,
          'subCat': null,
          'brand': _brandController.text,
          'year': _yearController.text,
          'price': _priceController.text,
          'fuel': _fuelController.text,
          'transmission': _transmissionController.text,
          'kmDrive': _kmController.text,
          'noOfOwners': _noOfOwnerController.text,
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

  final List<String> _fuelList = ['Diesel', 'Petrol', 'ELectric', 'LPG'];
  final List<String> _transmission = ['Manually', 'Automatic'];
  final List<String> _noOfOwners = ['1', '2nd', '3rd', '4th', '4th+'];

  @override
  void didChangeDependencies() {
    var _catProvider = Provider.of<CategoryProvider>(context);
    setState(() {
      _brandController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['brand'];
      _yearController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['year'];
      _priceController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['price'];
      _fuelController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['fuel'];
      _transmissionController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['transmission'];
      _kmController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['kmDrive'];
      _noOfOwnerController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['noOfOwners'];
      _titleController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['title'];
      _descriptionController.text = _catProvider.dataToFirestore.isEmpty
          ? null
          : _catProvider.dataToFirestore['description'];
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, fieldValue) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Text(
          '$title > $fieldValue',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, 'brands'),
            Expanded(
              child: ListView.builder(
                  itemCount: _catProvider.doc['models'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        _catProvider.doc['models'][index],
                      ),
                      onTap: () {
                        setState(() {
                          _brandController.text =
                              _catProvider.doc['models'][index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  }),
            ),
          ],
        ),
      );
    }

    Widget _listView({fieldValue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, fieldValue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                }),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Add some details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _brandList();
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _brandController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Brand / Model / Variant',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field.';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Year*',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field.';
                      }
                      return null;
                    },
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
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                              fieldValue: 'Fuel',
                              list: _fuelList,
                              textController: _fuelController,
                            );
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _fuelController,
                      decoration: const InputDecoration(
                        labelText: 'Fuel*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field.';
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                              fieldValue: 'Transmission',
                              list: _transmission,
                              textController: _transmissionController,
                            );
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _transmissionController,
                      decoration: const InputDecoration(
                        labelText: 'Transmission*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field.';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _kmController,
                    decoration: const InputDecoration(
                      labelText: 'KM Driver*',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field.';
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                              fieldValue: 'NO of Owners',
                              list: _noOfOwners,
                              textController: _noOfOwnerController,
                            );
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _noOfOwnerController,
                      decoration: const InputDecoration(
                        labelText: 'No. of owners*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field.';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                        labelText: 'Add Title*',
                        helperText:
                            'Mention the key features(e.g Brand, Model)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field.';
                      }
                      if (value.length < 15) {
                        return 'Needs atleast 15 characters';
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
                            'Include condition, features, reason for selling'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field.';
                      }
                      if (value.length < 40) {
                        return 'Needs atleast 40 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: (_catProvider.listUrls.isEmpty)
                        ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'No images selected',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GalleryImage(
                            imageUrls: _catProvider.listUrls,
                          ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
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
                          child: Text(_catProvider.listUrls.isNotEmpty
                              ? 'Upload more Images'
                              : 'Upload Image'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                ],
              ),
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
                  validate(_catProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


///automatic image not loading & showing in image widget