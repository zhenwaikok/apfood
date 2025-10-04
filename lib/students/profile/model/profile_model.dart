class UserModel{
  String email;
  String image_url;
  final String role;
  final String userId;
  final String username;

  UserModel({
    required this.email,
    required this.image_url,
    required this.role,
    required this.userId,
    required this.username,
    
  });


  factory UserModel.fromMap(Map<String, dynamic> data)
  {
    return UserModel(
      email: data['email'], 
      image_url: data['image_url'], 
      role: data['role'], 
      userId: data['userId'], 
      username: data['username'],
    );
  }







}