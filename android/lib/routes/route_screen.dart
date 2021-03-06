import 'package:beware_travel_safe/models/get_data.dart';
import 'package:beware_travel_safe/providers/auth_provider.dart';
import 'package:beware_travel_safe/routes/profile_screen.dart';
import 'package:beware_travel_safe/routes/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RouteScreen extends StatefulWidget {
  @override
  RouteScreenState createState() => RouteScreenState();
}

class RouteScreenState extends State<RouteScreen> {
  final GlobalKey<ScaffoldState> scaffoldKeyRouteScreen =
      GlobalKey<ScaffoldState>();

  GoogleMapController mapController;
  Position position;
  bool _isInit;
  bool _isLoading;
  bool _isLoadingLoc;
  bool _isCrimeSelected = true;
  Map<String, String> queryparam = {'type': ''};
  List<GetData> locData = [];

  @override
  void initState() {
    _isInit = true;
    _isLoading = true;
    _isLoadingLoc = true;
    queryparam = {'type': ''};
    super.initState();
  }

  final LatLng _center = const LatLng(28.616552, 77.176097);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoadingLoc = true;
      });
      await Provider.of<Auth>(context)
          .getDataOfLoc(queryParameters: queryparam)
          .then((_) {
        setState(() {
          locData = Provider.of<Auth>(context).getData;
          _isLoadingLoc = false;
          // print(locData);
        });
      });
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      for (var i = 0; i < locData.length; i++)
        Marker(
          markerId: MarkerId(locData[i].sId),
          position: LatLng(locData[i].latitude, locData[i].longitude),
          icon: BitmapDescriptor.defaultMarker,
          //infoWindow: InfoWindow(title: "current location"),
        )
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKeyRouteScreen,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.60,
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontFamily: "Montserrat",
                      fontSize: 20.0,
                      wordSpacing: 1,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF7B65E4),
                  ),
                ),
              ),
              Consumer<Auth>(
                builder: (_, customer, ch) => ListTile(
                  dense: true,
                  title: Text('View Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
              ),
              Divider(),
              ListTile(
                dense: true,
                title: Text('Search'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            markers: _createMarker(),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
          ),
          // if (_isLoading)
          //   Container(
          //       padding: EdgeInsets.only(
          //           top: MediaQuery.of(context).size.height / 2.2,
          //           left: MediaQuery.of(context).size.width / 2.2),
          //       child: CircularProgressIndicator(
          //         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B65E4)),
          //       )),
          Container(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0)),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 40.0, left: 20.0, right: 20.0, bottom: 12.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            scaffoldKeyRouteScreen.currentState.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: Color(0xFF7B65E4),
                            size: 32.0,
                          ),
                        ),
                        Text(
                          'Home',
                          style: Theme.of(context).textTheme.title,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.search,
                            color: Color(0xFF7B65E4),
                            size: 32.0,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (_isCrimeSelected)
                            Image(
                              height: 52.0,
                              image:
                                  AssetImage('assets/images/crimeselected.png'),
                            ),
                          if (_isCrimeSelected)
                            Image(
                              height: 52.0,
                              image: AssetImage(
                                  'assets/images/accidentunselected.png'),
                            ),
                          if (!_isCrimeSelected)
                            Image(
                              height: 52.0,
                              image: AssetImage(
                                  'assets/images/crimeunselcted.png'),
                            ),
                          if (!_isCrimeSelected)
                            Image(
                              height: 52.0,
                              image: AssetImage(
                                  'assets/images/accidentselected.png'),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
