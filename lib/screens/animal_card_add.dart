// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:dog_catch/data/entities/AnimalCard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnimalCardAdd extends StatefulWidget {
  const AnimalCardAdd({Key? key}) : super(key: key);

  @override
  _AnimalCardAddState createState() => _AnimalCardAddState();
}

class _AnimalCardAddState extends State<AnimalCardAdd> {
  String? kind = AnimalCard.kindAlias;
  String? sex = AnimalCard.sexAlias;

  late File imageFile;
  late List<XFile> addImage;

  DateTime catchDate = DateTime.now();
  DateTime releaseDate = DateTime.now();

  pickProfileImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  pickAdditionalImages() async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFiles != null) {
      setState(() {
        for (XFile pickedFile in pickedFiles) {
          addImage.add(pickedFile);
        }
      });
      print(pickedFiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавление карточки"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton(
                  focusColor: Theme.of(context).colorScheme.primary,
                  items: const [
                    DropdownMenuItem(
                        value: AnimalCard.kindAlias,
                        child: Text(AnimalCard.kindAlias)),
                    DropdownMenuItem(value: "Собака", child: Text("Собака")),
                    DropdownMenuItem(value: "Кошка", child: Text("Кошка"))
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      kind = value;
                    });
                  },
                  value: kind,
                ),
                DropdownButton(
                  focusColor: Theme.of(context).colorScheme.primary,
                  items: const [
                    DropdownMenuItem(
                        value: AnimalCard.sexAlias,
                        child: Text(AnimalCard.sexAlias)),
                    DropdownMenuItem(value: "", child: Text("Мужской")),
                    DropdownMenuItem(value: "F", child: Text("Женский"))
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      sex = value;
                    });
                  },
                  value: sex,
                ),
                ElevatedButton(
                    onPressed: pickProfileImage,
                    child: const Text("Выбирите изображение профиля")),
                ElevatedButton(
                    onPressed: pickAdditionalImages,
                    child: const Text("Выбирите дополнительные изображения")),
                const TextField(
                  decoration:
                      InputDecoration(label: Text(AnimalCard.chipAlias)),
                ),
                const TextField(
                  decoration:
                      InputDecoration(label: Text(AnimalCard.badgeAlias)),
                ),
                const TextField(
                  decoration:
                      InputDecoration(label: Text(AnimalCard.infoAlias)),
                ),
                const TextField(
                  decoration: InputDecoration(label: Text(AnimalCard.orgAlias)),
                ),
                const TextField(
                  decoration: InputDecoration(
                      label: Text(AnimalCard.municipalityAlias)),
                ),

                Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                            onPressed: null, child: Text("Добавить"))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
