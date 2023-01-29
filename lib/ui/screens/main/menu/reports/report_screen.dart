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
        title: const Text('My Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(15),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Patient", style: textTheme.caption),
                      const SizedBox(height: 4),
                      Text(
                        "ALex Oliver",
                        style: textTheme.headline3
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(width: 112),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Clinican", style: textTheme.caption),
                      const SizedBox(height: 4),
                      Text(
                        "Dr. Taslim",
                        style: textTheme.headline3
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              const SizedBox(height: 16),
              // TimeSlot(),
              const SizedBox(height: 30),
              ProgressButton(
                onPressed: () {},
                child: const Text("Download Report"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
