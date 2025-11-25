
import 'package:flutter/material.dart';

import 'package:kwiki/widgets/custom-button.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _streetController = TextEditingController();
  final _barangayController = TextEditingController();
  final _landmarkController = TextEditingController();
  String? selectedLabel;
  bool loadingPa = false;
  final labels = ["Home", "Work", "School"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Address",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 17,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ADDRESS",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon:
                        Icon(Icons.location_on, color: Color(0xFFFF6722)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Street Address",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _streetController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Barangay",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _barangayController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "LAND MARK",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  controller: _landmarkController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("LABEL"),
                Wrap(
                  spacing: 10,
                  children: labels.map((label) {
                    return FilterChip(
                      selected: selectedLabel == label,
                      showCheckmark: false,
                      label: Text(
                        label,
                        style: TextStyle(
                          color: selectedLabel == label
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedLabel = selected ? label : null;
                        });
                      },
                      selectedColor: Color(0xFFFF6722),
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomButton(
                    loadingPa: loadingPa,
                    text: "Save Location",
                    onPressed: () async {
                      setState(() {
                        loadingPa = true;
                      });
                      try {
                        await _save();
                      } catch (e) {
                        throw "rwaw";
                      } finally {
                        setState(() {
                          loadingPa = false;
                        });
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedLabel == null) {
      return;
    }

    try {


      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving address: $e')),
      );
    }
  }
}
