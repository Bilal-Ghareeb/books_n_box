import 'package:go_router/go_router.dart';
import 'package:mobile_app_project/screens/book_details_screen/book_details_screen.dart';
import 'package:mobile_app_project/screens/main_screens/profile_screen/profile_screen.dart';
import '../business_logic/cubit/auth_cubit/auth_cubit.dart';
import '../data/repository/auth_repository.dart';
import '../screens/auth_screens/login/login_screen.dart';
import '../screens/home_screen/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../business_logic/cubit/auth_cubit/auth_cubit.dart';
/// To navigate use
/// onTap: () => GoRouter.of(context).go('/page_path')
/// OR
/// onTap: () => context.go('/page_path')
class AppRouter {
  final GoRouter router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider(
              create: (context)=>AuthCubit(authRepository: context.read<AuthRepository>()),
              child: const LoginScreen(),
            ),
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
          GoRoute(
            path: '/book_details',
            builder: (context, state) => const BookDetailsScreen(),
          )
        ],
      // errorBuilder: (context, state) => ErrorScreen(state.error),
    );
}

