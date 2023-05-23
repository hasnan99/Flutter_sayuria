class user{
  final int id;
  final String nama_depan;
  final String nama_belakang;
  final String email;
  final String username;
  final String alamat;
  final String profile;


  const user({
    required this.id,
    required this.nama_depan,
    required this.nama_belakang,
    required this.email,
    required this.username,
    required this.alamat,
    required this.profile,
  });

  factory user.fromJson(Map<String,dynamic>json){
    return user(
      id: json['id'],
      nama_depan: json['nama_depan'],
      nama_belakang: json['nama_belakang'],
      email: json['email'],
      username: json['username'],
      alamat: json['alamat'],
      profile: json['profile'],
    );
  }
}