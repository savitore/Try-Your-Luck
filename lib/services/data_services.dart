import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class DataService{
  Future DataInsertUsers(String name, String phone_number, String balance, String image, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "document":{
        "name":name,
        "phone_number":phone_number,
        "balance": balance,
        "image" : image
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
  Future DataInsertContestUsers(String name, String phone_number, String contest_name, bool alreadyJoined, String image, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"contests",
      "collection":contest_name,
      "document":{
        "name":name,
        "phone_number":phone_number,
        "already_joined": alreadyJoined,
        "image": image
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
  Future DataInsertUserMultipleContests(String contestName, String phone_number,String winning_amount, String lucky_no_user,String fee, String lucky_draw_no,String no_of_people, String date, String time, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"users",
      "collection":phone_number,
      "document":{
        "contest":contestName,
        "winning_amount": winning_amount,
        "lucky_no_user": lucky_no_user,
        "redeemed": "no",
        "lucky_draw_no":lucky_draw_no,
        "fee":fee,
        "no_of_people":no_of_people,
        "result":"",
        "date":date,
        "time":time
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
  }
  Future AmountAdded(String phone_number, String balance, String paymentid, String date, String time, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"transcations",
      "collection":phone_number,
      "document":{
        "amount_added": balance,
        'payment_id': paymentid,
        'date': date,
        'time': time
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
  }
  Future DataInsertWinners(String name, String contest_name, String prize, String lucky_no, String date, String fee, String no_of_people, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"winners",
      "document":{
        "name":name,
        "contest_name":contest_name,
        "prize": prize,
        "lucky_no": lucky_no,
        "fee": fee,
        "date": date,
        "no_of_people": no_of_people
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