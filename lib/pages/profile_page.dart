import 'package:flutter/material.dart';
import 'package:flutterfire_trial0/providers/profile/profile_state.dart';
import 'package:flutterfire_trial0/utils/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

import '../providers/profile/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileProvider profileProv;

  @override
  void initState() {
    super.initState();
    profileProv = context.read<ProfileProvider>();
    profileProv.addListener(errorDialogListener);
    _getProfile();
  }

  void _getProfile() {
    final String uid = context.read<fbAuth.User?>()!.uid;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<ProfileProvider>().getProfile(uid: 'uid'));
  }

  void errorDialogListener() {
    if (profileProv.state.profileStatus == ProfileStatus.error) {
      errorDialog(context, profileProv.state.error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    profileProv.removeListener(errorDialogListener);
  }

  Widget _buildProfile() {
    final profileState = context.watch<ProfileProvider>().state;
    if (profileState.profileStatus == ProfileStatus.initial) {
      return Container();
    } else if (profileState.profileStatus == ProfileStatus.loading) {
      return CircularProgressIndicator();
    } else if (profileState.profileStatus == ProfileStatus.error) {
      return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/error.png',
            width: 100,
          ),
          const SizedBox(width: 20.0),
          Text(
            'Ooops!\nTry Again',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.red,
            ),
          )
        ]),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/loading.gif',
              image: profileState.user.profileImage,
              width: double.infinity,
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '- id: ${profileState.user.id}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '- name: ${profileState.user.name}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '- email: ${profileState.user.email}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '- point: ${profileState.user.point}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '- rank: ${profileState.user.rank}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: _buildProfile(),
    );
  }
}
