import "package:camera_ia_app/model/details.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class ImageService {
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
      Uri.parse("http://10.10.30.254:5000/process-image"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "image_base64": imageBase64.toString(),
      }),
    );
  }

  List<Details> _processImageData(responseBody) {
    List<dynamic> jsonData = jsonDecode(responseBody);
    print(responseBody);

    // Processar os dados para contabilizar as ocorrências
    Map<String, int> counts = {};
    for (var item in jsonData) {
      String data = item['data'];
      if (counts.containsKey(data)) {
        counts[data] = counts[data] ?? 0 + 1;
      } else {
        counts[data] = 1;
      }
    }

    // Converter o mapa em uma lista de objetos Detail
    List<Details> details = counts.entries
        .map((entry) =>
            Details(name: entry.key, quantity: entry.value.toString()))
        .toList();

    if (details.isEmpty) {
      details.add(Details(name: "No items found", quantity: "0"));
    }
    // Mostrar a lista de detalhes

    return details;

    // else {
    //     // Fallback: if the JSON does not contain expected structure,

    //   throw Exception("No valid JSON content found");
    // }
  }
}
