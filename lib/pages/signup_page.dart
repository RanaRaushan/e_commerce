import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'package:e_commerce/constants/constants.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {

  static const routeName = "/signup";

  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with TickerProviderStateMixin {

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 4250);

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _signupObscureText = true;
  late HashMap<String, TextEditingController> _signupFieldControllers;

  @override
  void initState() {
    super.initState();
    _signupFieldControllers =
    HashMap<String, TextEditingController>.fromIterable(
        addSignupFormFields(),
        key: (formFields) => formFields.keyName,
        value: (formFields) =>
            TextEditingController(
              text: formFields.defaultValue,
            ));
    if (_signupFieldControllers.length != addSignupFormFields().length) {
      throw ArgumentError(
          "Some of the login formFields have duplicated names, KeyName Should be unique.");
    }
  }

  List<AddUpdateFormField> addSignupFormFields() => [
    AddUpdateFormField(
      keyName: "userEmailSignup",
      displayName: Constants.emailFieldDisplayName,
      fieldValidator: (value) => emailValidator(value),
      inputType: TextInputType.emailAddress,
    ),
    AddUpdateFormField(
      keyName: "userPasswordSignup",
      displayName: Constants.passwordFieldDisplayName,
      fieldValidator: (value) => passwordValidator(value),
      inputType: TextInputType.visiblePassword,
    ),
    AddUpdateFormField(
      keyName: "userRePasswordSignup",
      displayName: "Confirm "+ Constants.passwordFieldDisplayName,
      fieldValidator: (value) => passwordValidator(value),
      inputType: TextInputType.visiblePassword,
    ),
    AddUpdateFormField(
      keyName: "userFirstNameSignup",
      displayName: Constants.firstNameFieldDisplayName,
      fieldValidator: (value) => firstNameValidator(value),
      inputType: TextInputType.name,
    ),
    AddUpdateFormField(
      keyName: "userLastLameSignup",
      displayName: Constants.lastNameFieldDisplayName,
      fieldValidator: (value) => lastNameValidator(value),
      inputType: TextInputType.name,
    ),
    AddUpdateFormField(
      keyName: "userPhoneNoSignup",
      displayName: Constants.phoneNoFieldDisplayName,
      fieldValidator: (value) => phoneValidator(value),
      inputType: TextInputType.phone,
    ),
    AddUpdateFormField(
      keyName: "userDobSignup",
      displayName: Constants.dateOfBirthFieldDisplayName,
      fieldValidator: (value) => dateOfBirthValidator(value),
      inputType: TextInputType.datetime,
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
              setState(() {_isLoading = false; });
              return null;
            });
          }

      },
      child: const Text("Signup"),
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

  List<Widget> _loginFormFields () => addSignupFormFields().map((AddUpdateFormField formField) {
    final DateFormat formatter = DateFormat(Constants.defaultDateFormat);
    return TextFormField(
      enabled: !_isLoading,
      autofocus: true,
      controller: _signupFieldControllers[formField.keyName],
      decoration: InputDecoration(
        errorMaxLines:2,
        labelText: formField.displayName,
        prefixIcon: formField.prefixIcon,
        suffixIcon: formField.inputType!=TextInputType.visiblePassword?null:GestureDetector(
          onTap: () => setState(() => _signupObscureText = !_signupObscureText),
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
            crossFadeState: _signupObscureText
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        ),
      ),
      validator: formField.fieldValidator,
      keyboardType: formField.inputType,
      readOnly: formField.inputType==TextInputType.datetime?true:false,
      obscureText: formField.inputType!=TextInputType.visiblePassword?false:_signupObscureText,
      onTap: formField.inputType==TextInputType.datetime?
          () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1901, 1),
            lastDate: DateTime(2100));
        if (picked != null){
          final String formattedDate = formatter.format(picked);
          _signupFieldControllers[formField.keyName]?.text = formattedDate;
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
          Navigator.of(context).push(MaterialPageRoute(settings: const RouteSettings(name:LoginPage.routeName),builder: (context) => const LoginPage())
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



emailValidator(value){
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }else{
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    bool matchEmail = regExp.hasMatch(value);
    if (!matchEmail){
      return "Please enter valid email";
    }
    return null;
  }

}

passwordValidator(value){
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }else {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    bool macthPassword = regExp.hasMatch(value);
    if (!macthPassword) {
      return "Please choose strong password";
    }
  }
  return null;

}

phoneValidator(value){
  if (value !=null && value.isEmpty) {
    return "Please enter your Phone Number";
  }
  var phoneRegExp = RegExp(
      "^(\\+91|0)?[0-9]{10}\$");
  bool phoneMatch = phoneRegExp.hasMatch(value!);
  if (!phoneMatch) {
    return "This isn't a valid phone number";
  }
  return null;
}

firstNameValidator(value){
  if (value !=null && value.isEmpty) {
    return "Please enter your First Name";
  }
  return null;
}

lastNameValidator(value){
  if (value !=null && value.isEmpty) {
    return "Last Name cannot be blank";
  }
  return null;
}

dateOfBirthValidator(value){
  if (value !=null && value.isEmpty) {
    return "Please enter your Date of Birth";
  }
  return null;
}