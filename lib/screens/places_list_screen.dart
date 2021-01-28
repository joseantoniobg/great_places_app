import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <=
                          0
                      ? ch
                      : ListView.builder(
                          itemBuilder: (ctx, i) => Card(
                            child: ListTile(
                              visualDensity: VisualDensity.comfortable,
                              leading: Container(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      FileImage(greatPlaces.items[i].image),
                                ),
                              ),
                              title: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  greatPlaces.items[i].title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                      greatPlaces.items[i].location.address)),
                              onTap: () {
                                // go to detail page...
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {},
                              ),
                            ),
                            elevation: 5,
                          ),
                          itemCount: greatPlaces.items.length,
                        ),
                  child: Center(
                    child: Text('Got no places Yet, start adding some!'),
                  ),
                ),
        ),
      ),
    );
  }
}
