import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/profile/model/block_user_list_model.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  List<Datum>? _blockedUsers;

  @override
  void initState() {
    super.initState();
    _fetchBlockedUsers();
  }

  void _fetchBlockedUsers() {
    blockUserListRxObj
        .getBlockUserList()
        .then((data) {
          if (mounted) {
            setState(() {
              _blockedUsers = List<Datum>.from(data.data ?? []);
            });
          }
        })
        .catchError((_) {
          if (mounted) {
            setState(() {
              _blockedUsers = [];
            });
          }
        });
  }

  void _unblockUser(Datum user) {
    setState(() {
      _blockedUsers?.removeWhere((u) => u.id == user.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.name ?? "User"} has been unblocked.'),
        backgroundColor: const Color(0xFF2B8A3E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showOptionsBottomSheet(Datum user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
                title: Text(
                  'Unblock ${user.name ?? "User"}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _unblockUser(user);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
                title: Text(
                  'Cancel',
                  style: GoogleFonts.inter(color: Colors.black54),
                ),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
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
                  border: Border.all(
                    color: const Color(0xFFF1F3F5),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black87,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              // Title
              Text(
                'Blocked Users',
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              // Description
              Text(
                'Manage blocked profiles, privacy restrictions, and connection safety settings.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 28.h),

              // Blocked list
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: blockUserListRxObj.isLoading,
                  builder: (context, isLoading, child) {
                    if (isLoading && _blockedUsers == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0F3D7A),
                        ),
                      );
                    }

                    final users = _blockedUsers ?? [];
                    if (users.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _buildBlockedUserCard(user);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockedUserCard(Datum user) {
    final name = user.name ?? 'User';
    final initials = _getInitials(name);
    final blockedTime = user.timeAgo ?? 'Blocked recently';

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Initials Avatar
          CircleAvatar(
            radius: 24.r,
            backgroundColor: const Color(0xFFE9ECEF),
            backgroundImage:
                (user.avatar != null && user.avatar.toString().isNotEmpty)
                ? NetworkImage(user.avatar.toString())
                : null,
            child: (user.avatar != null && user.avatar.toString().isNotEmpty)
                ? null
                : Text(
                    initials,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F3D7A),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
          ),
          SizedBox(width: 14.w),

          // Name & Block info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  blockedTime,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Option Dots Button
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black87, size: 22.sp),
            onPressed: () => _showOptionsBottomSheet(user),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 64.sp,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16.h),
          Text(
            'No Blocked Users',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Profiles you block will appear here.',
            style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
