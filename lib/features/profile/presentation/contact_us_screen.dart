import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/utils.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/profile/widgets/contact_us_widgets.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _subjectController;
  late TextEditingController _issueController;
  File? _screenshotFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profileEmail =
        getProfileRxObj.getProfileData.valueOrNull?.data?.email;
    _emailController = TextEditingController(
      text: (profileEmail != null && profileEmail.isNotEmpty)
          ? profileEmail
          : "support-wasel-canada@gmail.com",
    );
    _subjectController = TextEditingController();
    _issueController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _pickScreenshot() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _screenshotFile = File(image.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
    }
  }

  void _removeScreenshot() => setState(() => _screenshotFile = null);

  Future<void> _submitSupportRequest() async {
    if (_formKey.currentState!.validate()) {
      final success = await contactSupportRxObj.contactSupportRx(
        email: _emailController.text.trim(),
        describeIssue: _issueController.text.trim(),
        subject: _subjectController.text.trim(),
        attachment: _screenshotFile,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ContactAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ContactHeaderSection(),
                      SizedBox(height: 24.h),
                      const ContactResponseTimeCard(),
                      SizedBox(height: 32.h),
                      const ContactFormTitle(),
                      SizedBox(height: 24.h),
                      const ContactFormLabel(text: 'Your Email Address'),
                      ContactTextField(
                        controller: _emailController,
                        readOnly: true,
                        hintText: 'Enter your email address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Please enter your email';
                          if (!GetUtils.isEmail(value))
                            return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      const ContactFormSubtext(
                        text: "We'll send the response to this email address",
                      ),
                      SizedBox(height: 20.h),
                      const ContactFormLabel(text: 'Subject (Optional)'),
                      ContactTextField(
                        controller: _subjectController,
                        hintText: 'Enter your subject...',
                        icon: Icons.title_rounded,
                      ),
                      SizedBox(height: 20.h),
                      const ContactFormLabel(text: 'Describe Your Issue'),
                      ContactMultiLineField(
                        controller: _issueController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Please describe your issue';
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      const ContactFormLabel(
                        text: 'Attach Screenshot (Optional)',
                      ),
                      ContactAttachmentArea(
                        screenshotFile: _screenshotFile,
                        onPickScreenshot: _pickScreenshot,
                        onRemoveScreenshot: _removeScreenshot,
                      ),
                      SizedBox(height: 16.h),
                      const ContactTipSubtext(),
                      SizedBox(height: 36.h),
                    ],
                  ),
                ),
              ),
            ),
            ContactSubmitButton(onSubmit: _submitSupportRequest),
          ],
        ),
      ),
    );
  }
}
