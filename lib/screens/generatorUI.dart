import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';

class GenerateUI {
  String priceForChart = 'volume';
  var fabTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  GenerateUI() {}

  Widget getIcon(type) {
    String asset = internet;
    switch (type) {
      case "twitter":
        {
          return SvgPicture.asset(
            twitter,
            height: 50,
            width: 50,
          );
        }
        break;

      case "telegram":
        {
          return SvgPicture.asset(
            telegram,
            height: 50,
            width: 50,
          );
        }
        break;
      case "reddit":
        {
          return SvgPicture.asset(
            reddit,
            height: 50,
            width: 50,
          );
        }
        break;
      case "discord":
        {
          return SvgPicture.asset(
            discord,
            height: 50,
            width: 50,
          );
        }
        break;
      case "medium":
        {
          return SvgPicture.asset(
            medium,
            height: 50,
            width: 50,
          );
        }
        break;
      case "youtube":
        {
          return SvgPicture.asset(
            youtube,
            height: 50,
            width: 50,
          );
        }
        break;
      case "github":
        {
          return SvgPicture.asset(
            github,
            height: 50,
            width: 50,
          );
        }
        break;
      case "facebook":
        {
          return SvgPicture.asset(
            facebook,
            height: 50,
            width: 50,
          );
        }
        break;
      default:
        {
          return SvgPicture.asset(
            internet,
            height: 50,
            width: 50,
          );
        }
        break;
    }
  }
}
