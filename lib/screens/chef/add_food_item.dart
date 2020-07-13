import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotels/models/food_item.dart';
import 'package:hotels/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddFoodItem extends StatefulWidget {
  final FoodItem foodItem;

  const AddFoodItem({Key key, this.foodItem}) : super(key: key);

  @override
  _AddFoodItemState createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  List categories = ['Veg', 'Non Veg', 'Italian', 'end'];
  var selectedCategory;
  var newSelectedCategory;
  var image;
  var imageUrl;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    selectedCategory =
        widget.foodItem == null ? 'Veg' : widget.foodItem.category;

    if (widget.foodItem != null) {
      _nameController = new TextEditingController(text: widget.foodItem.name);
      _priceController = new TextEditingController(text: widget.foodItem.price);
    }

    Future uploadImage(BuildContext context) async {
      if (image != null) {
        String filename = basename(image.path);
        StorageReference storageRef =
            FirebaseStorage.instance.ref().child(filename);
        StorageUploadTask uploadTask = storageRef.putFile(image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        print("uploaded");
        String imageUrl = await storageRef.getDownloadURL();
        setState(
          () {
            this.imageUrl = imageUrl;
          },
        );
      }
      if (widget.foodItem != null && imageUrl != null) {
        Database.deleteImage(widget.foodItem.image);
      }
      Navigator.pop(context);
      if (widget.foodItem != null) {
        Database.removeFood(widget.foodItem);
      }
      Database.addFood(
          _nameController.text,
          newSelectedCategory == null ? selectedCategory : newSelectedCategory,
          _priceController.text,
          imageUrl ?? widget.foodItem.image);
    }

    void _showBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        _getImageCam();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Camera'),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple,
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _getImage();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Gallery'),
                ],
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.foodItem != null
            ? Text('Update Item')
            : Text('Add New Item'),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 78,
                      backgroundColor: Colors.black87,
                      child: ClipOval(
                        child: SizedBox(
                          child: image != null
                              ? Image.file(
                                  image,
                                  fit: BoxFit.cover,
                                )
                              : widget.foodItem != null
                                  ? Image.network(
                                      widget.foodItem.image,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'images/food.png',
                                      fit: BoxFit.cover,
                                    ),
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: MediaQuery.of(context).size.width * .54,
                    child: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showBottomSheet();
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _nameController,
                      validator: (val) => val.isEmpty ? 'Enter the name' : null,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: 'Name',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2.0),
                        ),
                      ),
                      items: categories.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value == 'end' ? null : value,
                            child: value == 'end' ? addNew() : Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(
                          () {
                            selectedCategory = value;
                            newSelectedCategory = value;
                          },
                        );
                      },
                      value: selectedCategory,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _priceController,
                      validator: (val) =>
                          val.isEmpty ? 'Enter the price' : null,
                      decoration: InputDecoration(
                        hintText: 'Price',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        color: Colors.deepPurple,
                        child: widget.foodItem != null
                            ? Text('Update')
                            : Text('Add'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Adding Item...."),
                              ),
                            );
                            uploadImage(context);
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addNew() {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Icon(Icons.add_circle),
          Text('Add new category'),
        ],
      ),
      onTap: () {
//        _showPopUp();
      },
    );
  }

//  void _showPopUp() {
//    TextEditingController textController = new TextEditingController();
//    showDialog(
//      builder: (context) => AlertDialog(
//        title: Text('New Category'),
//        content: TextFormField(
//          controller: textController,
//          textCapitalization: TextCapitalization.words,
//          decoration: InputDecoration(
//            hintText: 'Enter category',
//          ),
//        ),
//        actions: <Widget>[
//          RaisedButton(
//            shape: StadiumBorder(),
//            color: Colors.deepPurple,
//            child: Text('Add'),
//            onPressed: () {
//              if (textController.text != null && textController.text != '') {
//                setState(() {
//                  categories.add(textController.text);
//                });
//              }
//              Navigator.of(context).pop();
//            },
//          )
//        ],
//      ),
//    );
//  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    setState(
      () {
        this.image = image;
      },
    );
  }

  Future _getImageCam() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 200, maxWidth: 200);
    setState(
      () {
        this.image = image;
      },
    );
  }
}
