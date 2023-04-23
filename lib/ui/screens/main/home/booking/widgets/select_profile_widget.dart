import 'package:alsan_app/bloc/language_bloc.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../widgets/avatar.dart';

class SelectProfileWidget extends StatefulWidget {
  final Profile profile;
  final int isSelected;
  final VoidCallback onTap;

  const SelectProfileWidget({
    super.key,
    required this.profile,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _SelectProfileWidgetState createState() => _SelectProfileWidgetState();
}

class _SelectProfileWidgetState extends State<SelectProfileWidget> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var langBloc = Provider.of<LangBloc>(context, listen: false);
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: MyColors.paleLightBlue,
          border: Border.all(
            color: widget.isSelected == widget.profile.id
                ? MyColors.primaryColor
                : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Avatar(
                  url: widget.profile.image,
                  name: widget.profile.fullName,
                  borderRadius: BorderRadius.circular(10),
                  size: 72,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.profile.fullName ?? 'NA'),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${widget.profile.age?.toString()} ${langBloc.getString(Strings.years)}',
                          style: textTheme.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${widget.profile.city ?? 'NA'}, ',
                          style: textTheme.subtitle2,
                        ),
                        Text(
                          widget.profile.country ?? 'NA',
                          style: textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        Helper.textCapitalization(
                          text: widget.profile.gender,
                        ),
                        style: textTheme.subtitle2,
                      ),
                    ),
                    Radio(
                      value: widget.profile.id,
                      groupValue: widget.isSelected,
                      onChanged: (value) {
                        widget.onTap.call();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
