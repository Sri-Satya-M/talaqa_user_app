import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/language_bloc.dart';
import '../../../../../resources/strings.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FAQScreen()),
    );
  }

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(langBloc.getString(Strings.faq)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: FutureBuilder(builder: (context, snapshot) {
            List<Widget> patientsList = [FAQCard(), FAQCard()];
            return ListView(
              children: patientsList,
            );
          }),
        ),
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  const FAQCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      title: Text(
        'ExpansionTile 1',
        style: textTheme.headline2,
      ),
      children: <Widget>[
        ListTile(
            title: Text(
          'Pellentesque mollis, mauris orci dignissim nisl, id gravida nunc enim quis nibh. Maecenas convallis eros a ante dignissim, vitae elementum metus facilisis. Cras in maximus sem. Praesent libero augue, ornare eget quam sed, volutpat suscipit arcu. Duis ut urna commodo, commodo tellus ac, consequat justo. Maecenas nec est ac purus mattis tristique vitae vel leo. Duis ac eros vel nunc aliquet ultricies vel at metus. Praesent a sagittis leo. Maecenas volutpat, justo in egestas mattis, lectus dui venenatis ex, consequat imperdiet velit odio eget dolor. Mauris commodo cursus metus ut lobortis. Nulla eget facilisis nibh, et varius justo. Ut laoreet purus at neque lacinia tempus. Cras venenatis sed felis sed pulvinar. Mauris orci sapien, convallis scelerisque nunc id, molestie mattis lectus. Vivamus facilisis eu odio at vestibulum. Mauris id odio ut libero ornare finibus.',
          style: textTheme.caption,
        )),
      ],
    );
  }
}
