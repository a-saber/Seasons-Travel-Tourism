import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/features/train/presentation/train_cubit/train_cubit.dart';
import 'package:seasons/features/train/presentation/train_cubit/train_states.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrainView extends StatefulWidget {
  const TrainView({super.key});

  @override
  State<TrainView> createState() => _TrainViewState();
}

class _TrainViewState extends State<TrainView> {
  @override
  void dispose() {
    TrainCubit.get(context).dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<TrainCubit, TrainStates>(
            listener: (context, state){},
            builder: (context, state)
            {
              return SafeArea(
                  child: WillPopScope(
                    onWillPop: ()async
                    {
                      if(await TrainCubit.get(context).controller.canGoBack()) {
                        TrainCubit.get(context).controller.goBack();
                        return Future.value(false);
                      }
                      else
                      {
                        return Future.value(true);
                      }
                    },
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Builder(
                              builder: (context) {

                                if (state is TrainConnectionLoadingStatusState && TrainCubit.get(context).first)
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator()
                                    ],
                                  );
                                else if (TrainCubit.get(context).noInternet)
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/no_internet.jpg'),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                              Colors.greenAccent)
                                          ),
                                          onPressed: () {
                                            TrainCubit.get(context).controller.reload();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text('Refresh', style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1,
                                                fontSize: 18),),
                                          )),
                                    ],
                                  );
                                else if (TrainCubit.get(context).notFound)
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/not_found.jpg'),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                              Colors.greenAccent)
                                          ),
                                          onPressed: () {
                                            TrainCubit.get(context).controller.reload();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text('Refresh', style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1,
                                                fontSize: 18),),
                                          )),
                                    ],
                                  );
                                else if (TrainCubit.get(context).error)
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/error.jpg'),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                              Colors.greenAccent)
                                          ),
                                          onPressed: () {
                                            TrainCubit.get(context).controller.reload();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text('Refresh', style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1,
                                                fontSize: 18),),
                                          )),
                                    ],
                                  );
                                else if(!TrainCubit.get(context).fromError)
                                  return WebViewWidget(controller: TrainCubit.get(context).controller);
                                return SizedBox();
                              }
                          ),
                          // if(!finish)
                          //   LinearProgressIndicator(),
                        ],
                      ),
                    ),
                  ));
            }
        )
    );
  }
}
