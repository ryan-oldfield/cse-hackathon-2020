import 'package:flutter/material.dart';
import 'package:qpeople/loading.dart';
import 'package:qpeople/home.dart';
import 'package:qpeople/userSearch.dart';
import 'package:qpeople/shopInfo.dart';
import 'package:qpeople/shop.dart';
import 'package:qpeople/confirmation.dart';
import 'package:qpeople/constants.dart';
import 'package:qpeople/searchappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  List<Shop> shops;
  var map1;

  @override
  void initState() {
    super.initState();

    Shop shop1 =  Shop(name: "Testing 1", location: "123 Fake Street", curr_occupancy: 1, key: UniqueKey());
    Shop shop2 = new Shop(name: "Testing 2", location: "456 Fake Street", curr_occupancy: 10, key: UniqueKey());
    Shop shop3 = new Shop(name: "Testing 3", location: "789 Fake Street", curr_occupancy: 5, key: UniqueKey());
    Shop shop4 = new Shop(name: "Testing 3", location: "789 Fake Street", curr_occupancy: 5, key: UniqueKey());
    shops = [shop1, shop2, shop3, shop4];

  }
  

  void callback(List updatedShops, Shop updatedShop ) {
    print(updatedShops);
    setState(() {
      updatedShop.curr_occupancy -= 1;
      this.shops = updatedShops;
    });
  }


  Widget _buildAd() => Padding(
    padding: const EdgeInsets.only(top: 530.0),
    child: WhileYouWait(),
  );

  Widget _buildCard() => Padding(
    padding: const EdgeInsets.only(top: 130.0),
    child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: 400,
              height: 400,
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 400,
                    child: StreamBuilder(
                        stream: Firestore.instance.collection(('bandname')).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const Text('Loading...');

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return HomeCard(shop: snapshot.data.documents[index], join: false, callback: callback);
                            },
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )

    ),
  );

  Widget _buildBackground() => new Scaffold(
    appBar: SearchAppBar(
      title: '',
      showBackButton: false,
      showBar: false,
    ),
  );


  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List();

    children.add(_buildBackground());
    children.add(_buildCard());
    children.add(_buildAd());

    return MaterialApp(
      home: Stack(
        children: children,
      ),
    );
  }

}

// TODO: Change Name
class HomeCard extends StatefulWidget {
  DocumentSnapshot shop;
  bool join;
  Function callback;

  HomeCard({this.shop, this.join, this.callback});

  @override
  _HomeCardState createState() => _HomeCardState();
}


class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    String buttonText;
    //print("${widget.shop.location}");
    if (widget.join) {
      buttonText = "Join Queue";
    } else {
      buttonText = "Leave Queue";
    }
    //print(buttonText);
    return Center(
      child: Container(
        width: 350,
        child: Card(
          elevation: 20.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20),
                    child: Text(
                      widget.shop['shop'],
                      style: cardHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,),
                    child: Text(
                      widget.shop['shop'],
                      style: cardSubHeading,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 12.0),
                    child: RaisedButton(
                      elevation: 20.0,
                      color: buttonColor,
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        //widget.shopList.removeAt(widget.index);
                        //widget.callback(widget.shopList, widget.shop);

                      },
                      child: Text(
                        buttonText,
                        style: buttonTextStyle,
                      ),
                    ),
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, top: 20.0),
                child: QueueLength(infront: widget.shop['Qnumber']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class QueueLength extends StatelessWidget {
  int infront;
  QueueLength({this.infront});

  @override
  Widget build(BuildContext context) {
    Color startColor = lowCapacityStartColor;
    Color endColor = lowCapacityEndColor;
    if (infront > 9) {
      startColor = highCapacityStartColor;
      endColor = highCapacityEndColor;
    } else if (infront > 4) {
      startColor = mediumCapacityStartColor;
      endColor = mediumCapacityEndColor;

    }
    return Container(
      height: 100,
      width: 100.0,

      child: Card(
        elevation: 20.0,
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Text(
                "${infront}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0
                ),
              ),
              Text(
                "In Front",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [startColor, endColor]
            ),
          ),

        ),

      ),
    );

  }


}





class DataBaseItems extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                document['shop'],
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xffddddff)
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                document['Qnumber'].toString(),
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
            )
          ],
        ),
        onTap: () {
          document.reference.updateData({
            'Qnumber': document['Qnumber'] + 1
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Name'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection(('bandname')).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }
}

class WhileYouWait extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center (
      child: Container (
        width: 350,
        height: 190,
        child: Card(
          elevation: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Try While You Wait",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
                ),
              ),
              //SizedBox(height: 8,),
              Center(
                child: Container(
                  width: 320,
                  height: 115,

                  child: Card(
                    elevation: 10.0,
                    child: Image.asset(
                      "assets/images/game_ad.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}