import 'package:country_flags/country_flags.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_1/Constants/constants.dart';
import 'package:project_1/Controllers/FormController/form_controller.dart';

class DropDownWidget extends StatefulWidget {
  DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  FormX formX = Get.find<FormX>();

  @override
  void initState() {
    countries.sort((a, b) => a['name'].compareTo(b['name']));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: DropdownSearch(
        onChanged: formX.changeCountry,
        dropdownButtonProps: const DropdownButtonProps(
          color: Colors.black,
        ),
        dropdownBuilder: (context, selectedItem) {
          selectedItem as Map<String, dynamic>?;

          return Row(
            children: [
              Flexible(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: selectedItem?['name'] ?? "Select a Country",
                      style: GoogleFonts.pressStart2p(color: Colors.black)),
                ),
              ),
              selectedItem?['flag'] != null
                  ? CountryFlag.fromCountryCode(
                      selectedItem?['flag'],
                      height: 20,
                      width: 40,
                    )
                  : Container()
            ],
          );
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            suffixStyle: GoogleFonts.pressStart2p(
              fontSize: 12,
            ),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.2,
              ),
            ),
          ),
        ),
        popupProps: PopupProps.modalBottomSheet(
          searchDelay: Duration.zero,
          searchFieldProps: TextFieldProps(
            padding: const EdgeInsets.all(15),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintText: "Search",
              hintStyle: GoogleFonts.pressStart2p(fontSize: 12),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
            ),
          ),
          modalBottomSheetProps: const ModalBottomSheetProps(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            side: BorderSide(width: 1.5, color: Colors.black),
          )),
          showSearchBox: true,
          itemBuilder: (context, item, isSelected) {
            final Map<String, dynamic>? country = item as Map<String, dynamic>?;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(width: 0.5, color: Colors.black)),
                elevation: 8,
                shadowColor: Colors.black,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    country?['name'] ?? '',
                    style: GoogleFonts.pressStart2p(),
                  ),
                  leading: CountryFlag.fromCountryCode(
                    '${country?['flag']}',
                    height: 40,
                    width: 50,
                  ),
                ),
              ),
            );
          },
        ),
        items: countries.map((e) => e).toList(),
      ),
    );
  }
}
