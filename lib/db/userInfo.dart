import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:try_your_luck/others/constant.dart';
import 'package:try_your_luck/models/MongoDBModel.dart';

class UserInformation{
  static var db, collection;
  static connect() async{
    db= await Db.create(MONGO_URL);
    await db.open();
    // inspect(db);
    collection= db.collection(COLLECTION_NAME);
  }
  static Future<String> insert(MongoDbModel data) async{
    try
    {
      var result = await collection.insertOne(data.toJson());
      if(result.isSuccess){
        return "Data Inserted";
      }
      else{
        return "Something wrong with inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }
}