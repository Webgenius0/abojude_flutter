import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'business_listing_model.dart';

class GroupedHours {
  final List<String> days;
  final bool isOpen;
  final String openingTime;
  final String closingTime;

  GroupedHours({
    required this.days,
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
  });

  String get dayRangeText {
    if (days.length == 1) {
      return days.first;
    } else if (days.length == 2) {
      return "${days.first} & ${days.last}";
    } else {
      return "${days.first} – ${days.last}";
    }
  }

  String get timeText {
    if (!isOpen) return "Closed";
    return "$openingTime – $closingTime";
  }
}

class BusinessHoursCard extends StatefulWidget {
  final Map<String, BusinessDayHours> businessHours;

  const BusinessHoursCard({super.key, required this.businessHours});

  @override
  State<BusinessHoursCard> createState() => _BusinessHoursCardState();
}

class _BusinessHoursCardState extends State<BusinessHoursCard> {
  bool _isHoursExpanded = true;

  List<GroupedHours> _getGroupedHours() {
    final List<GroupedHours> groups = [];
    final List<String> weekOrder = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    int i = 0;
    while (i < weekOrder.length) {
      final startDay = weekOrder[i];
      final startHours = widget.businessHours[startDay];
      if (startHours == null) {
        i++;
        continue;
      }

      final List<String> currentGroupDays = [startDay];

      int j = i + 1;
      while (j < weekOrder.length) {
        final nextDay = weekOrder[j];
        final nextHours = widget.businessHours[nextDay];
        if (nextHours != null &&
            nextHours.isOpen == startHours.isOpen &&
            nextHours.openingTime == startHours.openingTime &&
            nextHours.closingTime == startHours.closingTime) {
          currentGroupDays.add(nextDay);
          j++;
        } else {
          break;
        }
      }

      groups.add(
        GroupedHours(
          days: currentGroupDays,
          isOpen: startHours.isOpen,
          openingTime: startHours.openingTime,
          closingTime: startHours.closingTime,
        ),
      );

      i = j;
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isHoursExpanded = !_isHoursExpanded;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Business Hours",
                style: TextFontStyle.textStyle15IbmPlexSansW600,
              ),
              Icon(
                _isHoursExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF6B7280),
                size: 20.w,
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        if (_isHoursExpanded)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: _getGroupedHours().map((g) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        g.dayRangeText,
                        style: TextFontStyle.textStyle13IbmPlexSansW500DarkGrey,
                      ),
                      Text(
                        g.timeText,
                        style: g.isOpen
                            ? TextFontStyle.textStyle13IbmPlexSansW600Green
                            : TextFontStyle.textStyle13IbmPlexSansW600LightGrey,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
