import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/data.dart';
import '../helpers/constants.dart';
import '../widgets/boundary.dart';
import 'authentication_screen.dart';
import 'create_event_screen.dart';
import 'event_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/home-screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  var currentIndex = 2;

  @override
  void initState() {
    Provider.of<Data>(context, listen: false)
        .initializeUserFromCache()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  //Manage selected index on Bottom Navigation Bar
  void _selectedTab(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      //Reset index to home and push page
      setState(() {
        currentIndex = 2;
      });
    } else {
      //Reset index to home and push page
      setState(() {
        currentIndex = 2;
      });
      Navigator.of(context).pushNamed(EventScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<Data>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Creative Cult",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        elevation: 5,
        backgroundColor: primaryColor,
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                await Provider.of<Data>(context, listen: false).logout();
                Navigator.of(context)
                    .pushReplacementNamed(AuthenticationScreen.route);
              } catch (error) {
                final snackBar = SnackBar(
                  content: Text(
                    error.toString(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: primaryColor,
                    ),
                  ),
                  action: SnackBarAction(
                    label: 'Okay',
                    onPressed: () {},
                    textColor: Colors.red,
                  ),
                  backgroundColor: Colors.red[100],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/images/Logout.svg",
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(CreateEventScreen.route);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10.0,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  _selectedTab(0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.monetization_on,
                    color: currentIndex == 0 ? primaryColor : Colors.black,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const Spacer(),
              const SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  _selectedTab(3);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.event,
                    color: currentIndex == 1 ? primaryColor : Colors.black,
                    size: 28,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          width: 132,
                          height: 132,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: BoundaryWidget(
                            sweepAngle: 359.9,
                            color: primaryColor,
                            thickness: 4,
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/images/Person.svg",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    currentUser!.name,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    currentUser.email,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: Text(
                      "Hey ${currentUser.name}! Welcome to Creative Cult! You can create a new event from the plus button. To view events checkout the right tab and to view requests for artwork visit the left tab.",
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SvgPicture.asset(
                    "assets/images/HomeIllustration.svg",
                  )
                ],
              ),
            ),
    );
  }
}
