import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:flutter/material.dart';

Widget searchBox(
    BuildContext context,
    Color pointColor,
    FocusNode _searchFieldNode,
    TextEditingController editingController,
    GestureTapCallback _onSubmitted) {
  return Container(
    height: 57,
    padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
    child: TextField(
      focusNode: _searchFieldNode,
      onSubmitted: null,
      textAlignVertical: TextAlignVertical.center,
      controller: editingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.marine, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        contentPadding: EdgeInsets.all(8),
        labelText: Translations.of(context).trans('search'),
        hintText: Translations.of(context).trans('search'),
        prefixIcon: Icon(
          Icons.search,
          color: _searchFieldNode.hasFocus ? Colors.blue : AppColors.marine,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    ),
  );
}
