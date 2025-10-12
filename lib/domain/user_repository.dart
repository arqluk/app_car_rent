import 'user.dart';

class UserRepository {
  static final List<User> users = [
    User(userEmail: 'ale@gmail.com', password: '123', passport: 'A12345', country: 'ARG'),
    User(userEmail: 'ben@gmail.com', password: '234', passport: 'B12345', country: 'BRA'),
    User(userEmail: 'cam@gmail.com', password: '345', passport: 'C12345', country: 'CHN'),
    User(userEmail: 'dan@gmail.com', password: '456', passport: 'D12345', country: 'DEN'),
    User(userEmail: 'eva@gmail.com', password: '567', passport: 'AE2345', country: 'ESP'),
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
