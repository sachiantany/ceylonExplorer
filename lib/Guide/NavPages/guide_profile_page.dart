import 'package:flutter/cupertino.dart';

class GuideProfile extends StatefulWidget {
  const GuideProfile({super.key});

  @override
  State<GuideProfile> createState() => _GuideProfileState();
}

class _GuideProfileState extends State<GuideProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("Guide Profile Page"),
      ),
    );
  }
}
