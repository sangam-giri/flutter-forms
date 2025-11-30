import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_example/src/core/enums/app_status.dart';
import 'package:forms_example/src/features/profile/domain/entity/profile.dart';
import 'package:forms_example/src/features/profile/presentation/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.isUpdate = false});
  final bool isUpdate;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      } else {
        _nameController.clear();
        _emailController.clear();
        _addressController.clear();
      }
    });
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
          body: MultiBlocListener(
            listeners: [
              BlocListener<ProfileBloc, ProfileState>(
                listenWhen: (previous, current) =>
                    current.formStatus == AppStatus.successful &&
                    current.initialForm != null,
                listener: (context, state) {
                  _setup(state);
                  context.read<ProfileBloc>().add(
                    ProfileSateUpdated(status: AppStatus.completed),
                  );
                },
              ),
              BlocListener<ProfileBloc, ProfileState>(
                listenWhen: (previous, current) =>
                    previous.submitStatus != current.submitStatus,
                listener: (context, state) {
                  switch (state.submitStatus) {
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
                          content: Text('Failed'),
                        ),
                      );
                    case AppStatus.successful:
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Failed'),
                        ),
                      );
                    default:
                  }
                },
              ),
            ],
            child: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.formStatus != current.formStatus,
              builder: (context, state) {
                if (state.formStatus != AppStatus.initial &&
                    state.formStatus != AppStatus.completed) {
                  return Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (_nameController.text.isEmpty) {
                                  return 'Cannot be empty';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                context.read<ProfileBloc>().add(
                                  ProfileFormUpdated(name: value),
                                );
                              },
                            ),
                            TextFormField(
                              controller: _emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (_emailController.text.isEmpty) {
                                  return 'Cannot be empty';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                context.read<ProfileBloc>().add(
                                  ProfileFormUpdated(email: value),
                                );
                              },
                            ),
                            TextFormField(
                              controller: _addressController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (_addressController.text.isEmpty) {
                                  return 'Cannot be empty';
                                }
                                return null;
                              },
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
          ),
          bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final isDirty = state.isDirty;

              return AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                  left: 8,
                  right: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(ProfileFormResetted());
                        _setup(state);
                      },
                      child: Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: isDirty
                          ? () {
                              context.read<ProfileBloc>().add(
                                ProfileSubmitted(),
                              );
                            }
                          : null,
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
