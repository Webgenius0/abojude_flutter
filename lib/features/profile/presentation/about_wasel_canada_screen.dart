import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/terms_of_service_screen/model/terms_and_condition_model.dart';

class AboutWaselCanadaScreen extends StatefulWidget {
  const AboutWaselCanadaScreen({super.key});

  @override
  State<AboutWaselCanadaScreen> createState() => _AboutWaselCanadaScreenState();
}

class _AboutWaselCanadaScreenState extends State<AboutWaselCanadaScreen> {
  @override
  void initState() {
    super.initState();
    aboutPageRxObj.getTermsAndCondition('about-page');
  }

  String _stripHtml(String htmlString) {
    String result = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
    result = result.replaceAll('&nbsp;', ' ');
    result = result.replaceAll('&amp;', '&');
    result = result.replaceAll('&lt;', '<');
    result = result.replaceAll('&gt;', '>');
    result = result.replaceAll('&quot;', '"');
    result = result.replaceAll('&#39;', "'");
    return result.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 70.w,
          leading: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black87,
                  size: 26,
                ),
              ),
            ),
          ),
          title: StreamBuilder<TermsAndConditionModel>(
            stream: aboutPageRxObj.getTermsAndConditionData,
            builder: (context, snapshot) {
              final title = snapshot.data?.data?.title ?? 'About Wasel Canada';
              return Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.black87,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: aboutPageRxObj.isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0F3D7A),
                ),
              );
            }

            return StreamBuilder<TermsAndConditionModel>(
              stream: aboutPageRxObj.getTermsAndConditionData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load about page information.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data?.data == null) {
                  return Center(
                    child: Text(
                      'No data available.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
                    ),
                  );
                }

                final content = snapshot.data!.data!.content ?? '';
                final cleanContent = _stripHtml(content);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo Branding Header box
                      _buildLogoBanner(),

                      SizedBox(height: 24.h),

                      // API content
                      Text(
                        cleanContent,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      
                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 84.h,
        horizontal: 30.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/app_canada_image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
