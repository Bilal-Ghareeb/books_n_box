import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../business_logic/cubit/auth_cubit/auth_cubit.dart';
import '../../../../utils/screen_block_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../shared_widgets/button.dart';
import '../../../shared_widgets/custom_text_field.dart';
import '../../edit_profile/widgets/profile_image.dart';
import '../../login_screen/widgets/center_logo.dart';
import '../../login_screen/widgets/center_title.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  static const Color iconColor = Color.fromARGB(170, 0, 0, 0);
  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String? _password;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.emailRegisterSuccess) {
          context.go("/home");
        } else if (state.status == AuthenticationStatus.emailRegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message ?? localization!.registerError)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localization!.registerFailed)));
        }
      },
      child: ResponsiveBuilder(builder: (context, screenConfig) {
        final ScreenBlockSize sizeConfig =
            ScreenBlockSize(screenSizeConfig: screenConfig);
        return Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: sizeConfig.verticalBlockSize * 3.5),
            child: Column(
              children: [
                CenterLogo(width: sizeConfig.horizontalBlockSize * 94),
                SizedBox(
                  height: sizeConfig.verticalBlockSize,
                ),
                CenterTitle(localization!.register),
                ProfileImage(userPath: null),
                SizedBox(
                  height: 35,
                ),
                CustomTextField(
                    controller: _usernameController,
                    hintText: localization.enter + localization.username,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return localization.emptyUsername;
                      }
                      return null;
                    },
                    icon: Icon(
                      Icons.person,
                      color: iconColor,
                    ),
                    isPassword: false),
                SizedBox(
                  height: sizeConfig.verticalBlockSize,
                ),
                CustomTextField(
                    controller: _emailController,
                    hintText: localization.enter + localization.emailAddress,
                    icon: Icon(
                      Icons.email_sharp,
                      color: iconColor,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return localization.emptyEmail;
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return localization.invalidEmail;
                      }
                      return null;
                    },
                    isPassword: false),
                SizedBox(
                  height: sizeConfig.verticalBlockSize,
                ),
                CustomTextField(
                  icon: Icon(
                    Icons.visibility,
                    color: iconColor,
                  ),
                  validator: (value) {
                    _password = value;
                    if (value!.isEmpty) {
                      return localization.emptyPassword;
                    } else if (value.length < 8) {
                      return localization.shortPass;
                    }
                    return null;
                  },
                  isPassword: true,
                  hintText: localization.enter + localization.password,
                ),
                SizedBox(
                  height: sizeConfig.verticalBlockSize,
                ),
                CustomTextField(
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return localization.confirmPass;
                    } else if (value != _password) {
                      return localization.confirmError;
                    }
                    return null;
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: iconColor,
                  ),
                  isPassword: true,
                  hintText: localization.confirmPass,
                ),
                SizedBox(
                  height: sizeConfig.verticalBlockSize * 5,
                ),
                Button(
                  formKey: _formKey,
                  text: localization.register,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print(img?.path);
                      BlocProvider.of<AuthCubit>(context).registerEmailAccount(
                          username: _usernameController.text.trim(),
                          email: _emailController.text.trim(),
                          confirmedPassword: _confirmPasswordController.text,
                          imageUrl: img?.path);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _confirmPasswordFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
