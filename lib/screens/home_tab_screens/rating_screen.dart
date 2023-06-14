import 'package:alumni_connect/screens/auth/auth_pages.dart';
import 'package:alumni_connect/services/auth_services.dart';
import 'package:alumni_connect/services/rating_services.dart';
import 'package:alumni_connect/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollegeScreen extends StatelessWidget {
  const CollegeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rating",
          style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w900,
              fontSize: screenSize.width * .055,
              color: Colors.white),
        ),
        backgroundColor: CustomColors.lightAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize.height * 0.3,
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRu3FQM9guMHIkaprYg6oCmpv73cHavgixuqLfAQ0uMiA&usqp=CAU&ec=48665701',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
              child: Text(
                'Ilahia College of Engineering and Technology',
                style: GoogleFonts.nunitoSans(
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Placement Rating: ",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                    )),
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                FutureBuilder(
                  future: RatingServices.calculateRating(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return Text("0.0");
                    }
                    return Text(snapshot.data.toString());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
