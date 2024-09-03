import 'package:epson_epos/layout/word_wrap.dart';

class SpaceBetweenParams {
  String left;
  String right;
  String textToWrap;
  double? textToWrapWidth;
  String gapSymbol;
  bool? noTrim;

  SpaceBetweenParams({
    required this.left,
    required this.right,
    this.textToWrap = 'left',
    this.textToWrapWidth,
    this.gapSymbol = ' ',
    this.noTrim,
  });
}

String fillGap(String symbol, int length) {
  return symbol * length;
}

Map<String, double> getTextsWidths(
  int fullLength,
  String textToWrap,
  double textToWrapWidth,
  String right,
  String left,
) {
  double leftTextWidth;
  double rightTextWidth;

  if (textToWrapWidth == 0) {
    int halfLength = (fullLength / 2).floor();
    if (textToWrap == 'left') {
      leftTextWidth = right.length < fullLength
          ? (fullLength - right.length).toDouble()
          : halfLength.toDouble();
    } else {
      leftTextWidth = left.length < fullLength
          ? left.length.toDouble()
          : halfLength.toDouble();
    }
  } else {
    if (textToWrap == 'left') {
      leftTextWidth = textToWrapWidth * fullLength;
    } else {
      leftTextWidth = (1 - textToWrapWidth) * fullLength;
    }
  }

  rightTextWidth = fullLength - leftTextWidth;

  return {
    'leftTextWidth': leftTextWidth,
    'rightTextWidth': rightTextWidth,
  };
}

String spaceBetween(int length, SpaceBetweenParams params) {
  var textsWidths = getTextsWidths(
    length,
    params.textToWrap,
    params.textToWrapWidth ?? 0,
    params.right,
    params.left,
  );

  double leftTextWidth = textsWidths['leftTextWidth']!;
  double rightTextWidth = textsWidths['rightTextWidth']!;

  List<String> leftWrappedTextArray = Wordwrap.wrapText(params.left,
      options: WordwrapOptions(
        width: leftTextWidth.toInt(),
        breakWords: true,
        noTrim: params.noTrim ?? false,
      )).split('\n');
  List<String> rightWrappedTextArray = Wordwrap.wrapText(params.right,
      options: WordwrapOptions(
        width: rightTextWidth.toInt(),
        breakWords: true,
        noTrim: params.noTrim ?? false,
      )).split('\n');

  return List.generate(
    leftWrappedTextArray.length > rightWrappedTextArray.length
        ? leftWrappedTextArray.length
        : rightWrappedTextArray.length,
    (index) {
      String leftText = index < leftWrappedTextArray.length
          ? leftWrappedTextArray[index]
          : '';
      String rightText = index < rightWrappedTextArray.length
          ? rightWrappedTextArray[index]
          : '';
      int spacesAmount = length - leftText.length - rightText.length;
      String gaps = index == 0
          ? fillGap(params.gapSymbol, spacesAmount)
          : fillGap(' ', spacesAmount);
      return '$leftText$gaps$rightText';
    },
  ).join('\n');
}
