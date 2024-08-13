import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = FormGroup({
      'email': FormControl<String>(validators: [
        Validators.email,
        Validators.required,
      ]),
      'password': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(8),
      ]),
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              38.verticalSpace,
              Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                  color: Colors.black,
                ),
              ),
              31.verticalSpace,
              ReactiveTextField(
                formControlName: 'email',
                decoration: InputDecoration(
                  hintText: 'Your Email',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xffEEEEEE),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                ),
              ),
              29.verticalSpace,
              ReactiveTextField(
                formControlName: 'password',
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xffEEEEEE),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                ),
              ),
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return ElevatedButton(
                    onPressed: form.valid ? _onSubmit(form) : null,
                    child: const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onSubmit(FormGroup form) {
    print(form.value);
  }
}
