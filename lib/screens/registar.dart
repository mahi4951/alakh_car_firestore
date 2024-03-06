import 'dart:io';
import 'package:alakh_car/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'model.dart';

class Registar extends StatefulWidget {
  const Registar({
    Key? key, // Add this line to declare key
  }) : super(key: key);

  @override
  _RegistarState createState() => _RegistarState();
}

class _RegistarState extends State<Registar> {
  _RegistarState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? _image;

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = file != null ? File(file.path) : null;
    });
  }

  String? _currentItemSelected = "User";
  String role = "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Now'),
      ),
      backgroundColor: Colors.blue[400],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.blue[400],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Your Name',
                            hintText: 'Your Name',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure2,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            labelText: 'Password',
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: _isObscure2,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Confirm Password',
                            hintText: 'Confirm Password',
                            enabled: true,
                          ),
                          validator: (value) {
                            if (confirmpassController.text !=
                                passwordController.text) {
                              return "Password did not match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                          value: _currentItemSelected,
                          items: [
                            DropdownUtils.buildDropdownItem('User'),
                            DropdownUtils.buildDropdownItem('Dealer'),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              _currentItemSelected = value;
                              role = _currentItemSelected!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Select Role',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: _pickImage,
                              icon: Icon(Icons.upload),
                              label: Text('Select Avatar'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            FloatingActionButton.extended(
                              onPressed: () {
                                setState(() {
                                  showProgress = true;
                                });
                                signUp(
                                    emailController.text,
                                    passwordController.text,
                                    role,
                                    _nameController.text);
                              },
                              icon: Icon(Icons.add_business),
                              label: Text('Registar'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Already have an account ?",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          height: 20,
                        ),
                        FloatingActionButton.extended(
                          onPressed: () {
                            const CircularProgressIndicator();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.lock_open_sharp),
                          label: Text('Login'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp(
      String email, String password, String role, String name) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (mounted) {
          setState(() {
            showProgress = false;
          });
        }

        if (_image != null) {
          // Upload the image first
          String? imageUrl =
              await uploadImageToFirebase(_image!, userCredential.user!.uid);

          // Now, store the details in Firestore
          await postDetailsToFirestore(email, role, imageUrl, name);
        } else {
          // No image, store details in Firestore directly
          await postDetailsToFirestore(email, role, null, name);
        }

        if (mounted) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            showProgress = false;
          });
        }
        print('Error during signup: $e');
      }
    }
  }

  Future<String?> uploadImageToFirebase(File image, String userId) async {
    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference refRoot = FirebaseStorage.instance.ref();
      Reference refDir = refRoot.child('Avatars/$userId/');
      Reference refImgToUpload = refDir.child(uniqueFileName);

      // FirebaseStorage storage = FirebaseStorage.instance;
      // Reference ref = storage.ref().child('Avatars/$userId/avatar.jpg');

      // Upload the file to Firebase Storage
      // await ref.putFile(image);

      await refImgToUpload.putFile(
          image, SettableMetadata(contentType: 'image/jpeg'));
      // Retrieve the download URL for the uploaded file
      String downloadURL = await refImgToUpload.getDownloadURL();

      if (kDebugMode) {
        print('File uploaded. Download URL: $downloadURL');
      }

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> postDetailsToFirestore(
      String email, String role, String? imageUrl, String name) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = _auth.currentUser;
      CollectionReference ref = FirebaseFirestore.instance.collection('Users');
      Map<String, dynamic> data = {
        'email': email,
        'role': role,
        'displayName': name,
      };

      if (imageUrl != null) {
        // If imageUrl is not null, add it to the data
        data['avatarUrl'] = imageUrl;
      }

      await ref.doc(user!.uid).set(data);

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print('Error posting details to Firestore: $e');
    }
  }
}

class DropdownUtils {
  static DropdownMenuItem<String> buildDropdownItem(String text) {
    return DropdownMenuItem<String>(
      value: text,
      child: Text(text),
    );
  }
}
