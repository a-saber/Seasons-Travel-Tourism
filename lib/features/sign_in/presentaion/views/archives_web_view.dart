
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seasons/features/book_info/presentaion/book_info_cubit/book_info_cubit.dart';
import 'package:seasons/features/book_info/presentaion/book_info_cubit/book_info_states.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

//'https://seasonstours.netlify.app/en/cars-checkout/WyqTvUpuBH10X6aQ'

class ArchivesWebView extends StatefulWidget {
  ArchivesWebView(this.url);
  final String url;
  @override
  _ArchivesWebViewState createState() => _ArchivesWebViewState();
}

class _ArchivesWebViewState extends State<ArchivesWebView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context)
        {
          var controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse('https://seasonstours.netlify.app/en/${widget.url}'));
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: WillPopScope(
                  onWillPop: ()async
                  {
                    if(await controller.canGoBack()) {
                      controller.goBack();
                      return Future.value(false);
                    }
                    else
                    {
                      return Future.value(true);
                    }
                  },
                  child: WebViewWidget(controller: controller,))
          );
        }),
    );
  }
}

// class BookWebView extends StatefulWidget {
//   const BookWebView({super.key});
//
//   @override
//   State<BookWebView> createState() => _BookWebViewState();
// }
//
// class _BookWebViewState extends State<BookWebView> {
//   @override
//   void dispose() {
//     BookInfoCubit.get(context).dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: BlocConsumer<BookInfoCubit, BookInfoStates>(
//             listener: (context, state){},
//             builder: (context, state)
//             {
//               return SafeArea(
//                   child: WillPopScope(
//                     onWillPop: ()async
//                     {
//                       if(await BookInfoCubit.get(context).controller.canGoBack()) {
//                         BookInfoCubit.get(context).controller.goBack();
//                         return Future.value(false);
//                       }
//                       else
//                       {
//                         return Future.value(true);
//                       }
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       height: double.infinity,
//                       width: double.infinity,
//                       child: Stack(
//                         alignment: AlignmentDirectional.topCenter,
//                         children: [
//                           Builder(
//                               builder: (context) {
//
//                                 if (state is BookConnectionLoadingStatusState && BookInfoCubit.get(context).first)
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       CircularProgressIndicator()
//                                     ],
//                                   );
//                                 else if (BookInfoCubit.get(context).noInternet)
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Image.asset('assets/images/no_internet.jpg'),
//                                       SizedBox(height: 20,),
//                                       ElevatedButton(
//                                           style: ButtonStyle(
//                                               backgroundColor: MaterialStateColor
//                                                   .resolveWith((states) =>
//                                               Colors.greenAccent)
//                                           ),
//                                           onPressed: () {
//                                             BookInfoCubit.get(context).controller.reload();
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20.0),
//                                             child: Text('Refresh', style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                                 letterSpacing: 1,
//                                                 fontSize: 18),),
//                                           )),
//                                     ],
//                                   );
//                                 else if (BookInfoCubit.get(context).notFound)
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Image.asset('assets/images/not_found.jpg'),
//                                       SizedBox(height: 20,),
//                                       ElevatedButton(
//                                           style: ButtonStyle(
//                                               backgroundColor: MaterialStateColor
//                                                   .resolveWith((states) =>
//                                               Colors.greenAccent)
//                                           ),
//                                           onPressed: () {
//                                             BookInfoCubit.get(context).controller.reload();
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20.0),
//                                             child: Text('Refresh', style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                                 letterSpacing: 1,
//                                                 fontSize: 18),),
//                                           )),
//                                     ],
//                                   );
//                                 else if (BookInfoCubit.get(context).error)
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Image.asset('assets/images/error.jpg'),
//                                       SizedBox(height: 20,),
//                                       ElevatedButton(
//                                           style: ButtonStyle(
//                                               backgroundColor: MaterialStateColor
//                                                   .resolveWith((states) =>
//                                               Colors.greenAccent)
//                                           ),
//                                           onPressed: () {
//                                             BookInfoCubit.get(context).controller.reload();
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20.0),
//                                             child: Text('Refresh', style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white,
//                                                 letterSpacing: 1,
//                                                 fontSize: 18),),
//                                           )),
//                                     ],
//                                   );
//                                 else if(!BookInfoCubit.get(context).fromError)
//                                   return WebViewWidget(controller: BookInfoCubit.get(context).controller);
//                                 return SizedBox();
//                               }
//                           ),
//                           // if(!finish)
//                           //   LinearProgressIndicator(),
//                         ],
//                       ),
//                     ),
//                   ));
//             }
//         )
//     );
//   }
// }



// InAppWebView(
//   initialUrlRequest: URLRequest(
//     headers: {'Content-Type': 'application/pdf'},
//     url: Uri.parse(
//         'https://seasonstours.netlify.app/en/${state.url}'), // Replace with your desired URL
//   ),
//   onWebViewCreated: (controller) {
//     controller.addJavaScriptHandler(
//       handlerName: 'openWindow', callback: (args) {
//       // Handle popup window creation here
//       final url = args[0];
//       showDialog(
//         context: context,
//         builder: (_) =>
//             AlertDialog(
//               title: Text('Popup Window Requested'),
//               content: Text('URL: $url'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Close'),
//                 ),
//               ],
//             ),
//       );
//     },
//     );
//     _webViewController = controller;
//     _webViewController!.setOptions(
//       options: InAppWebViewGroupOptions(
//         crossPlatform: InAppWebViewOptions(
//           clearCache: true,
//           javaScriptEnabled: true,
//           useOnDownloadStart: true,
//           useShouldOverrideUrlLoading: true,
//           mediaPlaybackRequiresUserGesture: false,
//           horizontalScrollBarEnabled: false,
//         ),
//         android: AndroidInAppWebViewOptions(
//           useHybridComposition: true,
//           supportMultipleWindows: true,
//         ),
//         ios: IOSInAppWebViewOptions(
//           allowsInlineMediaPlayback: true,
//         ),
//       ),
//     );
//   },
//   onCreateWindow: (controller, createWindowRequest) {
//     // Handle popup window creation here
//     // We can prevent the popup from opening by returning false
//     return Future(() => true);
//   },
//   onLoadStart: (controller, url) {
//     print("Started loading: $url");
//   },
//   onLoadStop: (controller, url) {
//     print("Finished loading: $url");
//   },
//   onDownloadStartRequest: (controller, url) async {
//     if (await canLaunchUrl(url.url))
//       await launchUrl(url.url);
//
//     //   downloadFile(url.url.toString(), 'downloaded_file.pdf');
//     // final String _url_files = url.url.path;
//     // void _launchURL_files() async =>
//     //     await canLaunchUrl(Uri.parse(_url_files)) ? await launch(_url_files) : throw 'Could not launch $_url_files';
//     // _launchURL_files();
//     // print("onDownloadStart $url");
//     // print(url.url.path);
//     // final taskId = await FlutterDownloader.enqueue(
//     //   url: url.url.path,
//     //   savedDir: (await getExternalStorageDirectory())!.path,
//     //   showNotification: true, // show download progress in status bar (for Android)
//     //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
//     // );
//   },
// ),


/*
var options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(hideUrlBar: false),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)));
  InAppWebViewController? _webViewController;
  Future<void> downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      // Get the directory for the device's external storage
      // or use another directory if needed
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        // You can now access the downloaded file at filePath
        // and perform any necessary operations (e.g., open or share)
      } else {
        // Handle directory not found
      }
    } else {
      // Handle the HTTP request error
    }
  }
 */