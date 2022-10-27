import 'package:go_router/go_router.dart';
import 'package:mobile_app_project/screens/main_screens/home_screen/home_screen.dart';
import 'package:mobile_app_project/screens/main_screens/profile_screen/profile_screen.dart';
import '../screens/auth_screens/login_screen.dart';
import '../screens/auth_screens/register_screen.dart';
/// To navigate use
/// onTap: () => GoRouter.of(context).go('/page_path')
/// OR
/// onTap: () => context.go('/page_path')
class AppRouter {
  final GoRouter router = GoRouter(
       initialLocation:"/home" ,

        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const  LoginScreen(),
          ),

           GoRoute(
            
             path: '/home',
             builder: (context, state) => const HomeScreen(),
             routes: [

              GoRoute(
                path: 'profile',
                builder: (context, state) => const ProfileScreen(),
              )

             ]
           ),

          
        ],
      // errorBuilder: (context, state) => ErrorScreen(state.error),
    );
}

