import 'dart:ui';

import 'package:cicil_demo/home/model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.lender});
  final String lender;
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String username = "Naol Abera";
  // String welcome = ""+lender.toString();
  String value = "1465";
  final controller = ScrollController();

  bool isgoodornot = false;

  List accounts = [
    MyList(
        title: "Lender",
        subtitle: "2022-08-21 02:14:12",
        money: "\$250",
        isgood: false),
    MyList(
        title: "Lender",
        subtitle: "2022-07-12 05:07:12",
        money: "\$100",
        isgood: false),
    MyList(
        title: "Borrower",
        subtitle: "2022-05-20 07:12:12",
        money: "\$100",
        isgood: true),
    MyList(
        title: "Lender",
        subtitle: "2022-05-14 03:33:22",
        money: "\$300",
        isgood: true),
    MyList(
        title: "Lender",
        subtitle: "2022-05-04 01:32:14",
        money: "\$700",
        isgood: false)
  ];

  int _pageindex = 0;

  void onPageChanged(int _index) {
    setState(() {
      _pageindex = _index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello $username",
                            style: const TextStyle(
                              color: Colors.white30,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            widget.lender,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {},
                        icon:  Stack(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Logout'),
                            ),
                            const Positioned(
                              left: 14,
                              child: Icon(
                                Icons.brightness_1,
                                color: Colors.red,
                                size: 9.0,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black,
                      Colors.black26,
                      Colors.lightBlue,
                      Colors.lightBlue,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Current balance",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "\$ $value",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white60, Colors.white10],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 2, color: Colors.white60),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.add,
                                size: 37,
                                color: Colors.white60,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _tiles(
                      Icons.send, Colors.orange, Colors.purpleAccent, "Send"),
                  _tiles(Icons.money, Colors.orange, Colors.greenAccent,
                      "Withdraw"),
                  _tiles(Icons.monetization_on_outlined, Colors.orange,
                      Colors.blueAccent, "Donate"),
                  _tiles(Icons.sim_card_outlined, Colors.orange, Colors.indigo,
                      "Pay QR"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _tiles(Icons.arrow_downward, Colors.blueGrey, Colors.red,
                      "Lend"),
                  _tiles(Icons.note_alt_outlined, Colors.blueGrey, Colors.green,
                      "Statement"),
                  _tiles(Icons.paypal, Colors.blueGrey, Colors.purpleAccent,
                      "Pay Bills"),
                  _tiles(Icons.currency_exchange, Colors.blueGrey,
                      Colors.deepPurple, "Loan"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Recent transactions",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "See all",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          ),
                        )),
                  ),
                ],
              ),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ScrollConfiguration(
                    behavior: const MaterialScrollBehavior()
                        .copyWith(overscroll: false),
                    child: ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        itemCount: accounts.length,
                        itemBuilder: (context, index) {
                          bool isornot = accounts[index].isgood;

                          return ListTile(
                            title: Text(
                              accounts[index].title,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            subtitle: Text(accounts[index].subtitle,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  accounts[index].money,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                isornot == false
                                    ? const Icon(
                                        Icons.arrow_downward_outlined,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.arrow_upward_outlined,
                                        color: Colors.green,
                                      ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container _tiles(IconData icon, Color color1, color2, String title) {
  return Container(
    height: 85,
    width: 85,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [
          color1,
          color2,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: ListTile(
      title: Icon(
        icon,
        size: 45,
        color: Colors.white70,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
