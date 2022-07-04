import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  bool success;
  String message;
  String error;
  dynamic data;

  ResponseApi({
    this.success,
    this.message,
    this.error,
  });

  ResponseApi.fromJson(Map<String, dynamic> json) {
    success= json["success"];
    message= json["message"];
    data= json["data"];

    try{
      data= json['data'];
    }catch(e){
      print('Exception: '+e);
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data,
    "error":error
  };
}