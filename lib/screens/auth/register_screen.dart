import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:myapp/screens/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const SizedBox(height: 100),
                Text('Register',
                    style: Theme.of(context).textTheme.displaySmall),
                const Text('Please enter name, email, and password to login'),
                const SizedBox(height: 30),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(hintText: 'name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                    controller: email,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                const SizedBox(height: 15),
                TextFormField(
                  controller: password,
                  //buat nyamarin password
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                loading? const Center(child: CircularProgressIndicator()):
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      startRegister();
                    }
                  },
                  child: const Text('Register'),
                )
              ],
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
          child: const Text('Already Have an Account? Login'),
        ),
        const SizedBox(height: 15),
      ],
    ));
  }

  startRegister() async {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:632825246.
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      await result.user?.updateDisplayName(name.text);
      setState(() {
        loading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message?? '')));
    }
  }
}
