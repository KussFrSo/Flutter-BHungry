import 'package:bhungry/models/users.dart';
import 'package:bhungry/widgets/bio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white),
        height: 80,
        padding: EdgeInsets.all(16).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  color: Colors.amber,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () => callRest(user.telefonos),
                        child: buildIcon(Icons.call)),
                    const SizedBox(width: 12),
                    InkWell(
                        onTap: () => goToBio(user, context),
                        child: buildIcon(Icons.info))
                  ],
                ),
                const SizedBox(width: 4),
              ],
            )
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber,
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );

  void callRest(telephon) async {
    await launch("tel://" + telephon);
  }

  void goToBio(user, context) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) => BioRest(rest: user)));
  }
}
