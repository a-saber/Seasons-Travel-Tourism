import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

import '../local_database/cache_data.dart';
import '../local_database/cache_helper_keys.dart';
import '../resources_manager/style_manager.dart';

PreferredSizeWidget? defaultAppBar({
  required context,
  required String text,
  bool hasLeading = false,
  Widget? action ,
  double? elevation =4
})=>
AppBar(
  elevation: elevation,
  backgroundColor: ColorsManager.primaryColor,
  title: Text(text,style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),),
  leadingWidth: 35,
  actions:
  [
    if(action != null)
      action
  ],
  leading: hasLeading?
      CacheData.lang == CacheHelperKeys.keyAR ?
      null :
      Padding(
        padding: const EdgeInsetsDirectional.only( top: 15.0,bottom: 15.0, start: 10),
        child: InkWell(
          onTap: ()
          {
            Navigator.pop(context);
          },
          child: const CircleAvatar(
            radius: 13,
            backgroundColor: ColorsManager.appBarTitleContainer,
            child: Icon(Icons.arrow_back, color: Colors.white,size: 18,),
          ),
        ),
      ):
          null,
);
//     AppBar(
//       automaticallyImplyLeading: false,
//       elevation: 1.5,
//       shadowColor: Colors.grey.withOpacity(0.5),
//       backgroundColor: Colors.blue,
//       title: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             height: 35,
//             decoration: BoxDecoration(
//               color: ColorsManager.appBarTitleContainer,
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsetsDirectional.only(start: 8),
//             height: 40,
//             color: Colors.white,
//           ),
//           Container(
//             height: 35,
//             margin: const EdgeInsetsDirectional.only(start: 2),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(7),
//             ),
//             padding: const EdgeInsets.all(5),
//             child: Align(
//               alignment: AlignmentDirectional.centerStart,
//               child: Text(
//                 text,
//                 style: StyleManager.appbarTitle,
//               ),
//             ),
//           )
//
//         ],
//       ),
//       leadingWidth: 35,
//       leading: hasLeading?
//       CacheData.lang == CacheHelperKeys.keyAR ?
//       null :
//       Padding(
//         padding: const EdgeInsetsDirectional.only( top: 15.0,bottom: 15.0, start: 10),
//         child: InkWell(
//           onTap: ()
//           {
//             Navigator.pop(context);
//           },
//           child: const CircleAvatar(
//             radius: 13,
//             backgroundColor: ColorsManager.appBarTitleContainer,
//             child: Icon(Icons.arrow_back, color: Colors.white,size: 18,),
//           ),
//         ),
//       ):
//           null
//       ,
//       actions: [
//         if(hasLeading && CacheData.lang == CacheHelperKeys.keyAR)
//       Padding(
//         padding: const EdgeInsets.only(left: 10.0),
//         child: Directionality(
//           textDirection: TextDirection.ltr,
//           child: InkWell(
//             onTap: ()
//             {
//               Navigator.pop(context);
//             },
//             child: const CircleAvatar(
//               radius: 13,
//               backgroundColor: ColorsManager.appBarTitleContainer,
//               child: Icon(Icons.arrow_back, color: Colors.white,size: 18,),
//             ),
//           ),
//         ),
//       ),
//         if (action !=null)
//         action
//       ],
// );

/*
 boxShadow:
          [
            const BoxShadow(
                color: Colors.white,
                offset: Offset(0, 1)
            ),
            BoxShadow(
                color:  CacheData.lang == CacheHelperKeys.keyAR ?
                ColorsManager.appBarTitleContainer :
                Colors.white,
                offset: const Offset(1, 0),
            ),
            BoxShadow(
                color: CacheData.lang == CacheHelperKeys.keyAR ?
                Colors.white :
                ColorsManager.appBarTitleContainer ,
                offset: const Offset(-1, 0)
            ),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(0, 0)
            ),
          ]
 */