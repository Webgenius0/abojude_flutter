import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/terms_of_service_screen/model/terms_and_condition_model.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final String slug;
  const PrivacyPolicyScreen({super.key, this.slug = 'privacy-policy'});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    privacyPolicyRxObj.getTermsAndCondition(widget.slug);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Bottom border under the app bar matching the screenshot line
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade100, height: 1.0),
        ),
        leadingWidth: 72,
        leading: Padding(
          padding:
              const Size.fromHeight(kToolbarHeight) > const Size.fromHeight(0)
              ? const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0)
              : EdgeInsets.zero,
          child: Transform.scale(
            scale: 0.9,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 10.sp,
                  color: Colors.black87,
                ),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        title: StreamBuilder<TermsAndConditionModel>(
          stream: privacyPolicyRxObj.getTermsAndConditionData,
          builder: (context, snapshot) {
            final title = snapshot.data?.data?.title ?? 'Privacy Policy';
            return Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        centerTitle: false,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: privacyPolicyRxObj.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0F3D7A)),
            );
          }

          return StreamBuilder<TermsAndConditionModel>(
            stream: privacyPolicyRxObj.getTermsAndConditionData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load privacy policy.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.sp,
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data?.data == null) {
                return Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.sp,
                    ),
                  ),
                );
              }

              final content = snapshot.data!.data!.content ?? '';
              final cleanContent = _stripHtml(content);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cleanContent,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
