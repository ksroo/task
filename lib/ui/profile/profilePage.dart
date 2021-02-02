import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../add_product.dart';
import '../../app/app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Preferredcomps {
  final int id;
  final String name;

  Preferredcomps({
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

  List<Product> productsList = [];
  List venues = [
    "Empire-Boston",
    "Mystique-BostonHarbor",
  ];


  static List<Preferredcomps> _preferredcomps = [
    Preferredcomps(id: 1, name: "Champagne"),
    Preferredcomps(id: 2, name: "Martini"),
    Preferredcomps(id: 3, name: "Red Wine"),
    Preferredcomps(id: 4, name: "White Wine"),
    Preferredcomps(id: 5, name: "Draft Beer"),
    Preferredcomps(id: 6, name: "Imported Beer"),
    Preferredcomps(id: 7, name: "Shrimp Cocktail"),
    Preferredcomps(id: 8, name: "Steak Dinner"),
    Preferredcomps(id: 9, name: "Chocolate Cake"),
    Preferredcomps(id: 10, name: "Cheescake"),
    Preferredcomps(id: 11, name: "Strip Steak Dinner"),


  ];

  final _items = _preferredcomps
      .map((preferred) =>
      MultiSelectItem<Preferredcomps>(preferred, preferred.name))
      .toList();
  List<Preferredcomps> _selectedAnimals = [];
  List<Preferredcomps> _selectedAnimals2 = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

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
                  padding: EdgeInsets.only(left: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MultiSelectDialogField(
                        items: _items,
                        title: Text("preferred-comps"),
                        selectedColor: Colors.grey,

                        buttonIcon: Icon(
                          Icons.arrow_drop_down,
                          size: 36,
                          color: Colors.grey,
                        ),

                        buttonText: Text(
                          "Preferred Comps",
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .accentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (results) {
                          _selectedAnimals = results;
                        },
                      ),


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

  // walid code api firebase

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

  Future<void> fetchData() async {
    const url =
        "https://task1-11546-default-rtdb.firebaseio.com/preferred-comps.json";
    try {
      final http.Response res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        productsList.add(Product(
          id: prodId,
          name: prodData,
        ));
      });
    } catch (error) {
      throw error;
    }
  }

}