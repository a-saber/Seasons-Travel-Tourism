import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListItemImage extends StatelessWidget {
  const ListItemImage(
      {Key? key, required this.image, this.isHotelDetails = false})
      : super(key: key);
  final String image;
  final bool isHotelDetails;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  borderRadius: isHotelDetails
                      ? BorderRadius.circular(0)
                      : const BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
        placeholder: (context, error) => const Icon(
              Icons.image_outlined,
              color: Colors.grey,
            ),
        fit: BoxFit.fill,
        //imageUrl: AppCubit.get(context).images[index],
        imageUrl: image,
        errorWidget: (context, url, error) => const Icon(Icons.error_outline));
  }
}
