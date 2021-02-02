import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../app/app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';


class Animal {
  final int id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}


class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool _edited = false;
  File _image;
  String _url;

  String valueChoose;
  String camps;

  List venues = [
    "Empire-Boston",
    "Mystique-BostonHarbor",
  ];

  List preferred = [
    "Remy Martin",
    "Dom Perignon",
    "Havana Club Mojito",
  ];

  static List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];


  final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();
  List<Animal> _selectedAnimals = [];
  List<Animal> _selectedAnimals2 = [];


  final _multiSelectKey = GlobalKey<FormFieldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Form(
            onChanged: () => setState(() => _edited = true),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      //  onTap: () => html.window.location.href = "camera1.html",
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                              _image == null ? null : FileImage(_image),
                              radius: 70,
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: pickImage,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 30.0),
                                // GestureDetector(
                                //   onTap: pickImage,
                                //   child: Icon(
                                //     Icons.collections,
                                //     size:30,
                                //     color: Colors.white,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        // child: Container(
                        //   width: 140.0,
                        //   height: 140.0,
                        //   decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: AssetImage(App.mUser.photoUrl),
                        //       fit: BoxFit.cover,
                        //     ),
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0)),
                        //     border: Border.all(
                        //       color: Colors.white,
                        //       width: 3.0,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  App.mUser.fullName,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  App.mUser.email,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                if (_edited)
                                  OutlineButton(
                                    child: new Text("Save Changes"),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      uploadImage(context);
                                      print("HELLO");
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(),
                Container(height: 15.0),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Account Information".toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    initialValue: App.mUser.fullName,
                    onSaved: (val) => App.mUser.fullName = val,
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Theme
                                .of(context)
                                .accentColor)),
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    initialValue: App.mUser.email,
                    onSaved: (val) => App.mUser.email = val,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Theme
                                .of(context)
                                .accentColor)),
                  ),
                ),
                // ListTile(
                //   title: Text(
                //     "Phone",
                //     style: TextStyle(
                //         fontSize: 17,
                //         fontWeight: FontWeight.w700,
                //         color: Theme.of(context).accentColor),
                //   ),
                //   subtitle: Text(
                //     "+1 555-555-1212",
                //     style: TextStyle(color: Theme.of(context).accentColor),
                //   ),
                // ),
                // ListTile(
                //   title: Text(
                //     "Address",
                //     style: TextStyle(
                //         fontSize: 17,
                //         fontWeight: FontWeight.w700,
                //         color: Theme.of(context).accentColor),
                //   ),
                //   subtitle: Text(
                //     "1278 Lovely Lane Boston, MA 64110",
                //     style: TextStyle(color: Theme.of(context).accentColor),
                //   ),
                // ),
                ListTile(
                  title: TextFormField(
                    initialValue: App.mUser.gender,
                    onSaved: (val) => App.mUser.gender = val,
                    decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Theme
                                .of(context)
                                .accentColor)),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Venues",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme
                              .of(context)
                              .accentColor,
                        ),
                      ),
                      DropdownButton(
                        hint: Text('Select '),
                        dropdownColor: Colors.grey,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        value: valueChoose,
                        onChanged: (newValue) {
                          setState(() {
                            valueChoose = newValue;
                          });
                        },
                        items: venues.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Preferred Comps",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme
                              .of(context)
                              .accentColor,
                        ),
                      ),
                      DropdownButton(
                        hint: Text('Select '),
                        dropdownColor: Colors.grey,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        value: camps,
                        onChanged: (newValue) {
                          setState(() {
                            camps = newValue;
                          });
                        },
                        items: venues.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                MultiSelectDialogField(
                  items: _items,
                  title: Text("Animals"),
                  selectedColor: Theme.of(context).accentColor,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.pets,
                    color: Theme.of(context).accentColor,
                  ),
                  buttonText: Text(
                    "Favorite Animals",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                    _selectedAnimals = results;
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: Text("Favorite Animals"),
                        title: Text("Animals"),
                        items: _items,
                        onConfirm: (values) {
                          _selectedAnimals2 = values;
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              _selectedAnimals2.remove(value);
                            });
                          },
                        ),
                      ),
                      _selectedAnimals2 == null || _selectedAnimals2.isEmpty
                          ? Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "None selected",
                            style: TextStyle(color: Colors.black54),
                          ))
                          : Container(),
                    ],
                  ),
                ),
                // ListTile(
                //
                //   title: TextFormField(
                //     initialValue: App.mUser.venues,
                //     onSaved: (val) => App.mUser.venues = val,
                //     decoration: InputDecoration(
                //         labelText: 'Venues',
                //         labelStyle: TextStyle(
                //             fontSize: 22,
                //             fontWeight: FontWeight.w700,
                //             color: Theme
                //                 .of(context)
                //                 .accentColor)),
                //   ),
                // ),
                // ListTile(
                //   title: TextFormField(
                //     initialValue: App.mUser.preferredComps,
                //     onSaved: (val) => App.mUser.preferredComps = val,
                //     decoration: InputDecoration(
                //         labelText: 'Preferred Comps',
                //         labelStyle: TextStyle(
                //             fontSize: 22,
                //             fontWeight: FontWeight.w700,
                //             color: Theme
                //                 .of(context)
                //                 .accentColor)),
                //   ),
                // ),

                // ListTile(
                //   title: Text(
                //     "Date of Birth",
                //     style: TextStyle(
                //         fontSize: 17,
                //         fontWeight: FontWeight.w700,
                //         color: Theme.of(context).accentColor),
                //   ),
                //   subtitle: Text(
                //     "April 9, 1980",
                //     style: TextStyle(color: Theme.of(context).accentColor),
                //   ),
                // ),
                // MediaQuery.of(context).platformBrightness == Brightness.dark
                //     ? SizedBox()
                //     : ListTile(
                //         title: Text(
                //           "Dark Theme",
                //           style: TextStyle(
                //               fontSize: 17,
                //               fontWeight: FontWeight.w700,
                //               color: Theme.of(context).accentColor),
                //         ),
                //         trailing: Switch(
                //           value: Provider.of<AppProvider>(context).theme ==
                //                   Constants.lightTheme
                //               ? false
                //               : true,
                //           onChanged: (v) async {
                //             if (v) {
                //               Provider.of<AppProvider>(context, listen: false)
                //                   .setTheme(Constants.darkTheme, "dark");
                //             } else {
                //               Provider.of<AppProvider>(context, listen: false)
                //                   .setTheme(Constants.lightTheme, "light");
                //             }
                //           },
                //           activeColor: Theme.of(context).accentColor,
                //         ),
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  void uploadImage(context) async {
    try {
      FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'ggs://task1-11546.appspot.com');
      final ref = FirebaseStorage.instance.ref().child(p.basename(_image.path));
      UploadTask uploadTask = ref.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Success',
          style: TextStyle(color: Colors.white),
        ),
      ));
      String url = await taskSnapshot.ref.getDownloadURL();
      print('url $url');
      setState(() {
        _url = url;
      });
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(e.message, style: TextStyle(color: Colors.white)),
      ));
    }
  }

  void add() {
    final String url =
        "https://task1-11546-default-rtdb.firebaseio.com/product.json";
    http.post(url,
        body: json.encode({
          "Venues": [
            "Empire-Boston",
            "Mystique-BostonHarbor",
          ],
          "Preferred Comps": [
            "Remy Martin",
            "Dom Perignon",
            "Havana Club Mojito",
          ],
        }));
    //
    //   saveChanges() {}
    // }
  }
}
