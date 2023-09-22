import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/resources_manager/delay_manager.dart';
import 'package:seasons/features/train/presentation/train_cubit/train_states.dart';
import 'package:seasons/features/train/presentation/views/train_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';



class TrainCubit extends Cubit<TrainStates> {
  TrainCubit() : super(TrainInitialState());
  static TrainCubit get(context) => BlocProvider.of(context);

  bool progress = false;
  bool noInternet = false;
  bool notFound = false;
  bool error = false;
  bool fromError = false;
  bool finish = false;
  bool first = true;

  void dispose()
  {
    first = true;
    emit(TrainConnectionLoadingStatusState());
  }
  late WebViewController controller;
  void initController()
  {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

     controller =
    WebViewController.fromPlatformCreationParams(params);
// ···
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(

        NavigationDelegate(
          onProgress: (int progress) {
            this.progress = true;
            emit(TrainConnectionLoadingStatusState());
            print('progress');
          },
          onPageStarted: (String url)
          {
            noInternet=false;
            notFound = false;
            error = false;
            finish = false;
            fromError  = false;
            progress = false;
            first = false;
            emit(TrainConnectionStatusState());
            print('start');
          },
          onPageFinished: (String url)
          {
            print('finish');
            finish = true;
            fromError = false;
            progress = false;
            first = false;
            emit(TrainProgressEndState());
          },
          onWebResourceError: (WebResourceError error)
          {
            // print(error);
            // if(error.description == 'net::ERR_INTERNET_DISCONNECTED')
            //   noInternet = true;
            // else if(error.description == 'net::ERR_NAME_NOT_RESOLVED')
            //   notFound = true;
            // else
            //   this.error = true;
            // fromError = true;
            // progress = false;
            // first = false;
            // emit(TrainConnectionStatusState());
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://tre.ge/en'));
  }
  void move()
  {
    Get.to(()=>const TrainView(),
      transition: DelayManager.fade,
      duration: const Duration(seconds: 1)
    );
  }

}

