import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanoid/nanoid.dart';
import 'package:product_variants_app/models/product.dart';
import 'package:product_variants_app/shared/styles/styles.dart';
import 'package:product_variants_app/utils/price_formart.dart';

// Main Home Widget
class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.addProduct});
  final Function addProduct;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // File? _image;
  String _title = '';
  String _description = '';
  String _price = '';
  // final String _quantity = '';
  String? _selectedOption;
  bool _isOptionDisabled = false;
  String? _selectedOptionValue;
  final List<VariantModel> _addedVariants = [];

  // Predefined options and their values
  final List<String> _sizeOptions = ['Small', 'Medium', 'Large', 'Extra Large'];
  final List<String> _colorOptions = ['Red', 'Green', 'Blue', 'Yellow'];
  // final List<String> _materialOptions = ['Cotton', 'Polyester', 'Silk', 'Wool'];
  final List<String> _doneVariants = [];

  // List of variant types (option names)
  final List<String> _options = [
    'Size',
    'Color',
  ];

  // Image picker for selecting images from the gallery
  // _imgFromGallery() async {
  //   final image = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 50,
  //   );

  //   if (image != null) {
  //     setState(() {
  //       _image = File(image.path);
  //     });
  //   }
  // }

  // Returns the appropriate option values based on the selected option
  List<String> _getOptionValues(String? selected) {
    switch (selected) {
      case 'Size':
        return _sizeOptions;
      case 'Color':
        return _colorOptions;

      default:
        return [];
    }
  }

  // Handle option value removal
  _removeOptionValue(String value) {
    setState(() {
      if (_selectedOption == 'Size') {
        _sizeOptions.remove(value);
      } else {
        _colorOptions.remove(value);
      }
    });
  }

  void _addOptionValue(String value) {
    setState(() {
      if (_selectedOption == 'Size') {
        _sizeOptions.add(value);
      } else {
        _colorOptions.add(value);
      }
    });
  }

  bool _showTable = false; // Add this to control table visibility

  // Function to generate all combinations of variants
  List<Map<String, String>> _generateCombinations() {
    List<String> sizes = _addedVariants
        .where((element) => element.name == 'Size')
        .map((e) => e.option)
        .toList();
    List<String> colors = _addedVariants
        .where((element) => element.name == 'Color')
        .map((e) => e.option)
        .toList();

    List<Map<String, String>> combinations = [];

    // If both Size and Color are available
    if (sizes.isNotEmpty && colors.isNotEmpty) {
      for (String size in sizes) {
        for (String color in colors) {
          combinations.add({
            'Size': size,
            'Color': color,
            'Price': '0', // Set default price to 0
          });
        }
      }
    }
    // If only Size is available
    else if (sizes.isNotEmpty) {
      for (String size in sizes) {
        combinations.add({
          'Size': size,
          'Color': '', // No color available
          'Price': '0', // Set default price to 0
        });
      }
    }
    // If only Color is available
    else if (colors.isNotEmpty) {
      for (String color in colors) {
        combinations.add({
          'Size': '', // No size available
          'Color': color,
          'Price': '0', // Set default price to 0
        });
      }
    }

    return combinations;
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.addProduct(ProductModel(
                    id: nanoid(),
                    name: _title,
                    description: _description,
                    price: _price,
                    variants: _addedVariants,
                  ));
                  SnackBar snackBar = SnackBar(
                    content: Text('Product added successfully',
                        style: normalTextStyle.copyWith(
                          fontSize: 16,
                        )),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: normalTextStyle.copyWith(
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                    fontSize: 16),
              )),
        ],
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
          'Add Product',
          style: normalTextStyle.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: _showTable
          ? ElevatedButton(
              onPressed: _scrollToBottom,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.arrow_down_circle,
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_generateCombinations().length} new variants',
                    style: normalTextStyle.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color!,
                      fontSize: 15,
                    ),
                  ),
                ],
              ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                  width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: normalTextStyle,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.green,
                    onChanged: (value) {
                      _title = value;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      hintText: 'Title of the product',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('Description', style: normalTextStyle),
                  const SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.green,
                    onChanged: (value) {
                      _description = value;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      hintText: 'Description of the product',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  Text('Price', style: normalTextStyle),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                    cursorColor: Colors.green,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _price = value;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                      hintText: 'Price of the product',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                  width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Options', style: normalTextStyle),
                const SizedBox(height: 10),
                Text(
                  'Option Name',
                  style: normalTextStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Dropdown for selecting option type (e.g., Size, Color, Material)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isOptionDisabled
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodySmall!.color!,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    isDense: true,
                    isExpanded: true,
                    value: _selectedOption,
                    hint: Text(
                      'Select Option',
                      style: normalTextStyle,
                    ),
                    items: _options.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: normalTextStyle,
                        ),
                      );
                    }).toList(),
                    onChanged: _isOptionDisabled
                        ? null
                        : (value) {
                            setState(() {
                              _selectedOption = value;
                              _selectedOptionValue = null;
                            });
                          },
                  ),
                ),
                const SizedBox(height: 10),
                Text('Option Value', style: normalTextStyle),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_doneVariants.contains('Size'))
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
                              children: _addedVariants
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
                    if (_doneVariants.contains('Color'))
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
                              children: _addedVariants
                                  .where((element) => element.name == 'Color')
                                  .map((variant) {
                                return Chip(label: Text(' ${variant.option}'));
                              }).toList(),
                            )
                          ]),
                  ],
                ),
                if (_selectedOption != null &&
                    _addedVariants
                        .where((element) => element.name == _selectedOption!)
                        .isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _addedVariants
                        .where((element) => element.name == _selectedOption!)
                        .map((variant) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).textTheme.bodySmall!.color!,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            ' ${variant.option}',
                            style: normalTextStyle.copyWith(
                              fontSize: 17,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _addedVariants.removeWhere(
                                    (element) => element.id == variant.id);
                                _addOptionValue(variant.option);
                                if (_addedVariants.isEmpty) {
                                  _isOptionDisabled = true;
                                }
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: !_isOptionDisabled
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodySmall!.color!,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    isDense: true,
                    isExpanded: true,
                    value: _selectedOptionValue,
                    hint: Text(
                      'Select Value',
                      style: normalTextStyle,
                    ),
                    underline: Container(),
                    items: _getOptionValues(_selectedOption).map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _getOptionValues(_selectedOption).isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              _selectedOptionValue = value;
                              _isOptionDisabled = true;
                              // Add the variant to the list
                              _addedVariants.add(VariantModel(
                                id: nanoid(),
                                name: _selectedOption!,
                                option: _selectedOptionValue!,
                              ));

                              // Remove the selected value from the corresponding option list
                              _removeOptionValue(_selectedOptionValue!);
                              // Reset the selected option value
                              _selectedOptionValue = null;
                            });
                          },
                  ),
                ),
                const SizedBox(height: 10),
                // Button to add selected option and value as a variant
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * .4, 40),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        side: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _selectedOption == null
                          ? null
                          : () {
                              setState(() {
                                _doneVariants.add(_selectedOption!);
                                _options.remove(_selectedOption);
                                _selectedOption = null;
                                _isOptionDisabled = false;
                                _showTable = true;
                              });
                            },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                          fontFamily: GoogleFonts.kanit().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * .8, 40),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 3,
                        ),
                        side: BorderSide(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _options.isEmpty
                          ? null
                          : () {
                              setState(() {
                                if (_selectedOption != null &&
                                    _selectedOptionValue != null) {
                                  _removeOptionValue(_selectedOptionValue!);
                                }
                                _options.remove(_selectedOption);
                                _selectedOption = null;
                                _selectedOptionValue = null;
                                _isOptionDisabled = _options.isEmpty;
                              });
                            },
                      child: Text(
                        'Add Another Option',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                          fontFamily: GoogleFonts.kanit().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                // Display list of added variants
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (_showTable)
            Text('Variants', style: normalTextStyle), // Display the table

          if (_showTable)
            Container(
                padding: const EdgeInsets.only(bottom: 100),
                child: _buildVariantTable()), // Display the table
        ],
      ),
    );
  }

  Widget _buildVariantTable() {
    List<Map<String, String>> combinations = _generateCombinations();

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // Set the desired border color
                    width: 1,
                  ),
                ),
              ),
              child: _buildTableCell('Variant'),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // Set the desired border color
                    width: 1,
                  ),
                ),
              ),
              child: _buildTableCell('Price'),
            ),
          ],
        ),
        for (var combination in combinations)
          TableRow(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Set the desired border color
                      width: 1,
                    ),
                  ),
                ),
                child: _buildTableCell(
                  '${combination['Size'] ?? ''}${(combination['Size'] != null && combination['Size']!.isNotEmpty && combination['Color'] != null && combination['Color']!.isNotEmpty) ? '/' : ''}${combination['Color'] ?? ''}',
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Set the desired border color
                      width: 1,
                    ),
                  ),
                ),
                child: _buildTableCell(formattedPrice(_price)),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: normalTextStyle.copyWith(
          fontSize: 16,
        ),
      ),
    );
  }
}
