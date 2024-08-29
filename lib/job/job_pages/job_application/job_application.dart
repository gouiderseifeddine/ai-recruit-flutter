import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../providers/userprovider.dart';
import '../../../utils/constants.dart';
import '../../job_gloabelclass/job_color.dart';
import '../../job_gloabelclass/job_fontstyle.dart';
import '../../job_gloabelclass/job_icons.dart';
import '../job_theme/job_themecontroller.dart';
import 'job_applicationstages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobApplication extends StatefulWidget {
  const JobApplication({Key? key}) : super(key: key);

  @override
  State<JobApplication> createState() => _JobApplicationState();
}

class _JobApplicationState extends State<JobApplication> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(JobThemecontroler());
  List<dynamic> jobApplications = [];
  String selectedStatus = 'All'; // Default selected status
  int selectedApplicationIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchJobApplications();
  }

  Future<void> fetchJobApplications() async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUserData();
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      final response = await http.get(
        Uri.parse('${Constants.uri}/candidates/${userId}/applications'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> applications = json.decode(response.body) as List<dynamic>;

        setState(() {
          jobApplications = applications;
        });
      } else {
        print('Failed to fetch job applications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching job applications: $e');
    }
  }

  Future<Map<String, dynamic>> fetchJobDetails(String jobId) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.uri}/jobs/$jobId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to fetch job details: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching job details: $e');
      return {};
    }
  }

  Color textcolor = Colors.white;
  Color color = const Color(0xff246BFD);
  String applicationsicon = JobPngimage.google;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset(JobPngimage.logo, height: height / 36),
        ),
        title: Text("Applications".tr, style: urbanistBold.copyWith(fontSize: 22)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              JobPngimage.more,
              height: height / 36,
              color: themedata.isdark ? JobColor.white : JobColor.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
          child: Column(
            children: [
              TextField(
                style: urbanistSemiBold.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintStyle: urbanistRegular.copyWith(fontSize: 16, color: JobColor.textgray),
                  hintText: "Search".tr,
                  fillColor: themedata.isdark ? JobColor.lightblack : JobColor.appgray,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: height / 36,
                    color: JobColor.textgray,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(JobPngimage.filter, height: height / 36),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: JobColor.appcolor),
                  ),
                ),
              ),
              SizedBox(height: height / 36),
              ListView.builder(
                itemCount: jobApplications.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final application = jobApplications[index];
                  final status = application['applicationStatus'];
                  final jobId = application['idJob'];

                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchJobDetails(jobId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final jobDetails = snapshot.data ?? {};
                      final jobTitle = jobDetails['jobTitle'] ?? 'N/A';
                      final location = jobDetails['location'] ?? 'N/A';
                      final statusColor = getStatusColor(status);

                      return InkWell(
                        splashColor: JobColor.transparent,
                        highlightColor: JobColor.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return JobApplicationStages(application: application,job:jobDetails);
                              },
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: height / 13,
                                  width: height / 13,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: themedata.isdark ? JobColor.borderblack : JobColor.bggray,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(applicationsicon, height: height / 36),
                                  ),
                                ),
                                SizedBox(width: width / 26),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width / 1.8,
                                          child: Text(
                                            jobTitle,
                                            style: urbanistSemiBold.copyWith(fontSize: 19),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height / 80),
                                    Text(
                                      location,
                                      style: urbanistMedium.copyWith(fontSize: 16, color: JobColor.textgray),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Icon(Icons.arrow_forward_ios, size: height / 46),
                              ],
                            ),
                            SizedBox(height: height / 80),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height / 20,
                                  width: height / 13,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: JobColor.transparent),
                                  ),
                                ),
                                SizedBox(width: width / 26),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: statusColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width / 36,
                                      vertical: height / 110,
                                    ),
                                    child: Text(
                                      status,
                                      style: urbanistSemiBold.copyWith(fontSize: 10, color: textcolor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "accepted":
        return Colors.green;
      case "refused":
        return Colors.red;
      case "in progress":
        return Colors.orange;
      default:
        return JobColor.lightblue; // Default color
    }
  }
}
