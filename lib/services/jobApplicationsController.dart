import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'package:flutter/material.dart';
import 'dart:io'; // Import File class
// Import this package for ChangeNotifier
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';


import '../models/job_model.dart';
import '../models/user.dart';
import '../providers/userprovider.dart';
import '../utils/constants.dart';

class JobApplicationController {
//Job score
  String? dropboxClientId;
  String? dropboxSecret;
  String? cvFilePath;
  String? motivationalLetter;
  double? _fitScore;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController emailController;


  JobApplicationController({
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,

  });
  double? get fitScore => _fitScore;


  void applyForJob(BuildContext context,JobModel job,Function(double fitScore) onSuccess) async {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    String userID = user.id;
    String jobID = job.id;
    List<String> userSkills = user.skills;

    // Create a Map to represent the request data
    Map<String, dynamic> requestData = {
      "user_id": userID,
      "job_id": jobID,
      "skills": userSkills,
    };

    try {
      // Convert requestData to JSON string
      String requestBody = jsonEncode(requestData);

      // Create a Uri object from the URL string
      Uri url = Uri.parse('${Constants.uri}/apply-for-job');

      // Send job application data to the backend
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      // Handle response from the backend
      if (response.statusCode == 200) {
        // Parse fit score from response body
        dynamic responseBody = jsonDecode(response.body);
        double? fitScore =
            double.tryParse(responseBody['fit_score'].toString());
        if (fitScore != null) {
          // Call the success callback with the fit score
          onSuccess(fitScore);
        } else {
          print('Invalid fit score format');
        }
      } else {
        print('Failed to submit job application: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending job application: $e');
    }
  }

  Future<bool> checkAuthorized(bool authorize) async {
    // Check if Dropbox credentials are available
    if (dropboxClientId == null || dropboxSecret == null) {
      print('Dropbox credentials not found.');
      return false;
    }

    return false;
  }

  void saveAsPDF(String coverLetter, BuildContext context) {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(coverLetter),
        );
      },
    ));
  }

  Future<void> postulate(JobModel job, BuildContext context) async {
    try {
      // Get the current user from the provider
      var user = Provider.of<UserProvider>(context, listen: false).user;
      String userID = user.id;

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Prepare the application data
      Map<String, dynamic> applicationData = {
        'idCandidat': userID,
        'idJob': job.id,
        'applicationStatus': 'in progress',
      };
      print(applicationData);


      // Send the POST request with the JSON body
      final response = await http.post(
        Uri.parse('${Constants.uri}/applications'),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token',},
        body: json.encode(applicationData),
      );

      if (response.statusCode == 200) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Application Submitted'),
            content: Text('Your application has been submitted successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // Handle errors
        print('Failed to submit application: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Application Failed'),
            content: Text('Failed to submit application. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error submitting application: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while submitting your application.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }}

}
