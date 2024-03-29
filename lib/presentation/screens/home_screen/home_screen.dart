import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_project/presentation/screens/home_screen/widgets/shelf_column.dart';
import '../../../business_logic/cubit/auth_cubit/auth_cubit.dart';
import '../../../business_logic/cubit/google_books_cubit/google_books_cubit.dart';
import '../../../business_logic/cubit/nyt_best_sellers_cubit/nyt_best_sellers_cubit.dart';
import '../../../data/repository/auth_repository.dart';
import 'widgets/app_header.dart';
import 'widgets/best_sellers_carousel.dart';
import 'widgets/best_sellers_title.dart';
import 'widgets/books_tab_view.dart';
import 'widgets/home_catigories_titles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NytBestSellersCubit>(context).getNytBestSellerBooks();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: BlocProvider(
          create: (context) => AuthCubit(authRepository: context.read<AuthRepository>()),
          child: const ShelfColumn(), //
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: ()=>context.go('/home/takePicture'),
      ),
        backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
            child: Column(
          children: [
            AppHeader(),
            HomeCatigoriesTitles(tabcontroller: _tabController),
            BlocProvider(
              create: (context) => GoogleBooksCubit()..genreBookresults(),
              child: BooksTabsView(tabController: _tabController),
            ),
            BestSellersTitle(),
            BestSellersCarousel(),
          ],
        )),
    );
  }
}
