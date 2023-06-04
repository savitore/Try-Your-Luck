import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect{

  Widget shimmer(Widget child) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: const LinearGradient(
        colors: [
          Colors.white,
          Colors.grey,
          Colors.white,
        ],
        begin: Alignment(-1.0, -0.5), // Set the start point of the gradient
        end: Alignment(2.0, 0.5), // Set the end point of the gradient
      ),
      child: child,
    );
  }

  Widget shimmerListTile(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey,width: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerEffect().shimmer(Container(
                      height: 25,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey))),
                  SizedBox(height: 10,),
                  ShimmerEffect().shimmer(Container(
                      height: 15,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey))),
                  SizedBox(height: 5,),
                  ShimmerEffect().shimmer(Container(
                      height: 15,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey))),
                  SizedBox(height: 15,),
                ],
              ),
            ),
            ShimmerEffect().shimmer(Container(
                height: 15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    color: Colors.grey)
            )),
          ],
        ),
      ),
    );
  }

  Widget shimmerListTileMyContests(){
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey,width: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerEffect().shimmer(Container(
                height: 25,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey))),
            SizedBox(height: 10,),
            ShimmerEffect().shimmer(Container(
                height: 15,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey))),
            SizedBox(height: 5,),
            ShimmerEffect().shimmer(Container(
                height: 15,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey))),
            SizedBox(height: 15,),
            ShimmerEffect().shimmer(Container(
                height: 15,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey)
            )),
          ],
        ),
      ),
    );
  }
}