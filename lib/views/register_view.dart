import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late TextEditingController _emailController,
      //_reemailController,
      _passwordController,
      _imageURL,
      _firstnameController,
      _lastnameController,
      _phonenumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    //_reemailController = TextEditingController();
    _passwordController = TextEditingController();
    _imageURL = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phonenumberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    //_reemailController.dispose();
    _passwordController.dispose();
    _imageURL.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phonenumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 12.0),
            TextFormField(
              autocorrect: false,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "EMAIL ADDRESS",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: 'Enter Email'),
            ),
            //const SizedBox(height: 12.0),
            // TextFormField(
            //   autocorrect: false,
            //   controller: _reemailController,
            //   validator: (value) {
            //     if (value == null || value != _reemailController.text) {
            //       return 'Email addresses do not match';
            //     }
            //     return null;
            //   },
            //   decoration: const InputDecoration(
            //       labelText: "RE ENTER EMAIL ADDRESS",
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(10.0))),
            //       hintText: 'Re-Enter Email'),
            // ),
            const SizedBox(height: 12.0),
            TextFormField(
              autocorrect: false,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "ENTER PASSWORD",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: 'Enter Password'),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              autocorrect: false,
              controller: _imageURL,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Image URL cannot be empty';
              //   }
              //   return null;
              // },
              decoration: const InputDecoration(
                  labelText: "Enter Image URL",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: 'Enter Image URL'),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              autocorrect: false,
              controller: _firstnameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'First name cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Enter firstname",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: 'Enter first name'),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              autocorrect: false,
              controller: _lastnameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Last name cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Enter last name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: 'Enter last name'),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              autocorrect: false,
              controller: _phonenumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Enter phone number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: 'Enter phone number'),
            ),
            const SizedBox(height: 30.0),
            OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')));

                  setState(() {
                    register();
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      _db
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
            "userid": FirebaseAuth.instance.currentUser!.uid,
            "imageURL": _imageURL.text,
            "first name": _firstnameController.text,
            "last_name": _lastnameController.text,
            "phone": _phonenumberController.text,
          })
          .then((value) => null)
          .onError((error, stackTrace) => null);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something Else")));
    } catch (e) {
      print(e);
    }

    setState(() {});
  }
}
