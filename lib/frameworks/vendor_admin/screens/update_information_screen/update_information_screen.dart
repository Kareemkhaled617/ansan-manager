import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../widgets/common/edit_product_info_widget.dart';
import '../../models/authentication_model.dart';
import 'update_information_model.dart';

class UpdateInformationVendorAdmin extends StatefulWidget {
  const UpdateInformationVendorAdmin({super.key});

  @override
  State<UpdateInformationVendorAdmin> createState() =>
      _UpdateInformationVendorAdminState();
}

class _UpdateInformationVendorAdminState
    extends State<UpdateInformationVendorAdmin> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  // var _image;

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    final user =
        Provider.of<VendorAdminAuthenticationModel>(context, listen: false)
            .user;
    _firstNameController.text = user!.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email ?? '';
    _usernameController.text = user.username ?? '';
    _phoneController.text = user.billing?.phone ?? '';
    // _image = _user.picture;
  }

  void _update(UpdateInformationModel model) async {
    final result = await model.updateInfo(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      newPassword: _newPasswordController.text,
    );
    showMessage(result);
    if (result == 1) {
      final model =
          Provider.of<VendorAdminAuthenticationModel>(context, listen: false);
      model.updateInformation(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final user =
        Provider.of<VendorAdminAuthenticationModel>(context, listen: false)
            .user;
    return ChangeNotifierProvider<UpdateInformationModel>(
      create: (_) => UpdateInformationModel(user),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              iconTheme: theme.iconTheme,
              title: Text(
                S.of(context).updateUserInfor,
                style: theme.textTheme.titleLarge,
              ),
              centerTitle: true,
              backgroundColor: theme.colorScheme.surface,
            ),
            floatingActionButton: Consumer<UpdateInformationModel>(
              builder: (_, model, __) => ElevatedButton(
                onPressed: () => _update(model),
                child: Text(S.of(context).update),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(user?.picture ?? kDefaultImage),
                            radius: 80,
                          ),
                        ],
                      ),
                    ),
                    EditProductInfoWidget(
                      controller: _usernameController,
                      label: S.of(context).username,
                      enable: false,
                    ),
                    EditProductInfoWidget(
                      controller: _emailController,
                      label: S.of(context).email,
                      enable: false,
                    ),
                    EditProductInfoWidget(
                      controller: _firstNameController,
                      label: S.of(context).firstName,
                    ),
                    EditProductInfoWidget(
                        controller: _lastNameController,
                        label: S.of(context).lastName),
                    EditProductInfoWidget(
                      controller: _phoneController,
                      label: S.of(context).phone,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<UpdateInformationModel>(
              builder: (_, model, __) =>
                  model.state == UpdateInformationState.loading
                      ? Container(
                          width: size.width,
                          height: size.height,
                          color: Colors.black.withValueOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container()),
        ],
      ),
    );
  }
}

extension UpdateInformationExtension on State<UpdateInformationVendorAdmin> {
  void showMessage(int result) {
    var message = '';
    switch (result) {
      case -1:
        message = S.of(context).updateFailed;
        break;
      case -2:
        message = S.of(context).incorrectPassword;
        break;
      default:
        message = S.of(context).updateSuccess;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
    Navigator.pop(context);
  }
}
