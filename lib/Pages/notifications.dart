import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../admin_provider.dart';
import '../helper/dimintions.dart';
import '../widget/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const NotificationsScreen({super.key, required this.setLocale});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double spacesHeight(double number) {
      return (number / heightRatio) * height;
    }

    final adminId = Provider.of<AdminProvider>(context).adminId;

    return Scaffold(
      backgroundColor: Color(0xFFEEF2E1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacesHeight(10)),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFC3DEA9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xff194E19),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
                Text(
                  localization.notifications,
                  style: GoogleFonts.k2d(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF194E19),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
                Expanded(
                  child: adminId == null
                      ? Center(
                          child: Text(
                            'Sign in to see your notifications.',
                            style: GoogleFonts.k2d(color: Color(0xff194E19)),
                          ),
                        )
                      : StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('admins')
                              .doc(adminId)
                              .collection('notifications')
                              .orderBy('timestamp', descending: true)
                              .limit(50)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final docs = snapshot.data?.docs ?? [];
                            if (docs.isEmpty) {
                              return Center(
                                child: Text(
                                  'No notifications yet.',
                                  style:
                                      GoogleFonts.k2d(color: Color(0xff194E19)),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final data =
                                    docs[index].data() as Map<String, dynamic>;
                                final timestamp =
                                    data['timestamp'] as Timestamp?;
                                return NotificationCard(
                                  title: data['title'] ?? '',
                                  alertType: data['alertType'] ?? '',
                                  message: data['message'] ?? '',
                                  imagePath: data['imagePath'] ??
                                      'assets/images/planet.png',
                                  timeAgo: timestamp == null
                                      ? ''
                                      : _timeAgo(timestamp.toDate()),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
