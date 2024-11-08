import 'package:flutter/material.dart';

import 'home_screen_blogs.dart';

class WelcomeScreenBlog extends StatelessWidget {
  const WelcomeScreenBlog ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/welcome_blog.jpg')
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.6),
                      Colors.black.withOpacity(.3)
                    ]
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Discover Stories\nand mindful thinking', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    width: 200,
                    child: const Text(
                      "Illuminating the Human Experience Through Empathy and Understanding.",
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    )
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreenBlog ()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      backgroundColor: Colors.lightBlueAccent,
                  ),
                  child: const Text(
                    'Ready to Embark!',
                    style: TextStyle(
                      color: Colors.white, // Set your desired text color
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}