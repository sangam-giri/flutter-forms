import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_example/src/core/enums/app_status.dart';
import 'package:forms_example/src/core/widgets/custom_bottom_navbar.dart';
import 'package:forms_example/src/core/widgets/custom_botton.dart';
import 'package:forms_example/src/core/widgets/custom_textfield.dart';
import 'package:forms_example/src/features/profile/domain/entity/profile.dart';
import 'package:forms_example/src/features/profile/presentation/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.isUpdate = false});
  final bool isUpdate;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    super.initState();
  }

  void _setup(ProfileState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Profile? initial = state.initialForm;

      if (initial != null) {
        _nameController.text = initial.name ?? '';
        _emailController.text = initial.email ?? '';
        _addressController.text = initial.address ?? '';
      }
    });
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _addressController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc()..add(ProfileFormInitialized(isUpdate: widget.isUpdate)),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(),
          body: BlocConsumer<ProfileBloc, ProfileState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              switch (state.status) {
                case AppStatus.initial:
                  _clearFields();

                case AppStatus.loaded:
                  Navigator.pop(context);
                  _setup(state);

                case AppStatus.loading:
                  showDialog(
                    context: context,
                    builder: (context) => Center(child: Text('Loading')),
                  );

                case AppStatus.failure:
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        state.failure?.message ?? 'Failed to complete the job',
                      ),
                    ),
                  );
                case AppStatus.successful:
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Successful'),
                    ),
                  );
                default:
              }
            },

            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text('Name'),
                          CustomTextField(
                            controller: _nameController,
                            onChanged: (value) {
                              context.read<ProfileBloc>().add(
                                ProfileFormUpdated(name: value),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          Text('Email'),

                          CustomTextField(
                            controller: _emailController,
                            onChanged: (value) {
                              context.read<ProfileBloc>().add(
                                ProfileFormUpdated(email: value),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          Text('Address'),
                          CustomTextField(
                            controller: _addressController,
                            onChanged: (value) {
                              context.read<ProfileBloc>().add(
                                ProfileFormUpdated(address: value),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) =>
                previous.isDirty != current.isDirty,
            builder: (context, state) {
              final isDirty = state.isDirty;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomBottomNavigationBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBotton(
                        text: 'Reset',
                        isEnabled: isDirty,
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                            ProfileFormResetted(),
                          );
                        },
                      ),
                      CustomBotton(
                        text: 'Save',
                        isEnabled: isDirty,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileBloc>().add(ProfileSubmitted());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
