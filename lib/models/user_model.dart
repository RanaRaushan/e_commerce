
class User{
  final int? id;
  final String? email;
  final String? password;
  final String? name;
  final String? phoneNo;
  const User(
      {
        this.email,
        this.name,
        this.phoneNo,
        this.password,
        this.id,
      });


  static List<User> get dummyUsers => [
    const User(email: "abc1@gmail", password:"1234", name: "abc1", phoneNo: "1234567890", id: 1),
    const User(email: "abc2@gmail", password:"1234", name: "abc2", phoneNo: "0987654321", id: 2),
    const User(email: "abc3@gmail", password:"1234", name: "abc3", phoneNo: "1234598765", id: 3),
    const User(email: "abc4@gmail", password:"1234", name: "abc4", phoneNo: "2134568595", id: 4),
    const User(email: "abc5@gmail", password:"1234", name: "abc5", phoneNo: "3256484634", id: 5),
    const User(email: "abc6@gmail", password:"1234", name: "abc6", phoneNo: "2465423663", id: 6),
    const User(email: "abc7@gmail", password:"1234", name: "abc7", phoneNo: "9999999999", id: 7),
  ];
}
