import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/core_widgets/my_tab_bar_view.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/tab_bar_item.dart';
import 'package:seasons/features/programs_view/data/models/city_model.dart';
import 'package:seasons/features/programs_view/data/models/country_model.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_states.dart';
import 'package:seasons/features/programs_view/presentation/views/programs_list_view.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'adult_number_view.dart';

class ProgramsView extends StatefulWidget {
  const ProgramsView({Key? key}) : super(key: key);

  @override
  State<ProgramsView> createState() => _ProgramsViewState();
}

class _ProgramsViewState extends State<ProgramsView> {
  DateTime? startDate;

  CountryModel? country;

  ProgrammeCityModel? city;

  bool includeFlights = true;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BasicView2(
      scaffoldKey: scaffoldKey,
        appbarTitle: TranslationKeyManager.tourismTitle.tr,
        button: BlocConsumer<ProgramsCubit, ProgramsStates>(
            listener: (context, state)
            {
              if(state is ProgramsGetErrorState)
              {
                callMySnackBar(context: context, text: state.error);
              }
              if(state is ProgramsFilterGetSuccessState )
              {
                Get.to(()=>ProgramsListView(noDataMatch: false,));
              }
              if(state is ProgramsFilterSuccessNoDataState)
              {
                Get.to(()=>ProgramsListView(noDataMatch: true,));
              }
            },
            builder: (context, state) {
              if (state is ProgramsFilterGetLoadingState)
                return Center(child: CircularProgressIndicator(),);
              else {
                return SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: (city == null || startDate == null)
                        ? null
                        :
                        () {
                      ProgramsCubit.get(context).filter(
                          city: city!.id.toString(),
                          fromDate: startDate!,
                          includeFlight: includeFlights?1:0);

                      // ProgramsCubit.get(context).filter(
                      //     city: "55",
                      //     fromDate: "2023-08-25",
                      //     includeFlight: 1);
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color:  (city == null || startDate == null) ?
                      Colors.grey :
                      ColorsManager.primaryColor,

                          borderRadius: BorderRadius.circular(0)
                      ),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          CacheData.lang == CacheHelperKeys.keyEN ?
                          'Search Programs' :
                          'ابحث عن برامج',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
        children:
        [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color:ColorsManager.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyTabBarView(
                    length: 2,
                    onTab: (index) {
                      if (index == 0) {
                        includeFlights = true;
                      } else {
                        includeFlights = false;
                      }
                      setState(() {});
                    },
                    tabs: [
                      TabBarItem(selected: includeFlights,label: TranslationKeyManager.includeFlight.tr.toUpperCase()),
                      TabBarItem(selected: !includeFlights,label: TranslationKeyManager.notIncludeFlight.tr.toUpperCase()),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Column(
                  children: [
                    InkWell(
                        onTap: ()
                        {
                          scaffoldKey.currentState!.showBottomSheet(
                              backgroundColor: Colors.transparent, (context) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.65,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      )),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        TranslationKeyManager.countries.tr,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      BlocConsumer<ProgramsCubit, ProgramsStates>(
                                          listener: (context, state) {},
                                          builder: (context, state) {
                                            if (state is CountriesGetLoadingState)
                                            {
                                              return Center(
                                                  child:
                                                  CircularProgressIndicator());
                                            }
                                            else if (state is CountriesGetErrorState)
                                            {
                                              return Center(
                                                  child: Text(state.error));
                                            }
                                            else if (ProgramsCubit.get(context).countries.isEmpty)
                                            {
                                              return Center(
                                                  child: Text(
                                                      TranslationKeyManager.serverError.tr));
                                            }
                                            else
                                            {
                                              return Expanded(
                                                child: ListView.builder(
                                                    itemCount:
                                                    ProgramsCubit.get(context)
                                                        .countries
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) => Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical:
                                                              5.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              country = ProgramsCubit
                                                                  .get(
                                                                  context)
                                                                  .countries[index];
                                                              city = null;
                                                              setState(
                                                                      () {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    50,
                                                                    width:
                                                                    50,
                                                                    child: CachedNetworkImage(
                                                                        placeholder: (context, error) => const Icon(
                                                                          Icons.image_outlined,
                                                                          color: Colors.grey,
                                                                        ),
                                                                        fit: BoxFit.fill,
                                                                        errorWidget: (context, url, error) => const Icon(
                                                                          Icons.image_outlined,
                                                                          color: Colors.grey,
                                                                        ),
                                                                        imageUrl: 'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}'),
                                                                    // Image.network(
                                                                    //   'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}',
                                                                    //   fit: BoxFit
                                                                    //       .fill,),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      CacheData.lang == CacheHelperKeys.keyEN?
                                                                      ProgramsCubit.get(context).countries[index].nameEn!:
                                                                      ProgramsCubit.get(context).countries[index].name!,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: ColorsManager.primaryColor),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              50.0),
                                                          child: Divider(),
                                                        )
                                                      ],
                                                    )),
                                              );
                                            }
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                        },
                        child: DefaultField(
                            horizontalPadding: 20,
                            prefix:  Padding(
                              padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                              child: FaIcon(
                                FontAwesomeIcons.flag,
                                color: ColorsManager.iconColor,
                                size: 20,
                              ),
                            ),
                            enabled: false,
                            hint: TranslationKeyManager.country.tr,
                            controller: TextEditingController(
                                text: country != null ?
                                CacheData.lang == CacheHelperKeys.keyEN ?
                                country!.nameEn! :
                                country!.name! :
                                ''
                            ))),
                    SizedBox(height: 15,),
                    InkWell(
                        onTap: ()
                        {
                          scaffoldKey.currentState!.showBottomSheet(
                              backgroundColor: Colors.transparent, (context) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.65,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      )),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        TranslationKeyManager.cities.tr,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      BlocConsumer<ProgramsCubit, ProgramsStates>(
                                          listener: (context, state) {},
                                          builder: (context, state) {
                                            if (country == null) {
                                              return Center(
                                                  child: Text(
                                                      TranslationKeyManager.chooseCountry.tr));
                                            } else if (state
                                            is CitiesGetLoadingState) {
                                              return Center(
                                                  child:
                                                  CircularProgressIndicator());
                                            } else if (state
                                            is CitiesGetErrorState) {
                                              return Center(
                                                  child: Text(state.error));
                                            } else if (country!.cities.isEmpty) {
                                              return Center(
                                                  child: Text(
                                                      TranslationKeyManager.noCities.tr));
                                            } else {
                                              return Expanded(
                                                child: ListView.builder(
                                                    itemCount:
                                                    country!.cities.length,
                                                    itemBuilder:
                                                        (context, index) => Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical:
                                                              5.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              city = country!
                                                                  .cities[
                                                              index];
                                                              setState(
                                                                      () {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
                                                                  child:
                                                                  Container(
                                                                    height:
                                                                    50,
                                                                    width:
                                                                    50,
                                                                    child:
                                                                    CachedNetworkImage(
                                                                      imageUrl:
                                                                      'https://api.seasonsge.com/images/Agents/${country!.cities[index].img!}',
                                                                      placeholder: (context, error) =>
                                                                      const Icon(
                                                                        Icons.image_outlined,
                                                                        color:
                                                                        Colors.grey,
                                                                      ),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      errorWidget: (context, url, error) =>
                                                                      const Icon(
                                                                        Icons.image_outlined,
                                                                        color:
                                                                        Colors.grey,
                                                                      ),
                                                                    ),
                                                                    // Image.network(
                                                                    //   'https://api.seasonsge.com/images/Agents/${country!.cities[index].img!}',
                                                                    //   fit: BoxFit
                                                                    //       .fill,),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      CacheData.lang == CacheHelperKeys.keyEN?
                                                                      country!.cities[index].nameEn!:
                                                                      country!.cities[index].name!,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: ColorsManager.primaryColor),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              50.0),
                                                          child: Divider(),
                                                        )
                                                      ],
                                                    )),
                                              );
                                            }
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                        },
                        child: DefaultField(
                            horizontalPadding: 20,
                            prefix:  Padding(
                              padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                              child: FaIcon(
                                FontAwesomeIcons.city,
                                color: ColorsManager.iconColor,
                                size: 20,
                              ),
                            ),
                            enabled: false,
                            hint: TranslationKeyManager.city.tr,
                            controller: TextEditingController(
                                text: city != null ?
                                CacheData.lang == CacheHelperKeys.keyEN ?
                                city!.nameEn! :
                                city!.name! :
                                ''
                            ))),
                    SizedBox(height: 15,),
                    InkWell(
                        onTap: ()
                        {
                          DateTime? start;
                          Get.to(
                                () => Scaffold(
                              appBar: defaultAppBar(
                                  context: context, text: TranslationKeyManager.tourismTitle.tr),
                              body: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SfDateRangePicker(
                                      todayHighlightColor:
                                      ColorsManager.primaryColor,
                                      toggleDaySelection: true,
                                      startRangeSelectionColor:
                                      ColorsManager.primaryColor,
                                      endRangeSelectionColor:
                                      ColorsManager.primaryColor,
                                      rangeSelectionColor: ColorsManager.primaryColor.withOpacity(0.3),
                                      showActionButtons: true,
                                      view: DateRangePickerView.month,
                                      enablePastDates: false,
                                      selectionMode:
                                      DateRangePickerSelectionMode.single,
                                      showTodayButton: true,
                                      onSubmit: (object) {
                                        if (start == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Please Choose Your Date')));
                                        } else {
                                          startDate = start;
                                          setState(() {});
                                          Navigator.pop(context);
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      monthCellStyle: DateRangePickerMonthCellStyle(
                                          specialDatesDecoration: BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle
                                          ),
                                          specialDatesTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.white
                                          ),
                                          todayTextStyle: TextStyle(color: ColorsManager.primaryColor)),
                                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                        if (args.value != null)
                                          start = args.value;
                                        else
                                          start = null;
                                      },
                                      monthViewSettings: DateRangePickerMonthViewSettings(specialDates: ProgramsCubit.get(context).specialDates)
                                      ),
                                ),
                              ),
                            ),
                            // transition: Transition.downToUp,
                            // duration: Duration(seconds: 1)
                          );
                        },
                        child: DefaultField(
                            horizontalPadding: 20,
                            prefix:  Padding(
                              padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                              child: FaIcon(
                                FontAwesomeIcons.calendarDays,
                                color: ColorsManager.iconColor,
                                size: 20,
                              ),
                            ),
                            enabled: false,
                            hint: CacheData.lang == CacheHelperKeys.keyEN ?
                            'When ?':'متي ؟',
                            controller: TextEditingController(
                                text: startDate !=null ?
                                DateFormat('dd/MM/yyyy').format(startDate!) :
                                ''
                            ))),
                    SizedBox(height: 15,),
                    BlocConsumer<ProgramsCubit, ProgramsStates>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          int rooms = ProgramsCubit.get(context).roomsData.length;
                          int kidsWithBed = 0;
                          int kidsWithoutBed = 0;
                          int infants = 0;
                          int adults = 0;
                          ProgramsCubit.get(context).roomsData.forEach((element) {
                            adults += element.adults;
                            kidsWithBed += element.kidsWithBed;
                            kidsWithoutBed += element.kidsWithNoBed;
                            infants += element.infants;
                          });
                          return InkWell(
                              onTap: ()
                              {
                                Get.to(
                                      () => AdultNumberView(
                                      roomsData:
                                      ProgramsCubit.get(context).roomsData),
                                );
                              },
                              child: DefaultField(
                                  horizontalPadding: 20,
                                  prefix:  Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                                    child: FaIcon(
                                      FontAwesomeIcons.users,
                                      color: ColorsManager.iconColor,
                                      size: 20,
                                    ),
                                  ),
                                  enabled: false,
                                  hint: CacheData.lang == CacheHelperKeys.keyEN ?
                                  'Passengers ?':'المسافرون',
                                  controller: TextEditingController(
                                      text: CacheData.lang == CacheHelperKeys.keyEN?
                                      '$rooms ${'rooms'}, ${adults} adults, ${kidsWithoutBed+kidsWithBed} Children, $infants Infants':
                                      '$rooms ${'غرفة'}, ${adults} بالغ, ${kidsWithoutBed+kidsWithBed} طفل, $infants رضيع ',
                                  )));
                        }),

                    SizedBox(
                      height: 25,
                    ),


                  ],
                ),
              ],
            ),
          )
        ]
    );
  }
}

/*
 Scaffold(
      key: scaffoldKey,
      appBar: defaultAppBar(
          context: context, text: TranslationKeyManager.tourismTitle.tr, elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ColorsManager.primaryColor,
              child: MyTabBarView(
                length: 2,
                onTab: (index) {
                  if (index == 0) {
                    includeFlights = true;
                  } else {
                    includeFlights = false;
                  }
                  setState(() {});
                },
                tabs: [
                  TabBarItem(label: TranslationKeyManager.includeFlight.tr.toUpperCase()),
                  TabBarItem(label: TranslationKeyManager.notIncludeFlight.tr.toUpperCase()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      scaffoldKey.currentState!.showBottomSheet(
                          backgroundColor: Colors.transparent, (context) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    TranslationKeyManager.countries.tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BlocConsumer<ProgramsCubit, ProgramsStates>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        if (state is CountriesGetLoadingState)
                                        {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        else if (state is CountriesGetErrorState)
                                        {
                                          return Center(
                                              child: Text(state.error));
                                        }
                                        else if (ProgramsCubit.get(context).countries.isEmpty)
                                        {
                                          return Center(
                                              child: Text(
                                                  TranslationKeyManager.serverError.tr));
                                        }
                                        else
                                        {
                                          return Expanded(
                                            child: ListView.builder(
                                                itemCount:
                                                    ProgramsCubit.get(context)
                                                        .countries
                                                        .length,
                                                itemBuilder:
                                                    (context, index) => Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  country = ProgramsCubit
                                                                          .get(
                                                                              context)
                                                                      .countries[index];
                                                                  city = null;
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                        child: CachedNetworkImage(
                                                                            placeholder: (context, error) => const Icon(
                                                                                  Icons.image_outlined,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                            fit: BoxFit.fill,
                                                                            errorWidget: (context, url, error) => const Icon(
                                                                                  Icons.image_outlined,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                            imageUrl: 'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}'),
                                                                        // Image.network(
                                                                        //   'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}',
                                                                        //   fit: BoxFit
                                                                        //       .fill,),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                    CacheData.lang == CacheHelperKeys.keyEN?
                                                                          ProgramsCubit.get(context).countries[index].nameEn!:
                                                                          ProgramsCubit.get(context).countries[index].name!,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorsManager.primaryColor),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      50.0),
                                                              child: Divider(),
                                                            )
                                                          ],
                                                        )),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: ColorsManager.iconColor,
                          )),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_circle,
                            color: ColorsManager.iconColor,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            country != null ? CacheData.lang == CacheHelperKeys.keyEN?country!.nameEn!:country!.name!: TranslationKeyManager.country.tr,
                            style: TextStyle(
                              color: country != null
                                  ? Colors.black
                                  : ColorsManager.iconColor,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      scaffoldKey.currentState!.showBottomSheet(
                          backgroundColor: Colors.transparent, (context) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    TranslationKeyManager.cities.tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BlocConsumer<ProgramsCubit, ProgramsStates>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        if (country == null) {
                                          return Center(
                                              child: Text(
                                                  TranslationKeyManager.chooseCountry.tr));
                                        } else if (state
                                            is CitiesGetLoadingState) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state
                                            is CitiesGetErrorState) {
                                          return Center(
                                              child: Text(state.error));
                                        } else if (country!.cities.isEmpty) {
                                          return Center(
                                              child: Text(
                                                  TranslationKeyManager.noCities.tr));
                                        } else {
                                          return Expanded(
                                            child: ListView.builder(
                                                itemCount:
                                                    country!.cities.length,
                                                itemBuilder:
                                                    (context, index) => Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  city = country!
                                                                          .cities[
                                                                      index];
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              'https://api.seasonsge.com/images/Agents/${country!.cities[index].img!}',
                                                                          placeholder: (context, error) =>
                                                                              const Icon(
                                                                            Icons.image_outlined,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          errorWidget: (context, url, error) =>
                                                                              const Icon(
                                                                            Icons.image_outlined,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        // Image.network(
                                                                        //   'https://api.seasonsge.com/images/Agents/${country!.cities[index].img!}',
                                                                        //   fit: BoxFit
                                                                        //       .fill,),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          CacheData.lang == CacheHelperKeys.keyEN?
                                                                          country!.cities[index].nameEn!:
                                                                          country!.cities[index].name!,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: ColorsManager.primaryColor),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      50.0),
                                                              child: Divider(),
                                                            )
                                                          ],
                                                        )),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: ColorsManager.iconColor,
                          )),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: ColorsManager.iconColor,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            city != null ? CacheData.lang == CacheHelperKeys.keyEN?city!.nameEn!:city!.name! : TranslationKeyManager.city.tr,
                            style: TextStyle(
                              color: city != null
                                  ? Colors.black
                                  : ColorsManager.iconColor,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      String? start;
                      Get.to(
                        () => Scaffold(
                          appBar: defaultAppBar(
                              context: context, text: TranslationKeyManager.tourismTitle.tr),
                          body: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SfDateRangePicker(
                                  todayHighlightColor:
                                      ColorsManager.primaryColor,
                                  toggleDaySelection: true,
                                  startRangeSelectionColor:
                                      ColorsManager.primaryColor,
                                  endRangeSelectionColor:
                                      ColorsManager.primaryColor,
                                  rangeSelectionColor: ColorsManager
                                      .primaryColor
                                      .withOpacity(0.3),
                                  showActionButtons: true,
                                  view: DateRangePickerView.month,
                                  enablePastDates: false,
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  showTodayButton: true,
                                  onSubmit: (object) {
                                    if (start == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Please Choose Your Date')));
                                    } else {
                                      startDate = start;
                                      setState(() {});
                                      Navigator.pop(context);
                                    }
                                  },
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                  monthCellStyle: DateRangePickerMonthCellStyle(
                                      todayTextStyle: TextStyle(
                                          color: ColorsManager.primaryColor)),
                                  onSelectionChanged:
                                      (DateRangePickerSelectionChangedArgs
                                          args) {
                                    if (args.value != null)
                                      start = DateFormat('dd/MM/yyyy')
                                          .format(args.value);
                                    else
                                      start = null;
                                  }),
                            ),
                          ),
                        ),
                        // transition: Transition.downToUp,
                        // duration: Duration(seconds: 1)
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: ColorsManager.iconColor,
                          )),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: ColorsManager.iconColor,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            startDate !=null?startDate!: CacheData.lang == CacheHelperKeys.keyEN?'When ?':'متي ؟',
                            style: TextStyle(
                              color: startDate == null
                                  ? ColorsManager.iconColor
                                  : Colors.black,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocConsumer<ProgramsCubit, ProgramsStates>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        int rooms = ProgramsCubit.get(context).roomsData.length;
                        int kidsWithBed = 0;
                        int kidsWithoutBed = 0;
                        int infants = 0;
                        int adults = 0;
                        ProgramsCubit.get(context).roomsData.forEach((element) {
                          adults += element.adults;
                          kidsWithBed += element.kidsWithBed;
                          kidsWithoutBed += element.kidsWithBed;
                          infants += element.infants;
                        });
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => AdultNumberView(
                                  roomsData:
                                      ProgramsCubit.get(context).roomsData),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: ColorsManager.iconColor,
                                )),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: ColorsManager.iconColor,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Text(
                                      CacheData.lang == CacheHelperKeys.keyEN?
                                  '$rooms ${'rooms'}, ${adults} adults, ${kidsWithoutBed+kidsWithBed} Children, $infants Infants':
                                  '$rooms ${'غرفة'}, ${adults} بالغ, ${kidsWithoutBed+kidsWithBed} طفل, $infants رضيع ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    height: 25,
                  ),
                  BlocConsumer<ProgramsCubit, ProgramsStates>(
                      listener: (context, state)
                      {
                        if(state is ProgramsGetErrorState)
                        {
                          callMySnackBar(context: context, text: state.error);
                        }
                        if(state is ProgramsFilterGetErrorState)
                        {
                          callMySnackBar(context: context, text: state.error);
                        }
                        if(state is ProgramsFilterGetSuccessState)
                        {
                          Get.to(()=>ProgramsListView());
                        }
                      },
                      builder: (context, state) {
                        if (
                        state is ProgramsGetLoadingState||
                        state is ProgramsGetSuccessState||
                        state is ProgramsFilterGetLoadingState
                        )
                          return Center(child: CircularProgressIndicator(),);
                        else {
                          return SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: (city == null || startDate == null)
                                  ? null
                                  :
                                  () {
                                // ProgramsCubit.get(context).getPrograms(
                                //     city: city!.id.toString(),
                                //     fromDate: startDate!,
                                //     includeFlight: includeFlights?1:0);

                                ProgramsCubit.get(context).getPrograms(
                                    city: "55",
                                    fromDate: "2023-08-25",
                                    includeFlight: 1);
                              },
                              child: Container(
                                color: (city == null || startDate == null) ?
                                Colors.grey :
                                ColorsManager.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      CacheData.lang == CacheHelperKeys.keyEN ?
                                      'Search Programs' :
                                      'ابحث عن برامج',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),

                ],
              ),
            ),
          ],
        ),
      ),
    )
 */