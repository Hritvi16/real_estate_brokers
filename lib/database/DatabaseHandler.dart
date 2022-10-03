import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler
{

  static final int DATABASE_VERSION = 1;
  static final String DATABASE_NAME = "reb.db";
  static final String TABLE_FU = "followup";

  static DatabaseHandler instance = new DatabaseHandler();
  static late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await initializeDB();
    return _database;
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, DATABASE_NAME),
      onCreate: (database, version) async {
        await createDB(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async
      {
        // await database.execute("DROP TABLE IF EXISTS " + TABLE_FU);
        // await createDB(database);
      },
      version: 1,
    );
  }

  Future<void> createDB(Database database) async {
    print("creating");
    await database.execute("CREATE TABLE IF NOT EXISTS "+ TABLE_FU +" (id INTEGER AUTO_INCREMENT PRIMARY KEY, db_id INTEGER , name STRING NOT NULL, details TEXT NOT NULL, datetime STRING NOT NULL, status INTEGER NOT NULL)");
    print("created");
  }

  Future<void> dropDB() async {
    Database db = await instance.database;
    print("droping");
    await db.execute("DROP TABLE IF EXISTS " + TABLE_FU);
    print("dropped");
    await createDB(db);
  }


  Future<void> addFollowUp(Database database, Map<String, dynamic> values)  async {
    Database db = database;
    await db.insert(TABLE_FU, values, nullColumnHack: null);
    print("inserted");
  }

  Future<bool> updateFollowUp(Database database, Map<String, dynamic> values) async {
    Database db = database;
    db.update(TABLE_FU, values);
    print("updated");
    return true;
  }

  Future<bool> deleteFollowUp(Database database, String value) async {
    Database db = database;
    db.delete(TABLE_FU, where: value);
    print("deleted");
    return true;
  }

  // Future<double> getRap(String values) async {
  //   Database db = await instance.database;
  //   List<Map<String, dynamic>> rap_data = await db.rawQuery("select * from tbl_rap where sz_DiamondType= '"+ diamond_type +"' AND sz_Clarity = '"+clarity+"' AND sz_Color = '"+color+"' AND nm_MinWeight <= "+weight.toString()+" AND nm_MaxWeight >= "+weight.toString()+"", null);
  //   print(rap_data);
  //   print(rap_data[0]);
  //   print(rap_data[0]["nm_RapPrice"]);
  //   return double.parse(rap_data[0]["nm_RapPrice"].toString());
  //
  // }

}