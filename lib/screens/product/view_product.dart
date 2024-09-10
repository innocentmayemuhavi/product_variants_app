import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_variants_app/models/product.dart';
import 'package:product_variants_app/shared/styles/styles.dart';
import 'package:product_variants_app/utils/price_formart.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key, required this.product, this.isCarousel});
  final ProductModel product;
  final bool? isCarousel;

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: IconButton(
            icon: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                ),
                Text('Back',
                    style: normalTextStyle.copyWith(
                      fontSize: 16,
                    ))
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.product.name,
            style: normalTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color!
                      .withOpacity(0.1),
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Hero(
                  tag: widget.isCarousel == null
                      ? widget.product.id
                      : widget.isCarousel!
                          ? widget.product.name + widget.product.id
                          : widget.product.id,
                  child: Icon(
                    CupertinoIcons.photo_fill_on_rectangle_fill,
                    size: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Description',
              style: normalTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Product Title',
              style: normalTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.product.name,
              style: normalTextStyle.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Product Description',
              style: normalTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.product.description,
              style: normalTextStyle.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Product Price',
              style: normalTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Ksh ${formattedPrice(widget.product.price)}',
              style: normalTextStyle.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Variants',
              style: normalTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.product.variants.any((e) => e.name == 'Size'))
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Size Variants',
                          style: normalTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Wrap(
                          spacing: 5,
                          children: widget.product.variants
                              .where((element) => element.name == 'Size')
                              .map((variant) {
                            return Chip(
                                label: Text(' ${variant.option}',
                                    style: normalTextStyle.copyWith(
                                      fontSize: 15,
                                    )));
                          }).toList(),
                        )
                      ]),
                if (widget.product.variants.any((e) => e.name == 'Color'))
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Colour Variants',
                            style: normalTextStyle.copyWith(fontSize: 15)),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 5,
                          children: widget.product.variants
                              .where((element) => element.name == 'Color')
                              .map((variant) {
                            return Chip(label: Text(' ${variant.option}'));
                          }).toList(),
                        )
                      ]),
              ],
            ),
          ],
        ));
  }
}
