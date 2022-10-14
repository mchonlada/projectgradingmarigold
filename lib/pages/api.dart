class Api{
  final int sumpix;
  Api({
    required this.sumpix,
  });
  factory Api.fromJson(Map<String, dynamic> json){
    return Api(sumpix: json['sumpix']);
  }
}