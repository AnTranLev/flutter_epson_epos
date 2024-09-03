class AddLeftTextLine {
  static String formatLabel(String label, int totalLength) {
    // Add colon and space after the label
    label = "$label: ";

    // If the label is shorter than the total length, pad it with spaces
    if (label.length < totalLength) {
      label = label.padRight(totalLength);
    } else if (label.length > totalLength) {
      // Truncate the label if it exceeds the total length
      label = label.substring(0, totalLength);
    }

    return label;
  }

  static String formatTextLine(
      {required String label, required String value, int totalLength = 42}) {
    // Combine the label and value
    String combined = '$label$value';

    // If the combined length is less than totalLength, pad the end with spaces
    if (combined.length < totalLength) {
      combined = combined.padRight(totalLength);
    } else if (combined.length > totalLength) {
      // If the combined length is more than totalLength, truncate it
      combined = combined.substring(0, totalLength);
    }

    return combined;
  }
}

// String buildFormattedText(
//     String customerName, String invoiceNo, String invoiceDate) {
//   const int lineLength = 42; // Fixed line length

//   const int labelLength = 18;

//   // Format each label to have the same length
//   String customerLabel = formatLabel('Customer', labelLength);
//   String invoiceNoLabel = formatLabel('Invoice No', labelLength);
//   String invoiceDateLabel = formatLabel('Invoice Date', labelLength);

//   // Create formatted lines
//   String customerLine = formatTextLine(
//       label: customerLabel, value: customerName, totalLength: lineLength);
//   String invoiceNoLine = formatTextLine(
//       label: invoiceNoLabel, value: invoiceNo, totalLength: lineLength);
//   String invoiceDateLine = formatTextLine(
//       label: invoiceDateLabel, value: invoiceDate, totalLength: lineLength);

//   // Combine all lines into a single string with new lines
//   return '$customerLine\n$invoiceNoLine\n$invoiceDateLine';
// }
