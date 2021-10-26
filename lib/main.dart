import 'package:bloc/bloc.dart';
import 'package:shop_app_final/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app_final/layout/shop_app/shop_layout.dart';
import 'package:shop_app_final/modules/login/login_screen.dart';
import 'package:shop_app_final/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app_final/shared/cubit/cubit.dart';
import 'package:shop_app_final/shared/cubit/states.dart';
import 'package:shop_app_final/shared/network/end_points.dart';
import 'package:shop_app_final/shared/network/local/cache_helper.dart';
import 'package:shop_app_final/shared/network/remote/dio_helper.dart';
import 'package:shop_app_final/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_final/shared/bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  if (onBoarding != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(
    MyApp(isDark: isDark, startWidget: widget),
  );
}

class MyApp extends StatelessWidget {
  // constructor
  // build
  final bool isDark;
  final Widget startWidget;

  MyApp({this.isDark, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
          AppCubit()..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}

//AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
