import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';

import '../questionnaires.dart';

class NumericalItemWidget extends QuestionnaireItemFiller {
  const NumericalItemWidget(
      QuestionnaireLocation location, QuestionnaireItemDecorator decorator,
      {Key? key})
      : super(location, decorator, key: key);

  @override
  State<StatefulWidget> createState() => _NumericalItemState();
}

class _NumericalItemState
    extends QuestionnaireItemState<Decimal, NumericalItemWidget> {
  _NumericalItemState() : super(null);

  @override
  void initState() {
    super.initState();
    if (widget.location.responseItem != null) {
      value = widget.location.responseItem!.answer!.first.valueDecimal ??
          widget.location.responseItem!.answer!.first.valueQuantity?.value;
    }
    if (widget.location.isTotalScore) {
      widget.location.top.addListener(() => _questionnaireChanged());
    }
  }

  void _questionnaireChanged() {
    if (widget.location.responseItem != null) {
      value = widget.location.responseItem!.answer!.first.valueDecimal ??
          widget.location.responseItem!.answer!.first.valueQuantity?.value;
    }
  }

  @override
  Widget buildBodyReadOnly(BuildContext context) {
    if (widget.location.isTotalScore) {
      return Center(
          child: Column(children: [
        const SizedBox(height: 32),
        Text(
          'Total Score',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          value?.value?.round().toString() ?? '0',
          style: Theme.of(context).textTheme.headline1,
        ),
      ]));
    }

    return Text(value.toString());
  }

  @override
  Widget buildBodyEditable(BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: widget.location.questionnaireItem.text),
      keyboardType: TextInputType.number,
      onChanged: (content) {
        value = Decimal(content);
        createResponse();
      },
    );
  }

  @override
  QuestionnaireResponseAnswer? createAnswer() =>
      QuestionnaireResponseAnswer(valueDecimal: value);
}
