import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/cubit/localization_cubit/cubit/localization_cubit.dart';
import 'app_title.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.menu,
              color: Theme.of(context).textTheme.bodyMedium?.color, size: 20),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        AppTitle(),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
            BlocProvider.of<LocalizationCubit>(context).switchLanguage();
          },
          child: Text(
            lang == 'en' ? 'Ar' : 'En',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
