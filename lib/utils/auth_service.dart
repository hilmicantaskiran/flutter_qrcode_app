import 'package:http/http.dart' as http;

class AuthService {
  var url = Uri.parse('http://odemetakip.herokuapp.com/api/v1/auth/login');
  var client = http.Client();

  Future<String?> login(String email, String password) async {
    const _error = 'Invalid email or password';
    var body = {
      'email': email,
      'password': password,
    };
    var response = await client.post(url, body: body);
    return response.statusCode == 200 ? response.body : _error;
  }
}
