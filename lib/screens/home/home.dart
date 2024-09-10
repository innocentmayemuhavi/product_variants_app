import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_variants_app/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:product_variants_app/screens/product/add_product.dart';
import 'package:product_variants_app/screens/product/view_product.dart';
import 'package:product_variants_app/shared/styles/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProductModel> products = [
    ProductModel(
      id: '1',
      name: 'Dress',
      description: 'Dress description',
      price: '100',
      variants: [],
    ),
    ProductModel(
      id: '3',
      name: 'Shirt',
      description: 'Shirt description',
      price: '100',
      variants: [],
    ),
  ];
  void _addProduct(ProductModel product) {
    setState(() {
      products.insert(0, product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProduct(
                          addProduct: _addProduct,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                  )),
            ],
            scrolledUnderElevation: 0,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodySmall!.color!,
                fontFamily: GoogleFonts.kanit().fontFamily,
              ),
            )),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text(
              'Latest Products',
              style: normalTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                  autoPlay: true,
                  height: MediaQuery.of(context).size.height * 0.2),
              items: products.map((product) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ViewProduct(
                              isCarousel: true,
                              product: product,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color!,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color!,
                                  fontFamily: GoogleFonts.kanit().fontFamily,
                                ),
                              ),
                              Hero(
                                tag: product.name + product.id,
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.photo_fill_on_rectangle_fill,
                                    size:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Popular Products',
                    style: normalTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProduct(
                          addProduct: _addProduct,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Add Product',
                    style: normalTextStyle.copyWith(
                      fontSize: 17,
                      color: Theme.of(context).textTheme.bodySmall!.color!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GridView.builder(
              itemCount: products.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Set a fixed number of columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ViewProduct(
                          product: products[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.2,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).textTheme.bodySmall!.color!,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Text(
                          products[index].name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodySmall!.color!,
                            fontFamily: GoogleFonts.kanit().fontFamily,
                          ),
                        ),
                        Hero(
                          tag: products[index].id,
                          child: Center(
                            child: Icon(
                              CupertinoIcons.photo_fill_on_rectangle_fill,
                              size: MediaQuery.of(context).size.width * 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
