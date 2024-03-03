import 'package:ceylon_explorer/misc/colors.dart';
import 'package:ceylon_explorer/widgets/app_button.dart';
import 'package:ceylon_explorer/widgets/app_large_text.dart';
import 'package:ceylon_explorer/widgets/app_text.dart';
import 'package:ceylon_explorer/widgets/responsive_button.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                child: Container(
                  width: double.maxFinite,
                  height: 350,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("img/daladamaligawa.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                )),
            Positioned(
                left:20,
                top:50,
                child: Row(
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.menu),
                  color: Colors.white,),
              ],
            )),
            Positioned(
              top: 320,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 550,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(30)
                    )
                  ),
                  child: Column(
                    //Name
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLargeText(text: "Sri Dalada Maligawa", color: AppColors.textColor1,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      //Location
                      Row(
                        children: [
                          Icon(Icons.location_on, color:AppColors.textColor2,),
                          SizedBox(width: 5,),
                          AppText(text: "Kandy, Sri Lanka", color: AppColors.textColor2,),
                        ],
                      ),
                      SizedBox(height: 20,),
                      //Description
                      Row(
                        children: [
                          AppLargeText(text: "Description", color: AppColors.textColor1,size: 25,),
                        ],
                      ),
                      SizedBox(height: 10,),

                          AppText(text: "The Temple of the Tooth Relic is an important historic and religious site in Sri Lanka. This golden-roofed temple hosts the tooth of the Buddha, an important Buddhist relic.", color: AppColors.textColor2 ),

                    ],
                  ),
                )),
            Positioned(
              bottom: 50,
                left: 30,
                right: 30,
                child: Row(
                  children: [
                    ResponsiveButton(
                      isResponsive: true,

                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
