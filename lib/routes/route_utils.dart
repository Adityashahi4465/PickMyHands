import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class Navigation {
  static void navigateToBack(BuildContext context) {
    Routemaster.of(context).pop();
  }

  static void navigateToRegister(BuildContext context) {
    Routemaster.of(context).push('/login/register');
  }

  static void navigateToVerifyEmail(BuildContext context) {
    Routemaster.of(context).push('/login/verify-email');
  }

  static void navigateToForGotPassword(BuildContext context) {
    Routemaster.of(context).push('/login/forgot_password');
  }

  static void navigateToHome(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  static void navigateToReportandRecommendation(BuildContext context) {
    Routemaster.of(context).push('/report-and-recommendation');
  }

  static void navigateToReport(BuildContext context) {
    Routemaster.of(context).push('/report');
  }

  static void navigateToRecommendation(BuildContext context) {
    Routemaster.of(context).push('/recommendation');
  }

  static void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-profile');
  }

  static void navigateCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/community/create-community');
  }

  static void navigateCommunityHome(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/community');
  }

  static void navigateCommunity(BuildContext context, String id) {
    Routemaster.of(context).push('/community/$id');
  }

  static void navigateSearchCommunity(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/search-community');
  }

  static void navigateHealthHome(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/health-home');
  }

  static void navigateMyDocument(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/health-home/my-documents');
  }

  static void navigateCreateDocument(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/health-home/my-documents/create-document');
  }

  static void navigateDocument(
    BuildContext context,
    String id,
  ) {
    Routemaster.of(context)
        .push('/health-home/my-documents/document-details/$id');
  }

  static void navigateSearchDocument(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/health-home/search-documents');
  }

  static void navigateToPrescriptionCalender(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/health-home/prescription-calender');
  }

  static void navigateToAppointmentCalender(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/health-home/appointment-calender');
  }

  static void navigateToCounsellorHome(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/counsellor-home');
  }

  static void navigateToCounsellor(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/counsellor-home/all-counsellor');
  }

  static void navigateToMyCounsellorAppointments(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/counsellor-home/my-counsellor-appointments');
  }

  static void navigateToCounsellorAppointmentBook(
    BuildContext context,
    String id,
  ) {
    Routemaster.of(context).push(
        '/counsellor-home/all-counsellor/counsellor-appointment-book/$id');
  }

  static void navigateToVolunteer(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/counsellor-home/all-volunteers');
  }

  static void navigateToMyVolunteerAppointments(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/counsellor-home/my-volunteers-appointments');
  }

  static void navigateToVolunteerAppointmentBook(
    BuildContext context,
    String id,
  ) {
    Routemaster.of(context).push(
        '/counsellor-home/all-volunteers/volunteers-appointment-book/$id');
  }

  static void navigateToNgo(BuildContext context) {
    Routemaster.of(context).push('/counsellor-home/ngo');
  }

  static void navigateToServices(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/services');
  }

  static void navigateToEducation(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/services/education');
  }

  static void navigateToEducationVideos(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/services/education/education-videos');
  }

  static void navigateToEducationAudios(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/services/education/education-audios');
  }

  static void navigateToEducationReading(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/services/education/education-reading');
  }

  static void navigateToFeed(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/feed');
  }
}
