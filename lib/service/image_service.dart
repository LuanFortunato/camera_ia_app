import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class ImageService {
  String get apiKey => dotenv.env["API_KEY"] ?? "No API Key";

  Future<String?> detectProduct(String imageBase64) async {
    var response = await _postDetailsDetectionRequest(imageBase64);
    if (response.statusCode == 200) {
      return _processImageData(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<String> countProducts(String imageBase64, String prodName) async {
    var response = await _postCountProdut(imageBase64, prodName);
    if (response.statusCode == 200) {
      return _processImageCount(response.body);
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

  Future<http.Response> _postCountProdut(
    String imageBase64,
    String prodName,
  ) async {
    return await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: json.encode({
        "model": "gpt-4o",
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text":
                    "How many $prodName there are in this image? Focus on the main thing. Respond with a number only in integer format, for whatever is in the picture."
              },
              {
                "type": "image_url",
                "image_url": {
                  "url": "data:image/jpeg;base64,$imageBase64",
                }
              }
            ]
          }
        ],
        "max_tokens": 1000
      }),
    );
  }

  String? _processImageData(responseBody) {
    List<dynamic> jsonData = jsonDecode(responseBody);

    return jsonData.firstOrNull["data"];
  }

  String _processImageCount(responseBode) {
    Map<String, dynamic> jsonData =
        jsonDecode(responseBode) as Map<String, dynamic>;

    return jsonData["choices"][0]["message"]["content"];
  }
}
