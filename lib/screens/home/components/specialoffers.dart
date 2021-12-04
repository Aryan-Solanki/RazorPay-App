import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:orev/constants.dart';
import 'package:orev/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  int _dataLength = 1;

  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }

  Future getSliderImageFromDb() async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore.collection('slider').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                if (_dataLength != 0)
                  FutureBuilder(
                    future: getSliderImageFromDb(),
                    builder: (_, snapShot) {
                      return snapShot.data == null
                          ? Center(
                        child: LoadingSkeleton(
                          width: MediaQuery.of(context).size.width,
                          height: getProportionateScreenHeight(400),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CarouselSlider.builder(
                            itemCount: snapShot.data.length,
                            itemBuilder: (context, int index) {
                              DocumentSnapshot sliderImage =
                              snapShot.data[index];
                              Map getImage = sliderImage.data();
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: getImage["image"],
                                    placeholder: (context, url) =>
                                    new LoadingSkeleton(
                                      width: MediaQuery.of(context).size.width,
                                      height: getProportionateScreenHeight(400),
                                    ),
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                  )
                              );
                            },
                            options: CarouselOptions(
                                viewportFraction: 1,
                                initialPage: 0,
                                autoPlay: true,
                                height: getProportionateScreenHeight(400),
                                onPageChanged:
                                    (int i, carouselPageChangedReason) {
                                  setState(() {
                                    _index = i;
                                  });
                                })),
                      );
                    },
                  ),
                if (_dataLength != 0)
                  DotsIndicator(
                    dotsCount: _dataLength,
                    position: _index.toDouble(),
                    decorator: DotsDecorator(
                        size: const Size.square(5.0),
                        activeSize: const Size(18.0, 5.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        activeColor: kPrimaryColor),
                  )
              ],
            ),
          );
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                if (_dataLength != 0)
                  FutureBuilder(
                    future: getSliderImageFromDb(),
                    builder: (_, snapShot) {
                      return snapShot.data == null
                          ? Center(
                        child: LoadingSkeleton(
                          width: MediaQuery.of(context).size.width,
                          height: getProportionateScreenHeight(250),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CarouselSlider.builder(
                            itemCount: snapShot.data.length,
                            itemBuilder: (context, int index) {
                              DocumentSnapshot sliderImage =
                              snapShot.data[index];
                              Map getImage = sliderImage.data();
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: getImage["image"],
                                    placeholder: (context, url) =>
                                    new LoadingSkeleton(
                                      width: MediaQuery.of(context).size.width,
                                      height: getProportionateScreenHeight(250),
                                    ),
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                  )
                              );
                            },
                            options: CarouselOptions(
                                viewportFraction: 1,
                                initialPage: 0,
                                autoPlay: true,
                                height: getProportionateScreenHeight(250),
                                onPageChanged:
                                    (int i, carouselPageChangedReason) {
                                  setState(() {
                                    _index = i;
                                  });
                                })),
                      );
                    },
                  ),
                if (_dataLength != 0)
                  DotsIndicator(
                    dotsCount: _dataLength,
                    position: _index.toDouble(),
                    decorator: DotsDecorator(
                        size: const Size.square(5.0),
                        activeSize: const Size(18.0, 5.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        activeColor: kPrimaryColor),
                  )
              ],
            ),
          );
        }

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              if (_dataLength != 0)
                FutureBuilder(
                  future: getSliderImageFromDb(),
                  builder: (_, snapShot) {
                    return snapShot.data == null
                        ? Center(
                      child: LoadingSkeleton(
                        width: MediaQuery.of(context).size.width,
                        height: getProportionateScreenHeight(150),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CarouselSlider.builder(
                          itemCount: snapShot.data.length,
                          itemBuilder: (context, int index) {
                            DocumentSnapshot sliderImage =
                            snapShot.data[index];
                            Map getImage = sliderImage.data();
                            return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: getImage["image"],
                                  placeholder: (context, url) =>
                                  new LoadingSkeleton(
                                    width: MediaQuery.of(context).size.width,
                                    height: getProportionateScreenHeight(150),
                                  ),
                                  errorWidget: (context, url, error) => new Icon(Icons.error),
                                )
                            );
                          },
                          options: CarouselOptions(
                              viewportFraction: 1,
                              initialPage: 0,
                              autoPlay: true,
                              height: getProportionateScreenHeight(150),
                              onPageChanged:
                                  (int i, carouselPageChangedReason) {
                                setState(() {
                                  _index = i;
                                });
                              })),
                    );
                  },
                ),
              if (_dataLength != 0)
                DotsIndicator(
                  dotsCount: _dataLength,
                  position: _index.toDouble(),
                  decorator: DotsDecorator(
                      size: const Size.square(5.0),
                      activeSize: const Size(18.0, 5.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      activeColor: kPrimaryColor),
                )
            ],
          ),
        );
      },
    );
  }
}

//restart app
