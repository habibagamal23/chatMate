import 'package:chatchat/core/utils/styles.dart';
import 'package:chatchat/features/login/logic/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatchat/features/login/ui/widgets/emailandpassweord.dart';
import 'package:chatchat/features/login/ui/widgets/donthaveacc.dart';
import '../../../core/network_services/firebase_sevice.dart';
import '../../../core/utils/routes.dart';
import '../../../core/widgets/backgroundwaves.dart';
import '../../../core/widgets/button_app.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(FirebaseService()),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFeliuer) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errom),
              backgroundColor: Colors.red,
            ));
          }
          if (state is LoginSuces) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("succes"),
              backgroundColor: Colors.green,
            ));
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
              child: SafeArea(
                  child: Stack(children: [
            const CustomBackground(),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackground(),
                    Text("Login"),
                    EmailAndPassword(),
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.forgetpass);
                        },
                        child: Text("forget pass ?")),
                    BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                      if (state is LoginLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return AppTextButton(
                          buttonText: "login",
                          textStyle: Theme.of(context).textTheme.labelSmall!,
                          onPressed: () {
                            final formKey = context.read<LoginCubit>().formKey;
                            if (formKey.currentState != null &&
                                formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login();
                            }
                          });
                    })
                  ],
                )),
          ]))),
        ),
      ),
    );
  }
}
