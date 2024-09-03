import 'dart:core';

class WordwrapOptions {
  int width;
  bool breakWords;
  bool noTrim;
  String eol;

  WordwrapOptions(
      {this.width = 30,
      this.breakWords = false,
      this.noTrim = false,
      this.eol = '\n'});
}

class Wordwrap {
  List<String> _lines;
  WordwrapOptions options;

  Wordwrap(String text, {WordwrapOptions? options})
      : _lines = text.split(RegExp(r'\r\n|\n')),
        options = options ?? WordwrapOptions();

  List<String> lines() {
    return _lines
        .map(trimLine)
        .map((line) => RegExp(r'[^\s-]+?-\b|\S+|\s+|\r\n?|\n')
            .allMatches(line)
            .map((match) => match.group(0)!)
            .toList())
        .map((lineWords) => options.breakWords
            ? lineWords.expand(breakWord).toList()
            : lineWords)
        .map((lineWords) {
          List<String> lines = [''];
          for (var word in lineWords) {
            String currentLine = lines.last;
            if (replaceAnsi(word).length + replaceAnsi(currentLine).length >
                options.width) {
              lines.add(word);
            } else {
              lines[lines.length - 1] += word;
            }
          }
          return lines;
        })
        .expand((line) => line)
        .map(trimLine)
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceAll('~~empty~~', ''))
        .toList();
  }

  String wrap() {
    return lines().join(options.eol);
  }

  @override
  String toString() {
    return wrap();
  }

  static String wrapText(String text, {WordwrapOptions? options}) {
    final block = Wordwrap(text, options: options);
    return block.wrap();
  }

  static List<String> linesText(String text, {WordwrapOptions? options}) {
    final block = Wordwrap(text, options: options);
    return block.lines();
  }

  static bool isWrappable(String text) {
    final matches = RegExp(r'[^\s-]+?-\b|\S+|\s+|\r\n?|\n').allMatches(text);
    return matches.isNotEmpty && matches.length > 1;
  }

  static List<String> getChunks(String text) {
    return RegExp(r'[^\s-]+?-\b|\S+|\s+|\r\n?|\n')
        .allMatches(text)
        .map((match) => match.group(0)!)
        .toList();
  }

  String trimLine(String line) {
    return options.noTrim ? line : line.trim();
  }

  String replaceAnsi(String string) {
    return string.replaceAll(RegExp(r'\u001b.*?m'), '');
  }

  List<String> breakWord(String word) {
    if (replaceAnsi(word).length > options.width) {
      List<String> letters = word.split('');
      List<String> pieces = [];
      while (letters.isNotEmpty) {
        pieces.add(letters.take(options.width).join());
        letters.removeRange(0, options.width);
      }
      return pieces;
    } else {
      return [word];
    }
  }
}
