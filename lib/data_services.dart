import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataService{

  Future DataInsertUsers(String name, String phone_number, String balance, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "document":{
        "name":name,
        "phone_number":phone_number,
        "balance": balance
      }
    };
    HttpClient httpClient=new HttpClient();
    HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
    httpClientRequest.headers.set("Content-Type", "application/json");
    httpClientRequest.headers.set("api-key", "hFpu17U8fUsHjNaqLQmalJKIurolrUcYON0rkHLvTM34cT3tnpTjc5ryTPKX9W9y");
    httpClientRequest.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response=await httpClientRequest.close();
    httpClient.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    var output=jsonDecode(contents.toString());
    print(output['insertedId']);
  }

  Future DataInsertContestUsers(String name, String phone_number, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"contestUsers",
      "document":{
        "name":name,
        "phone_number":phone_number,
      }
    };
    HttpClient httpClient=new HttpClient();
    HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
    httpClientRequest.headers.set("Content-Type", "application/json");
    httpClientRequest.headers.set("api-key", "hFpu17U8fUsHjNaqLQmalJKIurolrUcYON0rkHLvTM34cT3tnpTjc5ryTPKX9W9y");
    httpClientRequest.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response=await httpClientRequest.close();
    httpClient.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    var output=jsonDecode(contents.toString());
    print(output['insertedId']);
  }

}