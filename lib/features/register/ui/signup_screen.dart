import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatchat/core/widgets/backgroundwaves.dart';
import 'package:chatchat/core/widgets/button_app.dart';
import 'package:chatchat/features/register/logic/register_cubit.dart';
import 'package:chatchat/core/network_services/firebase_sevice.dart';
import '../../../core/utils/routes.dart';
import 'widgets/alreadyhaveacc.dart';
import 'widgets/signupform.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(FirebaseService()),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Succes Registration"),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushReplacementNamed(context, Routes.loginScreen);
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Stack(
                children: [
                  const CustomBackground(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 300),
                        Text(
                          'Create Your Account',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                        ),
                        const SizedBox(height: 20),
                        const SignupForm(),
                        const SizedBox(height: 20),
                        BlocBuilder<RegisterCubit, RegisterState>(
                          builder: (context, state) {
                            if (state is RegisterLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return AppTextButton(
                              buttonText: "Sign Up",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                              onPressed: () {
                                final formKey =
                                    context.read<RegisterCubit>().formKey;
                                if (formKey.currentState != null &&
                                    formKey.currentState!.validate()) {
                                  context.read<RegisterCubit>().register();
                                }
                              },
                            );
                          },
                        ),
                        const AlreadyHaveAccountText(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
