import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serface/settings.dart';

class NextcloudLogin extends StatefulWidget {
  const NextcloudLogin({ super.key });

  @override
  State<NextcloudLogin> createState() => _NextcloudLoginState();
}

class _NextcloudLoginState extends State<NextcloudLogin> {
  String? _url;
  String? _username;
  String? _password;

  NextcloudClient _createClient(BuildContext context) {
    final prefs = Provider.of<SharedPreferences>(context, listen: false)!;
    final url = _url ?? SerfaceSettings.nextcloudUrl.valueFor(prefs);
    final username = _username ?? SerfaceSettings.nextcloudUser.valueFor(prefs);
    final password = _password ?? SerfaceSettings.nextcloudPassword.valueFor(prefs);

    return NextcloudClient(
      url,
      loginName: username,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<SharedPreferences>(context)!;
    return AlertDialog(
      title: const Text('Set the Nextcloud login'),
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Ionicons.link),
              hintText: 'Nextcloud URL',
            ),
            initialValue: SerfaceSettings.nextcloudUrl.valueFor(prefs),
            onChanged: (value) => setState(() {
              _url = value;
            }),
            keyboardType: TextInputType.url,
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.abc),
              hintText: 'Nextcloud User Name',
            ),
            initialValue: SerfaceSettings.nextcloudUser.valueFor(prefs),
            onChanged: (value) => setState(() {
              _username = value;
            }),
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.password),
              hintText: 'Nextcloud Password',
            ),
            obscureText: true,
            initialValue: SerfaceSettings.nextcloudPassword.valueFor(prefs),
            onChanged: (value) => setState(() {
              _password = value;
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_url != null) {
              prefs.setString(SerfaceSettings.nextcloudUrl.name, _url!);
            }

            if (_username != null) {
              prefs.setString(SerfaceSettings.nextcloudUser.name, _username!);
            }

            if (_password != null) {
              prefs.setString(SerfaceSettings.nextcloudPassword.name, _password!);
            }

            Navigator.of(context).pop(_createClient(context));
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
