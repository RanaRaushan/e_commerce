import 'dart:collection';
import 'dart:math';

import 'package:e_commerce/pages/product_listing_page.dart';
import 'package:e_commerce/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../models/user_model.dart';

class LoginPage extends StatefulWidget {

  static const routeName = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 4250);

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _loginObscureText = true;
  late HashMap<String, TextEditingController> _loginFieldControllers;
  late List<User> user;

  @override
  void initState() {
    super.initState();
    user = User.dummyUsers;
    _loginFieldControllers =
    HashMap<String, TextEditingController>.fromIterable(
        addLoginFormFields(),
        key: (formFields) => formFields.keyName,
        value: (formFields) =>
            TextEditingController(
              text: formFields.defaultValue,
            ));
    if (_loginFieldControllers.length != addLoginFormFields().length) {
      throw ArgumentError(
          "Some of the login formFields have duplicated names, KeyName Should be unique.");
    }
  }

  List<AddUpdateFormField> addLoginFormFields() => const [
    AddUpdateFormField(
      keyName: "userEmailLogin",
      displayName: Constants.emailFieldDisplayName+ " or Phone No.",
      inputType: TextInputType.text,
    ),
    AddUpdateFormField(
      keyName: "userPasswordLogin",
      displayName: Constants.passwordFieldDisplayName,
      inputType: TextInputType.visiblePassword,
    ),
  ];

  _submitButton() {
    if (_isLoading){
      return const SizedBox(
          child:CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color?>(Colors.blue),
            
            strokeWidth: 4.0,
          ));
    }
    return ElevatedButton(
      onPressed: () async {
        
          if (_loginFormKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            return Future.delayed(loginTime).then((_) {
              String email= _loginFieldControllers["userEmailLogin"]!.text;
              String password= _loginFieldControllers["userPasswordLogin"]!.text;

              bool isAuthUser = user.indexWhere((element) => (
                  (element.email == email && element.password == password ) ||
                      (element.phoneNo == email && element.password == password )
              )
              )>=0;
              if(isAuthUser){
                setState(() {_isLoading = false; });
                Navigator.of(context).push(MaterialPageRoute(settings: RouteSettings(arguments: user.firstWhere((element) => element.email == email || element.phoneNo == email),name:ProductListingPage.routeName),builder: (context) => const ProductListingPage())
                );
                snackBarKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('Successfully LoggedIn'),
                ));
                return null;
              }
              setState(() {_isLoading = false; });
              snackBarKey.currentState?.showSnackBar(const SnackBar(
                content: Text('Wrong login or password'),
              ));
              return null;
            });
          }
        
      },
      child: const Text("Login"),
    );
  }

  _gradient() => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColorDark,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0, 1],
      ),
    ),
    child: const SizedBox.expand(),
  );

  List<Widget> _loginFormFields () => addLoginFormFields().map((AddUpdateFormField formField) {
    final DateFormat formatter = DateFormat(Constants.defaultDateFormat);
    return TextFormField(
      enabled: !_isLoading,
      autofocus: true,
      controller: _loginFieldControllers[formField.keyName],
      decoration: InputDecoration(
        errorMaxLines:2,
        labelText: formField.displayName,
        prefixIcon: formField.prefixIcon,
        suffixIcon: formField.inputType!=TextInputType.visiblePassword?null:GestureDetector(
          onTap: () => setState(() => _loginObscureText = !_loginObscureText),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            firstCurve: Curves.easeInOutSine,
            secondCurve: Curves.easeInOutSine,
            alignment: Alignment.center,
            layoutBuilder: (Widget topChild, _, Widget bottomChild, __) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[bottomChild, topChild],
              );
            },
            firstChild: const Icon(
              Icons.visibility,
              size: 25.0,
              semanticLabel: "show password",
            ),
            secondChild: const Icon(
              Icons.visibility_off,
              size: 25.0,
              semanticLabel: "hide password",
            ),
            crossFadeState: _loginObscureText
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your ${formField.displayName}";
        }
        return null;
      },
      keyboardType: formField.inputType,
      readOnly: formField.inputType==TextInputType.datetime?true:false,
      obscureText: formField.inputType!=TextInputType.visiblePassword?false:_loginObscureText,
      onTap: formField.inputType==TextInputType.datetime?
          () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1901, 1),
            lastDate: DateTime(2100));
        if (picked != null){
          final String formattedDate = formatter.format(picked);
          _loginFieldControllers[formField.keyName]?.text = formattedDate;
        }
      }: ()=>{},
    );
  }).toList();


  _loginForm() => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Form(
              key: _loginFormKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _loginFormFields()
              )
          ),
          const SizedBox(height: 35),
          TextButton(onPressed: _isLoading?null:()=>{}, child: const Text(Constants.forgetPassTextButtonName)),
          _submitButton(),
          TextButton(onPressed: _isLoading?null:()=>{
            Navigator.of(context).push(MaterialPageRoute(settings: const RouteSettings(name:SignupPage.routeName),builder: (context) => const SignupPage())
            ),
          }, child: const Text(Constants.signupTextButtonName)),
        ],
      )
  );

  _loginCard () {
    var cardWidth = min(MediaQuery.of(context).size.width * 0.75, 360.0);
    const cardPadding = 16.0;
    debugPrint("Card width = $cardWidth");
    return Align(alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                      child: Container(

                        padding: const EdgeInsets.only(
                          left: cardPadding,
                          top: cardPadding + 10.0,
                          right: cardPadding,
                          bottom: cardPadding,
                        ),

                        child: _loginForm(),
                      ),
                    ),
                  )]
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: <Widget>[
          _gradient(),
          _loginCard(),
        ])
    );
  }
}

class AddUpdateFormField {
  final String keyName;
  final String displayName;
  final String defaultValue;
  final FormFieldValidator<String>? fieldValidator;
  final Icon? prefixIcon;
  final TextInputType inputType;

  const AddUpdateFormField({
    required this.keyName,
    displayName,
    this.defaultValue = '',
    this.prefixIcon,
    this.fieldValidator,
    required this.inputType,
  }) : displayName = displayName ?? keyName;
}
