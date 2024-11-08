import 'package:flutter/material.dart';
import '../features/auth/views/forgot_password_view.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/sign_up_view.dart';
import '../features/auth/views/verify_email.dart';
import '../features/community/views/community_home.dart';
import '../features/community/views/community_screen.dart';
import '../features/contact_me/views/volunteers/book_volunteers.dart';
import '../features/contact_me/views/volunteers/volunteers.dart';
import '../features/services/views/services_home.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/community/deligates/search.dart';
import '../features/community/views/create_community.dart';
import '../features/contact_me/views/consellor/book_appointment.dart';
import '../features/contact_me/views/consellor/counsellor.dart';
import '../features/contact_me/views/consellor/my_appointments.dart';
import '../features/contact_me/views/counsellor_home.dart';
import '../features/contact_me/views/ngo/ngo_screen.dart';
import '../features/contact_me/views/volunteers/my_volunteers.dart';
import '../features/dashboard/views/dashboad_home.dart';
import '../features/feed/views/feed/news_and_blog.dart';
import '../features/health/views/appointment_calender_screen.dart';
import '../features/health/views/create_document_view.dart';
import '../features/health/views/document_screen.dart';
import '../features/health/views/prescription_calander.dart';
import '../features/health/views/health_home.dart';
import '../features/health/views/my_documents.dart';
import '../features/health/views/search_document.dart';
import '../features/onboarding/OnboardingPage.dart';
import '../features/reccomendations/view/places.dart';
import '../features/services/views/education/audios/auidos_screen.dart';
import '../features/services/views/education/reading/articles_screen.dart';
import '../features/services/views/education/videos/education_home.dart';
import '../features/services/views/education/videos/education_videos.dart';
import '../features/user/views/edit_user_profile.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: OnboardingWrapper(),
      ),
  '/login': (_) => const MaterialPage(
        child: LoginView(),
      ),
  '/login/register': (route) => const MaterialPage(
        child: SignupView(),
      ),
  '/login/forgot_password': (route) => const MaterialPage(
        child: ForgotPasswordView(),
      ),
  '/login/verify_email': (route) => const MaterialPage(
        child: VerifyEmailScreen(),
      ),
});
final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(
        child: DashboardHomeView(),
      ),

  '/edit-profile': (route) => const MaterialPage(
        child: EditProfileScreen(),
      ),
  '/report-and-recommendation': (_) => MaterialPage(
        child: MyPage(),
      ),
  'report': (_) => MaterialPage(
        child: ReportsPage(),
      ),
  'recommendation': (_) => MaterialPage(
        child: RecommendationsPage(),
      ),
  '/community/create-community': (_) => const MaterialPage(
        child: CreateCommunityScreen(),
      ),

  '/community': (_) => const MaterialPage(
        child: CommunityHome(),
      ),

  '/community/:name': (route) => MaterialPage(
        child: CommunityChatScreen(
          id: route.pathParameters['name']!,
        ),
      ), // dynamic
  '/search-community': (_) => const MaterialPage(
        child: SearchCommunityScreen(),
      ),
  '/health-home': (_) => MaterialPage(
        child: HealthHomeView(),
      ),
  '/health-home/my-documents': (_) => const MaterialPage(
        child: MyDocumentView(),
      ),

  '/health-home/my-documents/document-details/:document': (route) =>
      MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['document']!,
        ),
      ),
  '/health-home/my-documents/create-document': (_) => const MaterialPage(
        child: CreateDocumentScreen(),
      ),
  '/health-home/search-documents': (_) => const MaterialPage(
        child: SearchDocumentScreen(),
      ),
  '/health-home/prescription-calender': (_) => const MaterialPage(
        child: EventCalendarScreen(),
      ),
  '/health-home/appointment-calender': (_) => const MaterialPage(
        child: AppointmentCalendarScreen(),
      ),
  '/counsellor-home': (_) => MaterialPage(
        child: ContactMeHomeView(),
      ),
  '/counsellor-home/all-counsellor': (_) => const MaterialPage(
        child: Counsellor(),
      ),

  '/counsellor-home/my-counsellor-appointments': (_) => const MaterialPage(
        child: MyAppointmentsView(),
      ),

  '/counsellor-home/all-counsellor/counsellor-appointment-book/:id': (route) =>
      MaterialPage(
        child: BookAppointmentScreen(
          id: route.pathParameters['id']!,
        ),
      ),
  '/counsellor-home/all-volunteers': (_) => const MaterialPage(
        child: Volunteers(),
      ),
  '/counsellor-home/my-volunteers-appointments': (_) => const MaterialPage(
        child: MyVolunteersView(),
      ),
  '/counsellor-home/all-volunteers/volunteers-appointment-book/:id': (route) =>
      MaterialPage(
        child: BookVolunteersScreen(
          id: route.pathParameters['id']!,
        ),
      ),
  '/counsellor-home/ngo': (_) => const MaterialPage(
        child: NgoScreen(),
      ),
  '/services': (_) => MaterialPage(
        child: ServicesHomeView(),
      ),
  '/services/education': (_) => MaterialPage(
        child: EducationHomeView(),
      ),
  '/services/education/education-videos': (_) => MaterialPage(
        child: EducationVideoCoursesView(),
      ),
  '/services/education/education-audios': (_) => MaterialPage(
        child: AudioScreen(),
      ),
  '/services/education/education-reading': (_) => const MaterialPage(
        child: ArticlesScreen(),
      ),
  '/feed': (_) => const MaterialPage(
        child: FeedHome(),
      ),
});

class OnboardingWrapper extends StatelessWidget {
  const OnboardingWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return OnBoardingPage(
            onComplete: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isFirstTime', false);
              Routemaster.of(context).replace('/login');
            },
          );
        } else {
          return LoginView();
        }
      },
    );
  }

  Future<bool> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTime') ?? true;
  }
}
