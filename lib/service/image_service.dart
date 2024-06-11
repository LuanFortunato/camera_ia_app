import "package:http/http.dart" as http;
import "dart:convert";

class ImageService {
  Future<String?> detectImage(String imageBase64) async {
    var response = await _postDetailsDetectionRequest(imageBase64);
    if (response.statusCode == 200) {
      return _processImageData(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<http.Response> _postDetailsDetectionRequest(String imageBase64) async {
    return await http.post(
      Uri.parse("https://api-ia-codes-emzwntskvq-rj.a.run.app/process-image"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "image_base64": imageBase64.toString(),
      }),
    );
  }

  String? _processImageData(responseBody) {
    List<dynamic> jsonData = jsonDecode(responseBody);

    return jsonData.firstOrNull;
  }
}
