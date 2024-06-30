import 'dart:math';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;

void main() async {
  sqfliteFfiInit();
  final MyDatabase mydb = MyDatabase();
  final Files myfilea =
      Files(myFileName: 'Accounts', username: 'none', mynew: false);
  String file = '';
  List<String> filerows = [];
  List<String> filecontents = [];

  //products tables
  mydb.myRunQuery(myquery: '''CREATE TABLE Products (
  Sl_no INTEGER PRIMARY KEY,
  Item_Name TEXT,
  Quantity INTEGER,
  Cost_Per_Unit TEXT,
  Date_Of_Last_Purchase DATETIME,
  Category TEXT,
  Alert_Quantity INTEGER);''', myGet: false, myWrite: false);
  mydb.myRunQuery(myquery: '''CREATE TABLE ProductsFlip (
  Sl_no INTEGER PRIMARY KEY,
  Item_Name TEXT,
  Quantity INTEGER,
  Cost_Per_Unit INTEGER,
  Date_Of_Last_Purchase DATETIME,
  Category TEXT,
  Alert_Quantity INTEGER);''', myGet: false, myWrite: false);

  //staff tables
  mydb.myRunQuery(myquery: '''CREATE TABLE Staff (
  Sl_no INTEGER PRIMARY KEY, 
  Name TEXT, 
  Gender TEXT, 
  Date_Of_Birth DATETIME, 
  Category TEXT, 
  Area TEXT,
  Description TEXT,
  Randomize TEXT);''', myGet: false, myWrite: false);
  mydb.myRunQuery(myquery: '''CREATE TABLE StaffFlip (
  Sl_no INTEGER PRIMARY KEY, 
  Name TEXT, 
  Gender TEXT, 
  Date_Of_Birth DATETIME, 
  Category TEXT, 
  Area TEXT,
  Description TEXT,
  Randomize TEXT);''', myGet: false, myWrite: false);

  //accounts table
  mydb.myRunQuery(myquery: '''CREATE TABLE Accounts (
  Sl_no INTEGER PRIMARY KEY,
  Username TEXT,
  Password TEXT,
  Firstname TEXT,
  Lastname TEXT,
  DoB DATETIME,
  Hint TEXT,
  Answer TEXT,
  Bio TEXT,
  Notes TEXT);''', myGet: false, myWrite: false);
  file = await myfilea.myreadfile();
  filerows = file.split('|');
  for (String i in filerows) {
    filecontents = i.split('/');
    if (filecontents.length > 1) {
      mydb.myRunQuery(
          myquery: '''INSERT INTO Accounts 
            (Sl_no,Username,Password,Firstname,Lastname,DoB,Hint,Answer,Bio,Notes) 
            VALUES (${filecontents[0]},'${filecontents[1]}','${filecontents[2]}',
            '${filecontents[3]}','${filecontents[4]}','${filecontents[5]}',
            '${filecontents[6]}','${filecontents[7]}','${filecontents[8]}','${filecontents[9]}');''',
          myGet: false,
          myWrite: false);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management System',
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => const FirstRouteLogin(),
        '/Welcome': (context) => const SecondRouteWelcome(),
        '/StockInv': (context) => const ThirdRouteStockInv(),
        '/Products': (context) => const ForthRouteProducts(),
        '/NewProduct': (context) => const FifthRouteNewProduct(),
        '/Stats': (context) => const SixthRouteStats(),
        '/RoleAssign': (context) => const SeventhRouteRoleAssign(),
        '/AssignRole': (context) => const EighthRouteAssignRole(),
        '/StaffData': (context) => const NinthRouteStaffData(),
        '/AddStaff': (context) => const TenthRouteAddStaff(),
        '/EditProfile': (context) => const EleventhRouteProfile(),
        '/Forgot': (context) => const TwelfthRouteForgotPassword(),
        '/SignUp': (context) => const ThirteenthRouteSignUp(),
        '/EditProduct': (context) => const FourteenthRouteEditProduct(),
        '/EditStaff': (context) => const FifteenthRouteEditStaff(),
        '/Profile': (context) => const SixteenthRouteViewProfile(),
        '/ChangePass': (context) => const SeventeenthRouteChangePassword(),
      },
    );
  }
}

//page 1: login
class FirstRouteLogin extends StatelessWidget {
  const FirstRouteLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Management System'),
        ),
        body: const MyLoginForm());
  }
}

//login form
class MyLoginForm extends StatefulWidget {
  const MyLoginForm({Key? key}) : super(key: key);

  @override
  MyLoginFormState createState() {
    return MyLoginFormState();
  }
}

class MyLoginFormState extends State<MyLoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? myControllerLIUsername;
  TextEditingController? myControllerLIPassword;
  List<String>? accounts;
  String? accountValidate;

  @override
  void dispose() {
    myControllerLIUsername!.dispose();
    myControllerLIPassword!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery: 'SELECT Username,Password,Sl_no FROM Accounts;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            myControllerLIUsername ??= TextEditingController();
            myControllerLIPassword ??= TextEditingController();
            accounts = List.generate(
                snapshot.data!.length,
                (index) =>
                    '{${snapshot.data![index]['Username']}:${snapshot.data![index]['Password']}}');
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Stock Inventory',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'and',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Role Assignment System',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: const Color(0xff0d47a1),
                      width: 5,
                    )),
                    padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                    child: SizedBox(
                      height: 425,
                      width: 550,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: myControllerLIUsername,
                            decoration:
                                const InputDecoration(hintText: 'username'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return accountValidate;
                            },
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: myControllerLIPassword,
                            obscureText: true,
                            decoration:
                                const InputDecoration(hintText: 'password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return accountValidate;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      !accounts!.contains(
                                          '{${myControllerLIUsername!.text}:${myControllerLIPassword!.text}}')) {
                                    accountValidate = 'Invalid Account';
                                    setState(() {});
                                  }
                                  if (_formKey.currentState!.validate() &&
                                      accounts!.contains(
                                          '{${myControllerLIUsername!.text}:${myControllerLIPassword!.text}}')) {
                                    Navigator.pushNamed(context, '/Welcome');
                                    globals.name = snapshot
                                        .data![accounts!.indexOf(
                                                '{${myControllerLIUsername!.text}:${myControllerLIPassword!.text}}')]
                                            ['Username']
                                        .toString();
                                    MyDatabase().myRunQuery(
                                        myquery: 'DELETE FROM Products;',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery: 'DELETE FROM Staff;',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myinsert();
                                    setState(() {
                                      myControllerLIUsername = null;
                                      myControllerLIPassword = null;
                                      accounts = null;
                                      accountValidate = null;
                                    });
                                  }
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/SignUp')
                                      .then((flag) {
                                    if (flag != null) {
                                      setState(() {
                                        myControllerLIUsername = null;
                                        myControllerLIPassword = null;
                                        accounts = null;
                                        accountValidate = null;
                                      });
                                    }
                                  });
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/Forgot')
                                      .then((flag) {
                                    if (flag != null) {
                                      setState(() {
                                        myControllerLIUsername = null;
                                        myControllerLIPassword = null;
                                        accounts = null;
                                        accountValidate = null;
                                      });
                                    }
                                  });
                                },
                                child: const Text(
                                  'forgot password?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//page 2: welcome
class SecondRouteWelcome extends StatelessWidget {
  const SecondRouteWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SecondRouteWelcomeful();
  }
}

//statful second welcome
class SecondRouteWelcomeful extends StatefulWidget {
  const SecondRouteWelcomeful({Key? key}) : super(key: key);

  @override
  State<SecondRouteWelcomeful> createState() => SecondRouteWelcomefulState();
}

class SecondRouteWelcomefulState extends State<SecondRouteWelcomeful> {
  MyUpdatesTable myUpdatesTable = const MyUpdatesTable();
  MygraphCatalogue mygraphCatalogue = const MygraphCatalogue();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onEndDrawerChanged: (isopen) {
        setState(() {});
      },
      endDrawer: const SideBarMenu(),
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Welcome ${globals.name}!',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 75,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/StockInv').then((flag) {
                    if (flag != null) {
                      setState(() {});
                    }
                  });
                },
                child: const Text(
                  'Stock Inventory',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/RoleAssign').then((flag) {
                    if (flag != null) {
                      setState(() {});
                    }
                  });
                },
                child: const Text(
                  'Role Assignment',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//page 3: stock inventory
class ThirdRouteStockInv extends StatelessWidget {
  const ThirdRouteStockInv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const SideBarMenu(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: const Text(
            "Stock Inventory",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const ThirdRouteStockInvful());
  }
}

//stateful third Stockinv
class ThirdRouteStockInvful extends StatefulWidget {
  const ThirdRouteStockInvful({Key? key}) : super(key: key);

  @override
  State<ThirdRouteStockInvful> createState() => ThirdRouteStockInvfulState();
}

class ThirdRouteStockInvfulState extends State<ThirdRouteStockInvful> {
  MyUpdatesTable myUpdatesTable = const MyUpdatesTable();
  MygraphCatalogue mygraphCatalogue = const MygraphCatalogue();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(375, 50))),
              onPressed: () {
                Navigator.pushNamed(context, '/Products').then((flag) {
                  if (flag != null) {
                    myUpdatesTable = const MyUpdatesTable();
                    mygraphCatalogue = const MygraphCatalogue();
                    setState(() {});
                  }
                });
              },
              child: const Text(
                'Inventory',
                style: TextStyle(fontSize: 35),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(375, 50))),
              onPressed: () {
                Navigator.pushNamed(context, '/Stats');
              },
              child: const Text(
                'Statistics and Reports',
                style: TextStyle(fontSize: 35),
              ),
            ),
            Row(
              children: [
                ChartContainer(
                  title: 'Bar Chart',
                  color: Colors.lightBlueAccent,
                  chart: mygraphCatalogue,
                  csize: 0.40,
                ),
              ],
            ),
          ],
        ),
        Flexible(
          child: myUpdatesTable,
        ),
      ],
    );
  }
}

//updates table
class MyUpdatesTable extends StatefulWidget {
  const MyUpdatesTable({Key? key}) : super(key: key);

  @override
  State<MyUpdatesTable> createState() => MyUpdatesTableState();
}

class MyUpdatesTableState extends State<MyUpdatesTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                '''SELECT Item_Name,Quantity,Alert_Quantity - Quantity AS Remain FROM Products WHERE Quantity <= Alert_Quantity;'''),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.5), width: 5),
                  borderRadius: BorderRadius.circular(12)),
              height: 400,
              width: 250,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.blue.withOpacity(0.3);
                  }),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Stock Updates'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return null;
                      }),
                      cells: <DataCell>[
                        DataCell(Text(
                          '${snapshot.data![index]['Item_Name'].toString()} has only ${snapshot.data![index]['Quantity'].toString()} stock. (${snapshot.data![index]['Remain'].toString()} below set alert)',
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//page 4: products
class ForthRouteProducts extends StatelessWidget {
  const ForthRouteProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SideBarMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            );
          },
        ),
        title: const Text(
          "Inventory",
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ),
      body: const ProductSearchForm(),
    );
  }
}

//inventory products form
class ProductSearchForm extends StatefulWidget {
  const ProductSearchForm({Key? key}) : super(key: key);

  @override
  ProductSearchFormState createState() {
    return ProductSearchFormState();
  }
}

class ProductSearchFormState extends State<ProductSearchForm> {
  final _formKey = GlobalKey<FormState>();
  final myControllerProductSearch = TextEditingController();
  List<String?>? action;
  List<Map<String, Object?>>? actioned;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20)),
          const Text(
            'Products',
            style: TextStyle(
              fontSize: 55,
              color: Colors.blue,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: myControllerProductSearch,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 700)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/NewProduct').then((flag) {
                      if (flag != null) {
                        setState(() {});
                      }
                    });
                  },
                  child: const Text(
                    '+ New Product ',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          Flexible(child: myTableBuild(context))
        ],
      ),
    );
  }

  Widget myTableBuild(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                '''SELECT * FROM Products WHERE (Sl_no||Item_Name||Quantity||Cost_Per_Unit||Date_Of_Last_Purchase||Category||Alert_Quantity) LIKE '%${myControllerProductSearch.text}%';'''),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            if (actioned.toString() != snapshot.data.toString()) {
              action = List.generate(snapshot.data!.length, (int ind) => null);
              actioned = snapshot.data;
            }
            return SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.blue.withOpacity(0.7);
                  }),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Sl no.'),
                    ),
                    DataColumn(
                      label: Text('Item Name'),
                    ),
                    DataColumn(
                      label: Text('Quantity'),
                    ),
                    DataColumn(
                      label: Text('Cost/Unit'),
                    ),
                    DataColumn(
                      label: Text('Date of Last Purchase'),
                    ),
                    DataColumn(
                      label: Text('Category'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (index.isEven) {
                          return Colors.blue.withOpacity(0.3);
                        }
                        return Colors.blue.withOpacity(0.1);
                      }),
                      cells: <DataCell>[
                        DataCell(
                            Text(snapshot.data![index]['Sl_no'].toString())),
                        DataCell(SizedBox(
                            width: 150,
                            child: Text(snapshot.data![index]['Item_Name']
                                .toString()))),
                        DataCell(
                            Text(snapshot.data![index]['Quantity'].toString())),
                        DataCell(Text(
                            snapshot.data![index]['Cost_Per_Unit'].toString())),
                        DataCell(Text(snapshot.data![index]
                                ['Date_Of_Last_Purchase']
                            .toString())),
                        DataCell(SizedBox(
                            width: 100,
                            child: Text(
                                snapshot.data![index]['Category'].toString()))),
                        DataCell(
                          DropdownButton<String>(
                            hint: const Text('Action'),
                            value: action![index],
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.blue),
                            underline: Container(
                              height: 2,
                              color: Colors.blue,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                action![index] = newValue!;
                                actioned = snapshot.data;
                                switch (action![index]) {
                                  case 'Delete Product':
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''DELETE FROM Products WHERE Sl_no = ${snapshot.data![index]['Sl_no']};''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''DELETE FROM ProductsFlip;''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''INSERT INTO ProductsFlip (Item_Name,Quantity,Cost_Per_Unit,Date_Of_Last_Purchase,Category,Alert_Quantity) 
                                            SELECT Item_Name,Quantity,Cost_Per_Unit,Date_Of_Last_Purchase,Category,Alert_Quantity FROM Products;''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery: '''DELETE FROM Products;''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''INSERT INTO Products (Item_Name,Quantity,Cost_Per_Unit,Date_Of_Last_Purchase,Category,Alert_Quantity) 
                                            SELECT Item_Name,Quantity,Cost_Per_Unit,Date_Of_Last_Purchase,Category,Alert_Quantity FROM ProductsFlip;''',
                                        myGet: false,
                                        myWrite: true);
                                    break;
                                  case 'Edit':
                                    globals.product = snapshot.data![index]
                                            ['Sl_no']
                                        .toString();
                                    Navigator.pushNamed(context, '/EditProduct')
                                        .then((flag) {
                                      if (flag != null) {
                                        setState(() {});
                                      }
                                    });
                                    break;
                                  case 'Add 1 Stock':
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''UPDATE Products SET Quantity = Quantity + 1 WHERE Sl_no = ${snapshot.data![index]['Sl_no']};''',
                                        myGet: false,
                                        myWrite: true);
                                    break;
                                  case 'Remove 1 Stock':
                                    if (int.parse(snapshot.data![index]
                                                ['Quantity']
                                            .toString()) >
                                        1) {
                                      MyDatabase().myRunQuery(
                                          myquery:
                                              '''UPDATE Products SET Quantity = Quantity - 1 WHERE Sl_no = ${snapshot.data![index]['Sl_no']};''',
                                          myGet: false,
                                          myWrite: true);
                                    }
                                    break;
                                }
                              });
                            },
                            items: <String>[
                              'Add 1 Stock',
                              'Remove 1 Stock',
                              'Delete Product',
                              'Edit'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//page 5: new product
class FifthRouteNewProduct extends StatelessWidget {
  const FifthRouteNewProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const SideBarMenu(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          title: const Text(
            "New Product",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const NewProductForm());
  }
}

//new product form
class NewProductForm extends StatefulWidget {
  const NewProductForm({Key? key}) : super(key: key);

  @override
  NewProductFormState createState() {
    return NewProductFormState();
  }
}

class NewProductFormState extends State<NewProductForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerNPItemName = TextEditingController();
  TextEditingController myControllerNPOpeningStock = TextEditingController();
  TextEditingController myControllerNPCost = TextEditingController();
  TextEditingController myControllerNPAlertQuantity = TextEditingController();
  TextEditingController myControllerNPAddCategory = TextEditingController();
  String? category;
  String categoryValidator = 'Category *';
  bool addCategory = false;
  String? catval;
  DateTime mySelectedDate = DateTime.now();
  String dateValidator = 'Date Of Purchase';
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerNPItemName.dispose();
    myControllerNPOpeningStock.dispose();
    myControllerNPCost.dispose();
    myControllerNPAlertQuantity.dispose();
    myControllerNPAddCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(right: 150, left: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerNPItemName,
                    decoration: const InputDecoration(hintText: 'Item Name *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Item Name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: DropdownButton<String>(
                    hint: Text(categoryValidator),
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                        switch (category) {
                          case 'Add Category':
                            addCategory = true;
                            break;
                          default:
                            addCategory = false;
                            myControllerNPAddCategory = TextEditingController();
                            catval = category;
                            break;
                        }
                      });
                    },
                    items: globals.pcategories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 70,
                  width: 300,
                ),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    enabled: addCategory,
                    controller: myControllerNPAddCategory,
                    decoration: const InputDecoration(hintText: 'Add Category'),
                    validator: (value) {
                      if (!addCategory) {
                        return null;
                      }
                      if ((value == null || value.isEmpty) && addCategory) {
                        return 'Please Enter Category';
                      }
                      catval = myControllerNPAddCategory.text;
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerNPOpeningStock,
                    decoration:
                        const InputDecoration(hintText: 'Opening Stock *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Opening Stock';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please Enter A Number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextButton(
                    onPressed: () => myselectDate(context),
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    child: Text(
                      dateValidator,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerNPCost,
                    decoration: const InputDecoration(hintText: 'Cost/unit *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Cost/unit';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please Enter A Number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerNPAlertQuantity,
                    decoration:
                        const InputDecoration(hintText: 'Alert Quantity *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Alert Quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please Enter A Number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  if (category == null) {
                    categoryValidator = 'Please Select Category';
                    setState(() {});
                  }
                  if (addCategory) {
                    catval = myControllerNPAddCategory.text;
                    setState(() {});
                  }
                  if (mySelectedDate.toString().substring(0, 10) !=
                      DateTime.now().toString().substring(0, 10)) {
                    dateValidator = mySelectedDate.toString().substring(0, 10);
                    setState(() {});
                  }
                  if (_formKey.currentState!.validate() && category != null) {
                    mydatabase.myRunQuery(
                        myquery: '''INSERT INTO Products 
                            (Item_Name,Quantity,Cost_Per_Unit,Date_Of_Last_Purchase,Category,Alert_Quantity) 
                            VALUES ('${myControllerNPItemName.text}',${myControllerNPOpeningStock.text},
                            '₹ ${myControllerNPCost.text}','${mySelectedDate.toString().substring(0, 10)}',
                            '$catval',${myControllerNPAlertQuantity.text});''',
                        myGet: false,
                        myWrite: true);
                    if (addCategory) {
                      globals.pcategories.add(myControllerNPAddCategory.text);
                    }
                    setState(() {
                      myControllerNPItemName = TextEditingController();
                      myControllerNPOpeningStock = TextEditingController();
                      myControllerNPCost = TextEditingController();
                      myControllerNPAlertQuantity = TextEditingController();
                      myControllerNPAddCategory = TextEditingController();
                      category = null;
                      categoryValidator = 'Category *';
                      mySelectedDate = DateTime.now();
                      dateValidator = 'Date of Purchase';
                      addCategory = false;
                      catval = null;
                    });
                  }
                },
                child: const Text(
                  'Add Product',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  myselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mySelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != mySelectedDate) {
      setState(() {
        mySelectedDate = picked;
        dateValidator = mySelectedDate.toString().substring(0, 10);
      });
    }
  }
}

//page 6: statistics and reports
class SixthRouteStats extends StatelessWidget {
  const SixthRouteStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        endDrawer: const SideBarMenu(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Product Catalogue",
                icon: Icon(Icons.book),
              ),
              Tab(
                text: "Low Stock",
                icon: Icon(Icons.trending_down),
              ),
              Tab(
                text: "Category Wise",
                icon: Icon(Icons.dashboard_outlined),
              ),
            ],
          ),
          title: const Text("Statistics and Reports"),
        ),
        body: TabBarView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const ChartContainer(
                title: 'Product Catalogue',
                color: Colors.lightBlueAccent,
                chart: MygraphCatalogue(),
                csize: 0.50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('Stock of Product',
                      style: TextStyle(fontSize: 25, color: Color(0xff1565c0)))
                ],
              )
            ]),
            const MyGraphTableCatalogue(),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const ChartContainer(
                title: 'Low Stock',
                color: Colors.lightBlueAccent,
                chart: MygraphLow(),
                csize: 0.50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('Stock',
                      style: TextStyle(fontSize: 25, color: Color(0xffb71c1c))),
                  Text('       vs       ',
                      style: TextStyle(fontSize: 15, color: Color(0xff37474f))),
                  Text('Alert Quantity',
                      style: TextStyle(fontSize: 25, color: Color(0xff1565c0))),
                ],
              )
            ]),
            const MyGraphTableLow(),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const ChartContainer(
                title: 'Category Wise',
                color: Colors.lightBlueAccent,
                chart: MygraphCategory(),
                csize: 0.50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('Stock of Category',
                      style: TextStyle(fontSize: 25, color: Color(0xff1565c0)))
                ],
              )
            ]),
            const MyGraphTableCategory(),
          ]),
        ]),
      ),
    );
  }
}

//grapff container
class ChartContainer extends StatelessWidget {
  final Color color;
  final String title;
  final Widget chart;
  final num csize;

  const ChartContainer({
    Key? key,
    required this.title,
    required this.color,
    required this.chart,
    required this.csize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * csize,
        height: MediaQuery.of(context).size.width * csize * 0.65,
        padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xff1565c0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: chart,
            ))
          ],
        ),
      ),
    );
  }
}

//grapff catalogue
class MygraphCatalogue extends StatefulWidget {
  const MygraphCatalogue({Key? key}) : super(key: key);

  @override
  State<MygraphCatalogue> createState() => MygraphCatalogueState();
}

class MygraphCatalogueState extends State<MygraphCatalogue> {
  bool isChecked = false;
  String? action;
  List? maxy;
  double? maxyval;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery: 'SELECT Sl_no,Item_Name,Quantity FROM Products LIMIT 15;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            maxy = List.generate(
                snapshot.data!.length,
                (index) =>
                    int.tryParse(snapshot.data![index]['Quantity'].toString()));
            if (maxy != null) {
              if (maxy!.isNotEmpty) {
                maxyval =
                    (maxy!.reduce((curr, next) => curr > next ? curr : next) +
                            5)
                        .toDouble();
              }
            }
            return BarChart(BarChartData(
                maxY: maxyval,
                titlesData: FlTitlesData(
                  topTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      if (value == 16) {
                        return '';
                      } else {
                        final String tno =
                            snapshot.data![value.toInt()]['Sl_no'].toString();
                        return tno;
                      }
                    },
                  ),
                ),
                barGroups: List<BarChartGroupData>.generate(
                      snapshot.data!.length,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                            y: double.tryParse(
                                    snapshot.data![i]['Quantity'].toString()) ??
                                0,
                            width: 20,
                            borderRadius: const BorderRadius.all(Radius.zero),
                            colors: [
                              const Color(0xff1565c0),
                              const Color(0xff0d47a1)
                            ]),
                      ]),
                    ) +
                    [
                      BarChartGroupData(x: 16, barRods: [
                        BarChartRodData(
                            y: 0,
                            width: 0,
                            borderRadius: const BorderRadius.all(Radius.zero),
                            colors: [
                              const Color(0xff1565c0),
                              const Color(0xff0d47a1)
                            ]),
                      ]),
                    ]));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//grapff table catalogue
class MyGraphTableCatalogue extends StatefulWidget {
  const MyGraphTableCatalogue({Key? key}) : super(key: key);

  @override
  State<MyGraphTableCatalogue> createState() => MyGraphTableCatalogueState();
}

class MyGraphTableCatalogueState extends State<MyGraphTableCatalogue> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery: 'SELECT Sl_no,Item_Name,Quantity FROM Products;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.5), width: 5),
                  borderRadius: BorderRadius.circular(12)),
              width: 350,
              height: 450,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 35,
                  headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.blue.withOpacity(0.3);
                  }),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Sl_no'),
                    ),
                    DataColumn(
                      label: Text('Product Name'),
                    ),
                    DataColumn(
                      label: Text('Stock'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return null;
                      }),
                      cells: <DataCell>[
                        DataCell(
                            Text(snapshot.data![index]['Sl_no'].toString())),
                        DataCell(SizedBox(
                            width: 150,
                            child: Text(snapshot.data![index]['Item_Name']
                                .toString()))),
                        DataCell(
                            Text(snapshot.data![index]['Quantity'].toString())),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//grapff low stock
class MygraphLow extends StatefulWidget {
  const MygraphLow({Key? key}) : super(key: key);

  @override
  State<MygraphLow> createState() => MygraphLowState();
}

class MygraphLowState extends State<MygraphLow> {
  bool isChecked = false;
  String? action;
  List? maxy;
  double? maxyval;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                'SELECT Sl_no,Item_Name,Quantity,Alert_Quantity FROM Products WHERE Quantity <= Alert_Quantity LIMIT 10;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            maxy = List.generate(
                snapshot.data!.length,
                (index) =>
                    int.tryParse(snapshot.data![index]['Quantity'].toString()));
            if (maxy != null) {
              if (maxy!.isNotEmpty) {
                maxyval =
                    (maxy!.reduce((curr, next) => curr > next ? curr : next) +
                            5)
                        .toDouble();
              }
            }
            return BarChart(BarChartData(
                maxY: maxyval,
                titlesData: FlTitlesData(
                  topTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      if (value == 16) {
                        return '';
                      } else {
                        final String tName =
                            snapshot.data![value.toInt()]['Sl_no'].toString();
                        return tName;
                      }
                    },
                  ),
                ),
                barGroups: List<BarChartGroupData>.generate(
                      snapshot.data!.length,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                            y: double.tryParse(
                                    snapshot.data![i]['Quantity'].toString()) ??
                                0,
                            width: 10,
                            borderRadius: const BorderRadius.all(Radius.zero),
                            colors: [
                              const Color(0xffb71c1c),
                              const Color(0xffb71c1c)
                            ]),
                        BarChartRodData(
                            y: double.tryParse(snapshot.data![i]
                                        ['Alert_Quantity']
                                    .toString()) ??
                                0,
                            width: 10,
                            borderRadius: const BorderRadius.all(Radius.zero),
                            colors: [
                              const Color(0xff1565c0),
                              const Color(0xff0d47a1)
                            ]),
                      ]),
                    ) +
                    [
                      BarChartGroupData(x: 16, barRods: [
                        BarChartRodData(
                            y: 0,
                            width: 0,
                            borderRadius: const BorderRadius.all(Radius.zero),
                            colors: [
                              const Color(0xff1565c0),
                              const Color(0xff0d47a1)
                            ]),
                      ]),
                    ]));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//grapff table low stock
class MyGraphTableLow extends StatefulWidget {
  const MyGraphTableLow({Key? key}) : super(key: key);

  @override
  State<MyGraphTableLow> createState() => MyGraphTableLowState();
}

class MyGraphTableLowState extends State<MyGraphTableLow> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                'SELECT Sl_no,Item_Name,Quantity,Alert_Quantity FROM Products WHERE Quantity <= Alert_Quantity;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.5), width: 5),
                  borderRadius: BorderRadius.circular(12)),
              width: 450,
              height: 450,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 35,
                  headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.blue.withOpacity(0.3);
                  }),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Sl_no'),
                    ),
                    DataColumn(
                      label: Text('Product Name'),
                    ),
                    DataColumn(
                      label: Text('Stock'),
                    ),
                    DataColumn(
                      label: Text('Alert Stock'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return null;
                      }),
                      cells: <DataCell>[
                        DataCell(
                            Text(snapshot.data![index]['Sl_no'].toString())),
                        DataCell(SizedBox(
                            width: 150,
                            child: Text(snapshot.data![index]['Item_Name']
                                .toString()))),
                        DataCell(
                            Text(snapshot.data![index]['Quantity'].toString())),
                        DataCell(Text(snapshot.data![index]['Alert_Quantity']
                            .toString())),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//grapff category
class MygraphCategory extends StatefulWidget {
  const MygraphCategory({Key? key}) : super(key: key);

  @override
  State<MygraphCategory> createState() => MygraphCategoryState();
}

class MygraphCategoryState extends State<MygraphCategory> {
  bool isChecked = false;
  String? action;
  List? maxy;
  double? maxyval;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                'SELECT SUM(Quantity) AS Total,Category FROM Products GROUP BY Category LIMIT 15;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            maxy = List.generate(
                snapshot.data!.length,
                (index) =>
                    int.tryParse(snapshot.data![index]['Total'].toString()));
            if (maxy != null) {
              if (maxy!.isNotEmpty) {
                maxyval =
                    (maxy!.reduce((curr, next) => curr > next ? curr : next) +
                            5)
                        .toDouble();
              }
            }
            return BarChart(BarChartData(
                maxY: maxyval,
                titlesData: FlTitlesData(
                  topTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      return (value.toInt() + 1).toString();
                    },
                  ),
                ),
                barGroups: List<BarChartGroupData>.generate(
                      snapshot.data!.length,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                            y: double.tryParse(
                                    snapshot.data![i]['Total'].toString()) ??
                                0,
                            width: 20,
                            borderRadius: const BorderRadius.all(Radius.zero),
                            colors: [
                              const Color(0xff1565c0),
                              const Color(0xff0d47a1)
                            ]),
                      ]),
                    ) +
                    [
                      BarChartGroupData(x: 16, barRods: [
                        BarChartRodData(
                            y: 0,
                            width: 0,
                            borderRadius: const BorderRadius.all(Radius.zero),
                            colors: [
                              const Color(0xff1565c0),
                              const Color(0xff0d47a1)
                            ]),
                      ]),
                    ]));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//grapff table category
class MyGraphTableCategory extends StatefulWidget {
  const MyGraphTableCategory({Key? key}) : super(key: key);

  @override
  State<MyGraphTableCategory> createState() => MyGraphTableCategoryState();
}

class MyGraphTableCategoryState extends State<MyGraphTableCategory> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                'SELECT SUM(Quantity) AS Total,Category FROM Products GROUP BY Category;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.5), width: 5),
                  borderRadius: BorderRadius.circular(12)),
              width: 370,
              height: 450,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 35,
                  headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.blue.withOpacity(0.3);
                  }),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Sl_no'),
                    ),
                    DataColumn(
                      label: Text('Category'),
                    ),
                    DataColumn(
                      label: Text('Stock'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return null;
                      }),
                      cells: <DataCell>[
                        DataCell(Text((index + 1).toString())),
                        DataCell(SizedBox(
                            width: 150,
                            child: Text(
                                snapshot.data![index]['Category'].toString()))),
                        DataCell(
                            Text(snapshot.data![index]['Total'].toString())),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//page 7: role assignment
class SeventhRouteRoleAssign extends StatelessWidget {
  const SeventhRouteRoleAssign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const SideBarMenu(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: const Text(
            "Role Assignment",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const RoleAssignmentForm());
  }
}

//role assignment form
class RoleAssignmentForm extends StatefulWidget {
  const RoleAssignmentForm({Key? key}) : super(key: key);

  @override
  RoleAssignmentFormState createState() {
    return RoleAssignmentFormState();
  }
}

class RoleAssignmentFormState extends State<RoleAssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerRANotes = TextEditingController();
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerRANotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/AssignRole');
                },
                child: const Text(
                  'Assign Role',
                  style: TextStyle(fontSize: 50),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/StaffData');
                },
                child: const Text(
                  'Staff Data',
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SingleChildScrollView(
                  child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 5),
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  width: 250,
                  height: 400,
                  child: FutureBuilder<List<Map<String, Object?>>>(
                      future: MyDatabase().myRunQuery(
                          myGet: true,
                          myWrite: false,
                          myquery:
                              '''SELECT Notes FROM Accounts WHERE Username LIKE  '${globals.name}';'''),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data![0]['Notes'].toString() != 'null') {
                            myControllerRANotes.text =
                                snapshot.data![0]['Notes'].toString();
                          }
                          return TextFormField(
                            controller: myControllerRANotes,
                            expands: true,
                            decoration: const InputDecoration(
                              labelText: ('NotePad'),
                              labelStyle:
                                  TextStyle(color: Colors.blue, fontSize: 35),
                              filled: true,
                              fillColor: Color(0xffbbdefb),
                            ),
                            style: const TextStyle(color: Color(0xff0d47a1)),
                            maxLines: null,
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                ),
              )),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    mydatabase.myRunQuery(
                        myquery:
                            '''UPDATE Accounts SET Notes = '${myControllerRANotes.text}' WHERE Username LIKE  '${globals.name}';''',
                        myGet: false,
                        myWrite: true);
                  }
                },
                child: const Text(
                  'Save Notes',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//page 8: assign role
class EighthRouteAssignRole extends StatelessWidget {
  const EighthRouteAssignRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const SideBarMenu(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: const Text("Assign Role"),
        ),
        body: const AssignRole());
  }
}

//assign role form
class AssignRole extends StatefulWidget {
  const AssignRole({Key? key}) : super(key: key);

  @override
  AssignRoleState createState() {
    return AssignRoleState();
  }
}

class AssignRoleState extends State<AssignRole> {
  final _formKeyadd = GlobalKey<FormState>();
  final _formKeyran = GlobalKey<FormState>();
  TextEditingController myControllerARArea = TextEditingController();
  TextEditingController myControllerARMaxArea = TextEditingController();
  final scroll1 = ScrollController();
  final scroll2 = ScrollController();
  List<String> sls = [];
  List<bool> selected = [];
  bool select = false;
  String? arMaxStaff;
  final MyDatabase mydatabase = MyDatabase();
  String ar = '';
  List<String> arl = [];
  var map = {};

  @override
  void dispose() {
    myControllerARArea.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Form(
          key: _formKeyran,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Randomize Area for HouseKeeping',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerARMaxArea,
                    decoration: const InputDecoration(
                        hintText: 'Max Staff in One Area'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter';
                      }
                      return null;
                    },
                  ),
                ),
                FutureBuilder<List<Map<String, Object?>>>(
                    future: MyDatabase().myRunQuery(
                        myGet: true,
                        myWrite: false,
                        myquery:
                            '''SELECT Sl_no,Name FROM Staff WHERE Randomize IN ('1','true') AND Category LIKE 'HouseKeeping';'''),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
                      if (snapshot.hasData) {
                        if (!select) {
                          selected = List<bool>.generate(
                              snapshot.data!.length, (int index) => false);
                        }
                        if (!select) {
                          sls = List<String>.generate(
                              snapshot.data!.length,
                              (int index) =>
                                  snapshot.data![index]['Sl_no'].toString());
                        }
                        return SizedBox(
                          height: 250,
                          width: 350,
                          child: SingleChildScrollView(
                            controller: scroll2,
                            child: DataTable(
                              checkboxHorizontalMargin: 15,
                              headingRowColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return Colors.blue.withOpacity(0.5);
                              }),
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text('Sl no.'),
                                ),
                                DataColumn(
                                  label: Text('Name'),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                snapshot.data!.length,
                                (int index) => DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3);
                                    } else {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1);
                                    }
                                  }),
                                  cells: <DataCell>[
                                    DataCell(Text(snapshot.data![index]['Sl_no']
                                        .toString())),
                                    DataCell(SizedBox(
                                        width: 120,
                                        child: Text(snapshot.data![index]
                                                ['Name']
                                            .toString())))
                                  ],
                                  selected: selected[index],
                                  onSelectChanged: (bool? value) {
                                    setState(() {
                                      select = true;
                                      selected[index] = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                ElevatedButton(
                  onPressed: () {
                    var rng = Random();
                    for (var i = 0; i < selected.length; i++) {
                      if (!selected[i]) {
                        ar = globals.areas[rng.nextInt(globals.areas.length)];
                        mydatabase.myRunQuery(
                            myquery:
                                '''UPDATE Staff SET Area = '$ar' WHERE Sl_no = ${sls[i]}''',
                            myGet: false,
                            myWrite: true);
                      }
                    }
                  },
                  child: const Text(
                    'Assign',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ]),
        ),
        Form(
          key: _formKeyadd,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerARArea,
                    decoration: const InputDecoration(hintText: 'Area'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Area';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKeyadd.currentState!.validate()) {
                      globals.areas.add(myControllerARArea.text);
                      setState(() {
                        myControllerARArea = TextEditingController();
                      });
                    }
                  },
                  child: const Text(
                    '+ Add Area ',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blue.withOpacity(0.7), width: 5),
                        borderRadius: BorderRadius.circular(12)),
                    width: 275,
                    height: 400,
                    child: SingleChildScrollView(
                      controller: scroll1,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return Colors.blue.withOpacity(0.5);
                        }),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('Area'),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          globals.areas.length,
                          (int index) => DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (index.isEven) {
                                return Colors.blue.withOpacity(0.3);
                              }
                              return Colors.blue.withOpacity(0.1);
                            }),
                            cells: <DataCell>[
                              DataCell(SizedBox(
                                  width: 200,
                                  child: Text(globals.areas[index]))),
                            ],
                          ),
                        ),
                      ),
                    )),
              ]),
        ),
      ],
    );
  }
}

//page 9: staff data
class NinthRouteStaffData extends StatelessWidget {
  const NinthRouteStaffData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SideBarMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: const Text(
          "Staff Data",
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ),
      body: const StaffSearchForm(),
    );
  }
}

//staff data form
class StaffSearchForm extends StatefulWidget {
  const StaffSearchForm({Key? key}) : super(key: key);

  @override
  StaffSearchFormState createState() {
    return StaffSearchFormState();
  }
}

class StaffSearchFormState extends State<StaffSearchForm> {
  final _formKey = GlobalKey<FormState>();
  final myControllerStaffSearch = TextEditingController();
  List<String?>? action;
  List<Map<String, Object?>>? actioned;
  List<String?>? isChecked;

  @override
  void dispose() {
    myControllerStaffSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20)),
          const Text(
            'Staff',
            style: TextStyle(
              fontSize: 55,
              color: Colors.blue,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: myControllerStaffSearch,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 700)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddStaff').then((flag) {
                      if (flag != null) {
                        setState(() {});
                      }
                    });
                  },
                  child: const Text(
                    '+ Add Staff ',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          Flexible(child: myTableBuild(context))
        ],
      ),
    );
  }

  Widget myTableBuild(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                '''SELECT * FROM Staff WHERE (Sl_no||Name||Gender||Date_Of_Birth||Category||Area||Description||Randomize) LIKE '%${myControllerStaffSearch.text}%';'''),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            if (actioned.toString() != snapshot.data.toString()) {
              action = List.generate(snapshot.data!.length, (int ind) => null);
              isChecked = List.generate(snapshot.data!.length,
                  (int ind) => snapshot.data![ind]['Randomize'].toString());
              actioned = snapshot.data;
            }
            return SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.blue.withOpacity(0.7);
                  }),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Sl no.'),
                    ),
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Gender'),
                    ),
                    DataColumn(
                      label: Text('Age'),
                    ),
                    DataColumn(
                      label: Text('Category'),
                    ),
                    DataColumn(
                      label: Text('Area'),
                    ),
                    DataColumn(
                      label: Text('Description'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                    DataColumn(
                      label: Text('Randomize Duty'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data!.length,
                    (int index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (index.isEven) {
                          return Colors.blue.withOpacity(0.3);
                        }
                        return Colors.blue.withOpacity(0.1);
                      }),
                      cells: <DataCell>[
                        DataCell(
                            Text(snapshot.data![index]['Sl_no'].toString())),
                        DataCell(SizedBox(
                            width: 100,
                            child: Text(
                                snapshot.data![index]['Name'].toString()))),
                        DataCell(
                            Text(snapshot.data![index]['Gender'].toString())),
                        DataCell(Text(snapshot.data![index]['Date_Of_Birth']
                            .toString()
                            .substring(0, 4)
                            .toString())),
                        DataCell(SizedBox(
                            width: 125,
                            child: Text(
                                snapshot.data![index]['Category'].toString()))),
                        DataCell(SizedBox(
                            width: 100,
                            child: Text(
                                snapshot.data![index]['Area'].toString()))),
                        DataCell(SizedBox(
                            width: 150,
                            child: Text(snapshot.data![index]['Description']
                                .toString()))),
                        DataCell(
                          DropdownButton<String>(
                            hint: const Text('Action'),
                            value: action![index],
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.blue),
                            underline: Container(
                              height: 2,
                              color: Colors.blue,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                action![index] = newValue!;
                                actioned = snapshot.data;
                                switch (action![index]) {
                                  case 'Delete':
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''DELETE FROM Staff WHERE Sl_no = ${snapshot.data![index]['Sl_no']};''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery: '''DELETE FROM StaffFlip;''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''INSERT INTO StaffFlip (Name,Gender,Date_Of_Birth,Category,Area,Description,Randomize) 
                                            SELECT Name,Gender,Date_Of_Birth,Category,Area,Description,Randomize FROM Staff;''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery: '''DELETE FROM Staff;''',
                                        myGet: false,
                                        myWrite: false);
                                    MyDatabase().myRunQuery(
                                        myquery:
                                            '''INSERT INTO Staff (Name,Gender,Date_Of_Birth,Category,Area,Description,Randomize) 
                                            SELECT Name,Gender,Date_Of_Birth,Category,Area,Description,Randomize FROM StaffFlip;''',
                                        myGet: false,
                                        myWrite: true);
                                    break;
                                  case 'Edit':
                                    globals.staff = snapshot.data![index]
                                            ['Sl_no']
                                        .toString();
                                    Navigator.pushNamed(context, '/EditStaff')
                                        .then((flag) {
                                      if (flag != null) {
                                        setState(() {});
                                      }
                                    });
                                    break;
                                  default:
                                }
                              });
                            },
                            items: <String>['Edit', 'Delete']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        DataCell(
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isChecked![index] == 'true' ||
                                isChecked![index] == '1',
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked![index] = value!.toString();
                                MyDatabase().myRunQuery(
                                    myquery:
                                        '''UPDATE Staff SET Randomize = ${isChecked![index]} WHERE Sl_no = ${snapshot.data![index]['Sl_no']};''',
                                    myGet: false,
                                    myWrite: true);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blueAccent;
  }
}

//page 10: add staff
class TenthRouteAddStaff extends StatelessWidget {
  const TenthRouteAddStaff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SideBarMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            );
          },
        ),
        title: const Text("Add Staff"),
      ),
      body: const AddStaffForm(),
    );
  }
}

//add staff form
class AddStaffForm extends StatefulWidget {
  const AddStaffForm({Key? key}) : super(key: key);

  @override
  AddStaffFormState createState() {
    return AddStaffFormState();
  }
}

class AddStaffFormState extends State<AddStaffForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerASName = TextEditingController();
  TextEditingController myControllerASRandomize = TextEditingController();
  TextEditingController myControllerASDescription = TextEditingController();
  TextEditingController myControllerASAddCategory = TextEditingController();
  bool addCategory = false;
  String? catval;
  String arCategory = '';
  String des = 'null';
  String? gender;
  String genderValidator = 'Gender *';
  String? area;
  String areaValidator = 'Area';
  Color areacolor = Colors.blueGrey;
  String? category;
  String categoryValidator = 'Category *';
  DateTime mySelectedDate = DateTime(2010, 1, 1);
  String dateValidator = 'Date of Birth';
  String? mydate;
  bool isChecked = false;
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerASName.dispose();
    myControllerASRandomize.dispose();
    myControllerASDescription.dispose();
    myControllerASAddCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(right: 150, left: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerASName,
                    decoration: const InputDecoration(hintText: 'Name *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextButton(
                    onPressed: () => myselectDate(context),
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    child: Text(
                      dateValidator,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: DropdownButton<String>(
                    disabledHint: const Text('Area for HouseKeeping'),
                    hint: Text(areaValidator),
                    value: area,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: areacolor),
                    underline: Container(
                      height: 2,
                      color: areacolor,
                    ),
                    onChanged: (String? newValue) {
                      if (category == 'HouseKeeping') {
                        setState(() {
                          area = newValue!;
                        });
                      } else {
                        null;
                      }
                    },
                    items: globals.areas
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: DropdownButton<String>(
                    hint: Text(categoryValidator),
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                        switch (category) {
                          case 'Add Category':
                            addCategory = true;
                            areacolor = Colors.blueGrey;
                            area = null;
                            break;
                          case 'HouseKeeping':
                            areacolor = Colors.blue;
                            break;
                          default:
                            area = null;
                            areacolor = Colors.blueGrey;
                            addCategory = false;
                            myControllerASAddCategory = TextEditingController();
                            catval = category;
                            break;
                        }
                      });
                    },
                    items: globals.scategories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const SizedBox(
                height: 70,
                width: 300,
              ),
              SizedBox(
                height: 70,
                width: 300,
                child: TextFormField(
                  enabled: addCategory,
                  controller: myControllerASAddCategory,
                  decoration: const InputDecoration(hintText: 'Add Category'),
                  validator: (value) {
                    if (!addCategory) {
                      return null;
                    }
                    if ((value == null || value.isEmpty) && addCategory) {
                      return 'Please Enter Category';
                    }
                    catval = myControllerASAddCategory.text;
                    return null;
                  },
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: DropdownButton<String>(
                    hint: Text(genderValidator),
                    value: gender,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                    items: <String>['Male', 'Female']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: TextFormField(
                    controller: myControllerASDescription,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: Row(children: [
                    checkboxbuild(context),
                    const Text(
                      'Randomize Duty',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                  ]),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  if (category == null) {
                    categoryValidator = 'Please Select Category';
                    setState(() {});
                  }
                  if (addCategory) {
                    catval = myControllerASAddCategory.text;
                    setState(() {});
                  }
                  if (gender == null) {
                    genderValidator = 'Please Select Gender';
                    setState(() {});
                  }
                  if (myControllerASDescription.text != '') {
                    des = myControllerASDescription.text;
                  }
                  catval ??= category;
                  if (_formKey.currentState!.validate() &&
                      category != null &&
                      gender != null) {
                    mydatabase.myRunQuery(
                        myquery: '''INSERT INTO Staff 
                            (Name,Gender,Date_Of_Birth,Category,Area,Description,Randomize) 
                            VALUES ('${myControllerASName.text}','$gender',
                            '$mydate','$catval',
                            '$area','$des','$isChecked');''',
                        myGet: false,
                        myWrite: true);
                    setState(() {
                      myControllerASName = TextEditingController();
                      myControllerASRandomize = TextEditingController();
                      myControllerASDescription = TextEditingController();
                      des = 'null';
                      gender = null;
                      genderValidator = 'Gender *';
                      category = null;
                      categoryValidator = 'Category *';
                      area = null;
                      areaValidator = 'Area';
                      mySelectedDate = DateTime(2010, 1, 1);
                      isChecked = false;
                      myControllerASAddCategory = TextEditingController();
                      addCategory = false;
                      catval = null;
                    });
                  }
                },
                child: const Text(
                  'Add Staff',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  myselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mySelectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime(2010, 12, 31),
    );
    if (picked != null && picked != mySelectedDate) {
      setState(() {
        mySelectedDate = picked;
        dateValidator = mySelectedDate.toString().substring(0, 10);
        mydate = mySelectedDate.toString().substring(0, 10);
      });
    }
  }

  Widget checkboxbuild(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueAccent;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

//page 11: edit profile
class EleventhRouteProfile extends StatelessWidget {
  const EleventhRouteProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          title: const Text(
            "Profile",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const ProfileTable());
  }
}

//Edit Profile form
class ProfileTable extends StatefulWidget {
  const ProfileTable({Key? key}) : super(key: key);

  @override
  State<ProfileTable> createState() => ProfileTableState();
}

class ProfileTableState extends State<ProfileTable> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerEPUsername = TextEditingController();
  List usernames = [];
  TextEditingController myControllerEPAnswer = TextEditingController();
  TextEditingController myControllerEPFirstname = TextEditingController();
  TextEditingController myControllerEPLastname = TextEditingController();
  TextEditingController myControllerEPBio = TextEditingController();
  String? hint;
  String bio = 'null';
  DateTime? mySelectedDate;
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerEPUsername.dispose();
    myControllerEPAnswer.dispose();
    myControllerEPFirstname.dispose();
    myControllerEPLastname.dispose();
    myControllerEPBio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                '''SELECT * FROM Accounts WHERE Username LIKE  '${globals.name}';'''),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            myControllerEPUsername.text =
                snapshot.data![0]['Username'].toString();
            myControllerEPFirstname.text =
                snapshot.data![0]['Firstname'].toString();
            myControllerEPLastname.text =
                snapshot.data![0]['Lastname'].toString();
            myControllerEPAnswer.text = snapshot.data![0]['Answer'].toString();
            myControllerEPBio.text = snapshot.data![0]['Bio'].toString();
            mySelectedDate ??=
                DateTime.parse(snapshot.data![0]['DoB'].toString());
            hint ??= '${snapshot.data![0]['Hint']}';
            return Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(right: 150, left: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Username: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                                height: 70,
                                width: 300,
                                child: FutureBuilder<
                                        List<Map<String, Object?>>>(
                                    future: mydatabase.myRunQuery(
                                        myGet: true,
                                        myWrite: false,
                                        myquery:
                                            'SELECT Username FROM Accounts;'),
                                    builder: (context,
                                        AsyncSnapshot<
                                                List<Map<String, Object?>>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        usernames = List.generate(
                                            snapshot.data!.length,
                                            (index) =>
                                                '${snapshot.data![index]['Username']}');
                                        return TextFormField(
                                          controller: myControllerEPUsername,
                                          validator: (value) {
                                            if (usernames.contains(value)) {
                                              return 'Username Taken';
                                            }
                                            return null;
                                          },
                                        );
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    })),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('First Name: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: myControllerEPFirstname,
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Hint: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: DropdownButton<String>(
                                value: hint,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.blue),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blue,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    hint = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Favorite Color',
                                  'Name of your Pet',
                                  'Favorite Regular Polyhedra',
                                  'Favorite Animal'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Last Name: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: myControllerEPLastname,
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Answer to hint: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: myControllerEPAnswer,
                              ),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Date of Birth: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextButton(
                                onPressed: () => myselectDate(context),
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                child: Text(
                                  mySelectedDate.toString().substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Bio: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 600,
                              child: TextFormField(
                                  maxLines: 5, controller: myControllerEPBio),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                        onPressed: () {
                          if (myControllerEPBio.text != '') {
                            bio = myControllerEPBio.text;
                          }
                          globals.name = myControllerEPUsername.text;
                          mydatabase.myRunQuery(
                              myquery:
                                  '''UPDATE Accounts SET Username = '${myControllerEPUsername.text}', Answer = '${myControllerEPAnswer.text}', 
                                  Firstname = '${myControllerEPFirstname.text}', Lastname = '${myControllerEPLastname.text}', Hint = '$hint', Bio = '$bio', 
                                  DoB = '${mySelectedDate.toString().substring(0, 10)}' WHERE Username LIKE  '${globals.name}';''',
                              myGet: false,
                              myWrite: true);
                          setState(() {
                            bio = 'null';
                          });
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  myselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mySelectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != mySelectedDate) {
      setState(() {
        mySelectedDate = picked;
      });
    }
  }
}

//page 12: forgot password
class TwelfthRouteForgotPassword extends StatelessWidget {
  const TwelfthRouteForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          title: const Text(
            "Change Password",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const ForgotForm());
  }
}

//forgot password form
class ForgotForm extends StatefulWidget {
  const ForgotForm({Key? key}) : super(key: key);

  @override
  ForgotFormState createState() {
    return ForgotFormState();
  }
}

class ForgotFormState extends State<ForgotForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerFPUsername = TextEditingController();
  final MyDatabase mydatabase = MyDatabase();
  List usernames = [];

  @override
  void dispose() {
    myControllerFPUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: mydatabase.myRunQuery(
            myGet: true,
            myWrite: false,
            myquery: 'SELECT Username FROM Accounts;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            usernames = List.generate(snapshot.data!.length,
                (index) => '${snapshot.data![index]['Username']}');
            return Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Enter Your Username:',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 55,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          width: 550,
                          child: TextFormField(
                            controller: myControllerFPUsername,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xffbbdefb),
                            ),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 35),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Name';
                              }
                              if (!usernames.contains(value)) {
                                return 'Invalid Account';
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              globals.passchange = myControllerFPUsername.text;
                              Navigator.pushNamed(context, '/ChangePass')
                                  .then((flag) {
                                if (flag != null) {
                                  setState(() {});
                                }
                              });
                            }
                          },
                          child: const Text(
                            'Change Password',
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                      ],
                    )
                  ],
                ));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//page 13: sign up
class ThirteenthRouteSignUp extends StatelessWidget {
  const ThirteenthRouteSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          title: const Text(
            "Sign Up",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const SignUpForm());
  }
}

//sign up form
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerSUUsername = TextEditingController();
  List usernames = [];
  TextEditingController myControllerSUPassword = TextEditingController();
  TextEditingController myControllerSUPasswordCheck = TextEditingController();
  String? passValidator;
  TextEditingController myControllerSUAnswer = TextEditingController();
  TextEditingController myControllerSUFirstname = TextEditingController();
  TextEditingController myControllerSULastname = TextEditingController();
  TextEditingController myControllerSUBio = TextEditingController();
  String bio = 'null';
  String? hint;
  String hintValidator = 'Password Hint *';
  DateTime mySelectedDate = DateTime(2020, 1, 1);
  String dateValidator = 'Date of Birth *';
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerSUUsername.dispose();
    myControllerSUPassword.dispose();
    myControllerSUPasswordCheck.dispose();
    myControllerSUAnswer.dispose();
    myControllerSUFirstname.dispose();
    myControllerSULastname.dispose();
    myControllerSUBio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: mydatabase.myRunQuery(
            myGet: true,
            myWrite: false,
            myquery: 'SELECT Username FROM Accounts;'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            usernames = List.generate(snapshot.data!.length,
                (index) => '${snapshot.data![index]['Username']}');
            return Form(
                key: _formKey,
                child: Container(
                    margin: const EdgeInsets.only(right: 150, left: 150),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  controller: myControllerSUUsername,
                                  decoration: const InputDecoration(
                                      hintText: 'Username *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Username';
                                    }
                                    if (usernames.contains(value)) {
                                      return 'Username Taken';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  controller: myControllerSUFirstname,
                                  decoration: const InputDecoration(
                                      hintText: 'First Name *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter First Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: DropdownButton<String>(
                                  hint: Text(hintValidator),
                                  value: hint,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.blue),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blue,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      hint = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Favorite Color',
                                    'Name of your Pet',
                                    'Favorite Regular Polyhedra',
                                    'Favorite Animal'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: myControllerSUPassword,
                                  decoration: const InputDecoration(
                                      hintText: 'Password *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  controller: myControllerSULastname,
                                  decoration: const InputDecoration(
                                      hintText: 'Last Name *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Last Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  controller: myControllerSUAnswer,
                                  decoration: const InputDecoration(
                                      hintText: 'Hint Answer *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Hint Answer';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: myControllerSUPasswordCheck,
                                  decoration: const InputDecoration(
                                      hintText: 'Confirm Password *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Confirm Password';
                                    }
                                    return passValidator;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextButton(
                                  onPressed: () => myselectDate(context),
                                  style: const ButtonStyle(
                                      alignment: Alignment.centerLeft),
                                  child: Text(
                                    dateValidator,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.blueGrey),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  controller: myControllerSUBio,
                                  decoration:
                                      const InputDecoration(hintText: 'Bio'),
                                  maxLines: 5,
                                ),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (hint == null) {
                                      hintValidator = 'Please Select Hint';
                                      setState(() {});
                                    }
                                    if (mySelectedDate
                                            .toString()
                                            .substring(0, 10) ==
                                        DateTime(2020, 1, 1)
                                            .toString()
                                            .substring(0, 10)) {
                                      dateValidator =
                                          'Please Select Date of Birth';
                                      setState(() {});
                                    }
                                    if (mySelectedDate
                                            .toString()
                                            .substring(0, 10) !=
                                        DateTime(2020, 1, 1)
                                            .toString()
                                            .substring(0, 10)) {
                                      dateValidator = mySelectedDate
                                          .toString()
                                          .substring(0, 10);
                                      setState(() {});
                                    }
                                    if (myControllerSUPassword.text !=
                                        myControllerSUPasswordCheck.text) {
                                      passValidator =
                                          'Please Enter Matching Passwords';
                                      setState(() {});
                                    }
                                    if (myControllerSUPassword.text ==
                                        myControllerSUPasswordCheck.text) {
                                      passValidator = null;
                                      setState(() {});
                                    }
                                    if (myControllerSUBio.text != '') {
                                      bio = myControllerSUBio.text;
                                    }
                                    if (_formKey.currentState!.validate() &&
                                        hint != null &&
                                        mySelectedDate
                                                .toString()
                                                .substring(0, 10) !=
                                            DateTime(2020, 1, 1)
                                                .toString()
                                                .substring(0, 10) &&
                                        myControllerSUPassword.text ==
                                            myControllerSUPasswordCheck.text) {
                                      MyDatabase().myRunQuery(
                                          myquery: '''INSERT INTO Accounts 
                            (Username,Password,DoB,Firstname,Lastname,Hint,Answer,Bio) 
                            VALUES ('${myControllerSUUsername.text}','${myControllerSUPassword.text}',
                            '${mySelectedDate.toString().substring(0, 10)}','${myControllerSUFirstname.text}',
                            '${myControllerSULastname.text}','$hint','${myControllerSUAnswer.text}','$bio');''',
                                          myGet: false,
                                          myWrite: true);
                                      globals.name =
                                          myControllerSUUsername.text;
                                      MyDatabase().myRunQuery(
                                          myquery: 'DELETE FROM Products;',
                                          myGet: false,
                                          myWrite: false);
                                      MyDatabase().myRunQuery(
                                          myquery: 'DELETE FROM Staff;',
                                          myGet: false,
                                          myWrite: false);
                                      MyDatabase().mysampleinsert();
                                      setState(() {
                                        myControllerSUUsername =
                                            TextEditingController();
                                        myControllerSUPassword =
                                            TextEditingController();
                                        myControllerSUPasswordCheck =
                                            TextEditingController();
                                        passValidator = null;
                                        myControllerSUAnswer =
                                            TextEditingController();
                                        myControllerSUFirstname =
                                            TextEditingController();
                                        myControllerSULastname =
                                            TextEditingController();
                                        myControllerSUBio =
                                            TextEditingController();
                                        bio = 'null';
                                        hint = null;
                                        hintValidator = 'Password Hint *';
                                        mySelectedDate = DateTime(2020, 1, 1);
                                        dateValidator = 'Date of Birth *';
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(fontSize: 35),
                                  ),
                                )
                              ])
                        ])));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  myselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mySelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != mySelectedDate) {
      setState(() {
        mySelectedDate = picked;
        dateValidator = mySelectedDate.toString().substring(0, 10);
      });
    }
  }
}

//page 14: edit product
class FourteenthRouteEditProduct extends StatelessWidget {
  const FourteenthRouteEditProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const SideBarMenu(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          title: const Text(
            "Edit Product",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const EditProductTable());
  }
}

//edit product form
class EditProductTable extends StatefulWidget {
  const EditProductTable({Key? key}) : super(key: key);

  @override
  State<EditProductTable> createState() => EditProductTableState();
}

class EditProductTableState extends State<EditProductTable> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerEPDItemName = TextEditingController();
  TextEditingController myControllerEPDQuantity = TextEditingController();
  TextEditingController myControllerEPDCostPerUnit = TextEditingController();
  TextEditingController myControllerEPDAlertQuantity = TextEditingController();
  String? quantityval;
  String? costval;
  String? alertval;
  String? category;
  bool addCategory = false;
  String? catval;
  TextEditingController myControllerEPDAddCategory = TextEditingController();
  DateTime? mySelectedDate;
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerEPDItemName.dispose();
    myControllerEPDQuantity.dispose();
    myControllerEPDCostPerUnit.dispose();
    myControllerEPDAlertQuantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                'SELECT * FROM Products WHERE Sl_no = ${globals.product};'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            myControllerEPDItemName.text =
                snapshot.data![0]['Item_Name'].toString();
            myControllerEPDCostPerUnit.text =
                snapshot.data![0]['Cost_Per_Unit'].toString().substring(2);
            myControllerEPDQuantity.text =
                snapshot.data![0]['Quantity'].toString();
            myControllerEPDAlertQuantity.text =
                snapshot.data![0]['Alert_Quantity'].toString();
            mySelectedDate ??= DateTime.parse(
                snapshot.data![0]['Date_Of_Last_Purchase'].toString());
            category ??= snapshot.data![0]['Category'].toString();
            return Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(right: 150, left: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Item Name: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: myControllerEPDItemName,
                              ),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Stock: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                  controller: myControllerEPDQuantity,
                                  validator: (value) {
                                    return quantityval;
                                  }),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Category: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: DropdownButton<String>(
                                value: category,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.blue),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blue,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    category = newValue!;
                                    switch (category) {
                                      case 'Add Category':
                                        addCategory = true;
                                        break;
                                      default:
                                        addCategory = false;
                                        myControllerEPDAddCategory =
                                            TextEditingController();
                                        catval = category;
                                        break;
                                    }
                                  });
                                },
                                items: globals.pcategories
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Alert Quantity: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                  controller: myControllerEPDAlertQuantity,
                                  validator: (value) {
                                    return alertval;
                                  }),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 300,
                          child: TextFormField(
                            enabled: addCategory,
                            controller: myControllerEPDAddCategory,
                            decoration:
                                const InputDecoration(hintText: 'Add Category'),
                            validator: (value) {
                              if (!addCategory) {
                                return null;
                              }
                              if ((value == null || value.isEmpty) &&
                                  addCategory) {
                                return 'Please Enter Category';
                              }
                              catval = myControllerEPDAddCategory.text;
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                          width: 300,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Cost/Unit: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                  controller: myControllerEPDCostPerUnit,
                                  validator: (value) {
                                    return costval;
                                  }),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Date of Last Purchase: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextButton(
                                onPressed: () => myselectDate(context),
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                child: Text(
                                  mySelectedDate.toString().substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                        onPressed: () {
                          if (addCategory) {
                            catval = myControllerEPDAddCategory.text;
                            setState(() {});
                            globals.pcategories
                                .add(myControllerEPDAddCategory.text);
                            category = catval;
                          }
                          if (int.tryParse(myControllerEPDQuantity.text) ==
                              null) {
                            quantityval = 'Please Enter A Number';
                          }
                          if (int.tryParse(myControllerEPDAlertQuantity.text) ==
                              null) {
                            alertval = 'Please Enter A Number';
                          }
                          if (int.tryParse(myControllerEPDCostPerUnit.text) ==
                              null) {
                            costval = 'Please Enter A Number';
                          }
                          catval ??= category;
                          if (_formKey.currentState!.validate()) {
                            mydatabase.myRunQuery(
                                myquery:
                                    '''UPDATE Products SET Item_Name = '${myControllerEPDItemName.text}', Cost_Per_Unit = '₹ ${myControllerEPDCostPerUnit.text}', 
                                  Quantity = ${myControllerEPDQuantity.text}, Alert_Quantity = ${myControllerEPDAlertQuantity.text}, Category = '$catval',
                                  Date_Of_Last_Purchase = '${mySelectedDate.toString().substring(0, 10)}' WHERE Sl_no = ${globals.product};''',
                                myGet: false,
                                myWrite: true);

                            setState(() {
                              myControllerEPDAddCategory =
                                  TextEditingController();
                              addCategory = false;
                              quantityval = null;
                              alertval = null;
                              costval = null;
                            });
                          }
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  myselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mySelectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != mySelectedDate) {
      setState(() {
        mySelectedDate = picked;
      });
    }
  }
}

//page 15: edit staff
class FifteenthRouteEditStaff extends StatelessWidget {
  const FifteenthRouteEditStaff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SideBarMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            );
          },
        ),
        title: const Text("Edit Staff"),
      ),
      body: const EditStaffTable(),
    );
  }
}

//edit staff form
class EditStaffTable extends StatefulWidget {
  const EditStaffTable({Key? key}) : super(key: key);

  @override
  State<EditStaffTable> createState() => EditStaffTableState();
}

class EditStaffTableState extends State<EditStaffTable> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerESName = TextEditingController();
  TextEditingController myControllerESDescription = TextEditingController();
  String des = 'null';
  String? myArea;
  String areaValidator = 'Area';
  Color areacolor = Colors.blueGrey;
  String? myGender;
  String? myCategory;
  DateTime? mySelectedDate;
  bool? isChecked;
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerESName.dispose();
    myControllerESDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery: 'SELECT * FROM Staff WHERE Sl_no = ${globals.staff};'),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            myControllerESName.text = snapshot.data![0]['Name'].toString();
            myControllerESDescription.text =
                snapshot.data![0]['Description'].toString();
            myGender ??= snapshot.data![0]['Gender'].toString();
            myArea ??= snapshot.data![0]['Area'].toString();
            mySelectedDate ??= DateTime.tryParse(
                snapshot.data![0]['Date_Of_Birth'].toString());
            myCategory ??= snapshot.data![0]['Category'].toString();
            isChecked ??= snapshot.data![0]['Randomize'].toString() == 'true' ||
                snapshot.data![0]['Randomize'].toString() == '1';
            mySelectedDate ??= DateTime(2010, 1, 1);
            if (myCategory == 'HouseKeeping') {
              areacolor = Colors.blue;
            } else {
              areacolor = Colors.blueGrey;
            }
            if (myArea == 'null' || myCategory != 'HouseKeeping') {
              myArea = null;
            }
            return Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(right: 150, left: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Name: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: myControllerESName,
                              ),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Gender: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: DropdownButton<String>(
                                value: myGender,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.blue),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blue,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    myGender = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Male',
                                  'Female'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Category: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: DropdownButton<String>(
                                value: myCategory,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.blue),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blue,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    myCategory = newValue!;
                                    switch (myCategory) {
                                      case 'HouseKeeping':
                                        areacolor = Colors.blue;
                                        break;
                                      default:
                                        areaValidator = 'Area for HouseKeeping';
                                        myArea = null;
                                        areacolor = Colors.blueGrey;
                                        break;
                                    }
                                  });
                                },
                                items: globals.scategories
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Area: ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: DropdownButton<String>(
                                hint: Text(areaValidator),
                                value: myArea,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: areacolor),
                                underline: Container(
                                  height: 2,
                                  color: areacolor,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (myCategory == 'HouseKeeping') {
                                      setState(() {
                                        myArea = newValue;
                                      });
                                    } else {
                                      null;
                                    }
                                  });
                                },
                                items: globals.areas
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Description: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: myControllerESDescription,
                              ),
                            ),
                          ]),
                        ]),
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text('Date of Birth: ',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: TextButton(
                                onPressed: () => myselectDate(context),
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                child: Text(
                                  mySelectedDate.toString().substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 300,
                          child: Row(children: [
                            checkboxbuild(context),
                            const Text(
                              'Randomize Duty',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                        onPressed: () {
                          if (myControllerESDescription.text != '') {
                            des = myControllerESDescription.text;
                          }
                          mydatabase.myRunQuery(
                              myquery:
                                  '''UPDATE Staff SET Name = '${myControllerESName.text}', Gender = '$myGender', Randomize = '$isChecked', 
                                  Area = '$myArea', Description = '$des', Category = '$myCategory',
                                  Date_Of_Birth = '${mySelectedDate.toString().substring(0, 10)}' WHERE Sl_no = ${globals.staff};''',
                              myGet: false,
                              myWrite: true);
                          setState(() {
                            des = 'null';
                          });
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  myselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mySelectedDate!,
      firstDate: DateTime(1960),
      lastDate: DateTime(2010, 12, 31),
    );
    if (picked != null && picked != mySelectedDate) {
      setState(() {
        mySelectedDate = picked;
      });
    }
  }

  Widget checkboxbuild(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueAccent;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

//page 16: view profile
class SixteenthRouteViewProfile extends StatelessWidget {
  const SixteenthRouteViewProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: const Text(
            "Profile",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const ViewProfileTable());
  }
}

//Profile form
class ViewProfileTable extends StatefulWidget {
  const ViewProfileTable({Key? key}) : super(key: key);

  @override
  State<ViewProfileTable> createState() => ViewProfileTableState();
}

class ViewProfileTableState extends State<ViewProfileTable> {
  final MyDatabase mydatabase = MyDatabase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
        future: MyDatabase().myRunQuery(
            myGet: true,
            myWrite: false,
            myquery:
                '''SELECT * FROM Accounts WHERE Username LIKE  '${globals.name}';'''),
        builder: (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if (snapshot.hasData) {
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffbbdefb),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: SizedBox(
                        height: 400,
                        width: 800,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(snapshot.data![0]['Username'].toString(),
                                style: const TextStyle(
                                    fontSize: 50,
                                    color: Color(0xff2979ff),
                                    decoration: TextDecoration.underline)),
                            Text(
                                snapshot.data![0]['Firstname'].toString() +
                                    ' ' +
                                    snapshot.data![0]['Lastname'].toString(),
                                style: const TextStyle(
                                    fontSize: 35, color: Color(0xff2979ff))),
                            Text(
                                (int.parse(DateTime.now()
                                                .toString()
                                                .substring(0, 4)) -
                                            int.parse(snapshot.data![0]['DoB']
                                                .toString()
                                                .substring(0, 4)))
                                        .toString() +
                                    ' Years Old',
                                style: const TextStyle(
                                    fontSize: 35, color: Color(0xff2979ff))),
                            Text(
                              snapshot.data![0]['Bio'].toString(),
                              style: const TextStyle(
                                  fontSize: 30, color: Color(0xff2979ff)),
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/EditProfile')
                              .then((flag) {
                            if (flag != null) {
                              setState(() {});
                            }
                          });
                        },
                        label: const Text('Edit',
                            style: TextStyle(
                                fontSize: 35, color: Color(0xff2979ff))),
                        icon: const Icon(Icons.edit_outlined,
                            color: Color(0xff2979ff)))
                  ])
            ]);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

//page 17: change password
class SeventeenthRouteChangePassword extends StatelessWidget {
  const SeventeenthRouteChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            },
          ),
          title: const Text(
            "Change Password",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        body: const ChangePasswordForm());
  }
}

//sign up form
class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  ChangePasswordFormState createState() {
    return ChangePasswordFormState();
  }
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController myControllerCPPassword = TextEditingController();
  TextEditingController myControllerCPPasswordCheck = TextEditingController();
  String? passValidator;
  TextEditingController myControllerCPAnswer = TextEditingController();
  final MyDatabase mydatabase = MyDatabase();

  @override
  void dispose() {
    myControllerCPPassword.dispose();
    myControllerCPPasswordCheck.dispose();
    myControllerCPAnswer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<List<Map<String, Object?>>>(
            future: mydatabase.myRunQuery(
                myGet: true,
                myWrite: false,
                myquery:
                    '''SELECT Hint,Answer FROM Accounts WHERE Username LIKE '${globals.passchange}';'''),
            builder:
                (context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
              if (snapshot.hasData) {
                return Form(
                    key: _formKey,
                    child: Container(
                        margin: const EdgeInsets.only(right: 150, left: 150),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(snapshot.data![0]['Hint'].toString()),
                              SizedBox(
                                height: 100,
                                width: 200,
                                child: TextFormField(
                                  controller: myControllerCPAnswer,
                                  decoration: const InputDecoration(
                                      hintText: 'Answer to Hint *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Answer the Hint Question';
                                    }
                                    if (snapshot.data![0]['Answer']
                                            .toString() !=
                                        value) {
                                      return 'Incorrect Answer';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: myControllerCPPassword,
                                  decoration: const InputDecoration(
                                      hintText: 'New Password *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter New Password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: myControllerCPPasswordCheck,
                                  decoration: const InputDecoration(
                                      hintText: 'Confirm New Password *'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Confirm New Password';
                                    }
                                    return passValidator;
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (myControllerCPPassword.text !=
                                      myControllerCPPasswordCheck.text) {
                                    passValidator =
                                        'Please Enter Matching Passwords';
                                    setState(() {});
                                  }
                                  if (myControllerCPPassword.text ==
                                      myControllerCPPasswordCheck.text) {
                                    passValidator = null;
                                    setState(() {});
                                  }
                                  if (_formKey.currentState!.validate() &&
                                      myControllerCPPassword.text ==
                                          myControllerCPPasswordCheck.text) {
                                    mydatabase.myRunQuery(
                                        myquery:
                                            '''UPDATE Accounts SET Password = '${myControllerCPPassword.text}'
                                              WHERE Username = '${globals.passchange}';''',
                                        myGet: false,
                                        myWrite: false);
                                    mydatabase.mychangedpass();
                                    setState(() {
                                      myControllerCPPassword =
                                          TextEditingController();
                                      myControllerCPPasswordCheck =
                                          TextEditingController();
                                      passValidator = null;
                                      myControllerCPAnswer =
                                          TextEditingController();
                                    });
                                  }
                                },
                                child: const Text(
                                  'Change Password',
                                  style: TextStyle(fontSize: 35),
                                ),
                              )
                            ])));
              } else {
                return const CircularProgressIndicator();
              }
            })
      ],
    );
  }
}

//side bar menu
class SideBarMenu extends StatelessWidget {
  const SideBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[800],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(bottom: 50)),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              onTap: () => {Navigator.pushNamed(context, '/Profile')},
            ),
            const Padding(padding: EdgeInsets.only(bottom: 50)),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              onTap: () => {
                MyDatabase().myRunQuery(
                    myquery: '''DELETE FROM Products;''',
                    myGet: false,
                    myWrite: false),
                MyDatabase().myRunQuery(
                    myquery: '''DELETE FROM Staff;''',
                    myGet: false,
                    myWrite: false),
                Navigator.popUntil(context, ModalRoute.withName('/Login')),
              },
            ),
          ],
        ),
      ),
    );
  }
}

//database
class MyDatabase {
  final Files myfilea =
      Files(myFileName: 'Accounts', username: 'none', mynew: false);
  Files myfilep =
      Files(myFileName: 'Products', username: globals.name, mynew: false);
  Files myfiles =
      Files(myFileName: 'Staff', username: globals.name, mynew: false);
  Files myfileg =
      Files(myFileName: 'Globs', username: globals.name, mynew: false);
  final Files myfilepn =
      Files(myFileName: 'Products', username: globals.name, mynew: true);
  final Files myfilesn =
      Files(myFileName: 'Staff', username: globals.name, mynew: true);
  final Files myfilegn =
      Files(myFileName: 'Globs', username: globals.name, mynew: true);
  String file = '';
  List<String> filerows = [];
  List<String> filecontents = [];
  List<Map<String, Object?>> result = [];
  List glob = [];

  Future<List<Map<String, Object?>>> myRunQuery(
      {required String myquery,
      required bool myGet,
      required bool myWrite}) async {
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    if (myGet == true) {
      var result = await db.rawQuery(myquery);
      return result;
    } else {
      await db.execute(myquery);
      if (myWrite) {
        result = await db.rawQuery('SELECT * FROM Products;');
        await myfilep.mywritefile(result);
        result = await db.rawQuery('SELECT * FROM Staff;');
        await myfiles.mywritefile(result);
        result = await db.rawQuery('SELECT * FROM Accounts;');
        await myfilea.mywritefile(result);
        glob = [globals.pcategories, globals.scategories, globals.areas];
        await myfileg.mywriteglobs(glob);
      }
      return [];
    }
  }

  void myinsert() async {
    file = await myfilep.myreadfile();
    filerows = file.split('|');
    for (String i in filerows) {
      filecontents = i.split('/');
      if (filecontents.length > 1) {
        myRunQuery(
            myquery: '''INSERT INTO Products 
                            (Sl_no,Item_Name,Quantity,Cost_Per_Unit,Date_Of_Last_Purchase,Category,Alert_Quantity) 
                            VALUES (${filecontents[0]},'${filecontents[1]}',
                            ${filecontents[2]},'${filecontents[3]}',
                            '${filecontents[4]}','${filecontents[5]}',${filecontents[6]});''',
            myGet: false,
            myWrite: false);
      }
    }
    file = '';
    filerows = [];
    filecontents = [];
    file = await myfiles.myreadfile();
    filerows = file.split('|');
    for (String i in filerows) {
      filecontents = i.split('/');
      if (filecontents.length > 1) {
        myRunQuery(
            myquery: '''INSERT INTO Staff 
                            (Sl_no,Name,Gender,Date_Of_Birth,Category,Area,Description,Randomize) 
                            VALUES (${filecontents[0]},'${filecontents[1]}',
                            '${filecontents[2]}','${filecontents[3]}',
                            '${filecontents[4]}','${filecontents[5]}','${filecontents[6]}','${filecontents[7]}');''',
            myGet: false,
            myWrite: false);
      }
    }
    file = '';
    filerows = [];
    filecontents = [];
    file = await myfileg.myreadfile();
    filerows = file.split('|');
    if (filerows.length > 2) {
      filecontents = filerows[0].split('/');
      globals.pcategories = [];
      globals.pcategories.addAll(filecontents);
      filecontents = filerows[1].split('/');
      globals.scategories = [];
      globals.scategories.addAll(filecontents);
      filecontents = filerows[2].split('/');
      globals.areas = [];
      globals.areas.addAll(filecontents);
    }
    file = '';
    filerows = [];
    filecontents = [];
  }

  void mysampleinsert() async {
    file = await myfilepn.myreadfile();
    filerows = file.split('|');
    for (String i in filerows) {
      filecontents = i.split('/');
      if (filecontents.length > 1) {
        myRunQuery(
            myquery: '''INSERT INTO Products 
                            (Sl_no,Item_Name,Quantity,Cost_Per_Unit,Date_Of_Last_Purchase,Category,Alert_Quantity) 
                            VALUES (${filecontents[0]},'${filecontents[1]}',
                            ${filecontents[2]},'${filecontents[3]}',
                            '${filecontents[4]}','${filecontents[5]}',${filecontents[6]});''',
            myGet: false,
            myWrite: false);
      }
    }
    file = '';
    filerows = [];
    filecontents = [];
    file = await myfilesn.myreadfile();
    filerows = file.split('|');
    for (String i in filerows) {
      filecontents = i.split('/');
      if (filecontents.length > 1) {
        myRunQuery(
            myquery: '''INSERT INTO Staff 
                            (Sl_no,Name,Gender,Date_Of_Birth,Category,Area,Description,Randomize) 
                            VALUES (${filecontents[0]},'${filecontents[1]}',
                            '${filecontents[2]}','${filecontents[3]}',
                            '${filecontents[4]}','${filecontents[5]}','${filecontents[6]}','${filecontents[7]}');''',
            myGet: false,
            myWrite: false);
      }
    }
    file = '';
    filerows = [];
    filecontents = [];
    file = await myfilegn.myreadfile();
    filerows = file.split('|');
    filecontents = filerows[0].split('/');
    globals.pcategories = [];
    globals.pcategories.addAll(filecontents);
    filecontents = filerows[1].split('/');
    globals.scategories = [];
    globals.scategories.addAll(filecontents);
    filecontents = filerows[2].split('/');
    globals.areas = [];
    globals.areas.addAll(filecontents);
    file = '';
    filerows = [];
    filecontents = [];
    myRunQuery(myquery: '', myGet: false, myWrite: true);
  }

  void mychangedpass() async {
    result = await myRunQuery(
        myquery: 'SELECT * FROM Accounts;', myGet: true, myWrite: false);
    await myfilea.mywritefile(result);
  }
}

//files
class Files {
  final String myFileName;
  String username;
  bool mynew;

  Files(
      {required this.myFileName, required this.username, required this.mynew});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    if (mynew) {
      return File('$path\\IB Comp IA Data\\locked\\sample$myFileName.txt');
    }
    if (username == 'none') {
      return File('$path\\IB Comp IA Data\\accounts.txt');
    }
    return File('$path\\IB Comp IA Data\\$username$myFileName.txt');
  }

  Future<String> myreadfile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> mywritefile(List<Map<String, Object?>> data) async {
    final file = await _localFile;
    List<String> writelist = [];
    String writes = '';
    List<String> writelistt = [];
    String writest = '';

    for (var i = 0; i < data.length; i++) {
      for (var j in data[i].values) {
        writelist.add(j.toString());
      }
      writes = writelist.join('/');
      writelist = [];
      writelistt.add(writes);
    }
    writest = writelistt.join('|');
    return file.writeAsString(writest);
  }

  Future<File> mywriteglobs(List data) async {
    final file = await _localFile;
    List<String> writelist = [];
    String writes = '';
    List<String> writelistt = [];
    String writest = '';

    for (var i in data) {
      for (var j in i) {
        writelist.add(j.toString());
      }
      writes = writelist.join('/');
      writelist = [];
      writelistt.add(writes);
    }
    writest = writelistt.join('|');
    return file.writeAsString(writest);
  }
}
