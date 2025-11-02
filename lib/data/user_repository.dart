import '../domain/user.dart';

class UserRepository {
  static final List<User> users = [
    User(userName: 'Ale', userEmail: 'ale@gmail.com', role: 'admin', password: '123', document: 'AE2345', country: 'ESP'),
  ];

  static void addUser(User user) {
    users.add(user);
  }

  static User? findUser(String email, String password) {
    try {
      return users.firstWhere(
        (u) => u.userEmail == email && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static bool existsByEmail(String email) {
    return users.any((u) => u.userEmail == email);
  }
}
