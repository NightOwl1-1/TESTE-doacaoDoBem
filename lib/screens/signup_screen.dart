import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our auth methods
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    // if the string returned is success, the user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    // set the state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  Widget buildTextFieldInputWithGrayBackground(
    String hintText,
    TextInputType textInputType,
    TextEditingController textEditingController,
    bool isPassword,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey, // Background color gray
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: isPassword,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white), // Cor do texto de dica (branco)
          enabledBorder: InputBorder.none, // Para remover a borda padrão
          focusedBorder: InputBorder.none, // Para remover a borda quando o campo está em foco
          contentPadding: EdgeInsets.symmetric(horizontal: 16), // Ajuste o preenchimento conforme necessário
        ),
        style: TextStyle(color: Colors.white), // Cor do texto de entrada (branco)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.transparent, // Altere a cor para transparente
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'Inscrever-se',
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          ),               
                      ),
                    ),
                 ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),                 
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              buildTextFieldInputWithGrayBackground(
                'Insira seu nome de usuário',
                TextInputType.text,
                _usernameController,
                false,
              ),
              const SizedBox(
                height: 24,
              ),
              buildTextFieldInputWithGrayBackground(
                'Insira seu email',
                TextInputType.emailAddress,
                _emailController,
                false,
              ),
              const SizedBox(
                height: 24,
              ),
              buildTextFieldInputWithGrayBackground(
                'Insira sua senha',
                TextInputType.text,
                _passwordController,
                true,
              ),
              const SizedBox(
                height: 24,
              ),
              buildTextFieldInputWithGrayBackground(
                'Insira sua descrição',
                TextInputType.text,
                _bioController,
                false,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    color: greenColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Inscrever-se',
                          style: TextStyle(color: Colors.white),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                ),
                child: const Text(
                  'Conecte-se',
                  style: TextStyle(
                    color: greenColor,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
