import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class BrowseScreen extends StatefulWidget {
  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCard(
              child: TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.tune),
                  ),
                  hintText: 'Search by clinician name',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Top Rated Clinicians",
              style: textTheme.subtitle2,
            ),
            SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
