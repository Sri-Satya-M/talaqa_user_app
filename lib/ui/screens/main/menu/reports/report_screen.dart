import 'package:alsan_app/ui/screens/main/menu/reports/widgets/time_slot.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reports'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 270,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "ALSOO34",
                style: textTheme.headline4,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Patient", style: textTheme.caption),
                      SizedBox(height: 4),
                      Text(
                        "ALex Oliver",
                        style: textTheme.headline3
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(width: 112),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Clinican", style: textTheme.caption),
                      SizedBox(height: 4),
                      Text(
                        "Dr. Taslim",
                        style: textTheme.headline3
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
              SizedBox(height: 16),
              TimeSlot(),
              SizedBox(height: 30),
              ProgressButton(
                onPressed: () {},
                child: Text("Download Report"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
