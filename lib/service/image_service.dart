import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "../model/details.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class ImageService {
  String get apiKey => dotenv.env["API_KEY"] ?? "No API Key";

  ImageService();

  Future<List<Details>> detectImage(String imageBase64) async {
    var response = await _postDetailsDetectionRequest(imageBase64);
    if (response.statusCode == 200) {
      return _processImageData(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<http.Response> _postDetailsDetectionRequest(String imageBase64) async {
    return await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text":
                    "What is this in the image? Focus on the main thing. Respond in json only. Assuming JSON content starts with '{' so we can parse it. Should have 'thing' key that shows and array dictionary of containing (if ther is no data for the different apart from descriptipon, as you should atleast put something in there, keys just empty string but do return data) 'name', 'species', 'description', 'location', 'endangered', for whatever is in the picture."
              },
              {
                "type": "image_url",
                "image_url": "data:image/jpeg;base64,$imageBase64"
              }
            ]
          }
        ],
        "max_tokens": 1000
      }),
    );
  }

  List<Details> _processImageData(String responseBody) {
    var jsonData = json.decode(responseBody);
    var contentString = jsonData["choices"]?.first["message"]["content"] ?? "";

    // Find the start and end of the JSON content within the "content" string
    int jsonStartIndex = contentString.indexOf("{");
    int jsonEndIndex = contentString.lastIndexOf("}");

    if (jsonStartIndex != -1 && jsonEndIndex != -1) {
      var jsonString =
          contentString.substring(jsonStartIndex, jsonEndIndex + 1);
      var detailsDataJson = json.decode(jsonString);
      if (detailsDataJson.containsKey("thing")) {
        var detailsData = detailsDataJson["thing"] as List;
        return detailsData
            .map<Details>((json) => Details.fromJson(json))
            .toList();
      }
    }
    debugPrint(contentString.to);
    // create a single Details object with the response in its description.
    return [
      Details(
        name: "Unknown",
        quantity: "Unknown",
      )
    ];
    // else {
    //     // Fallback: if the JSON does not contain expected structure,

    //   throw Exception("No valid JSON content found");
    // }
  }
}
