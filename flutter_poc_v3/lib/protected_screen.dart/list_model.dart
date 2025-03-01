import 'package:flutter/material.dart';

class ListModel extends StatefulWidget {
  const ListModel({super.key});

  @override
  State<ListModel> createState() => _ListModelState();
}

class _ListModelState extends State<ListModel> {
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0),
        
             
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                  children: [
                    Row(
                      children: [
                        Icon(Icons.search_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Cars",
                          style: TextStyle(fontSize: 23),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.search_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Properties", style: TextStyle(fontSize: 23)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.search_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Mobiles", style: TextStyle(fontSize: 23)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.search_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Bikes", style: TextStyle(fontSize: 23)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.search_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Furniture", style: TextStyle(fontSize: 23)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.search_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Jobs", style: TextStyle(fontSize: 23)),
                      ],
                    ),
                    TextButton(
                        onPressed: () {},
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(fontSize: 25),
                            )))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
