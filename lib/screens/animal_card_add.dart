// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnimalCardAdd extends StatefulWidget {
  const AnimalCardAdd({Key? key}) : super(key: key);

  @override
  _AnimalCardAddState createState() => _AnimalCardAddState();
}

class _AnimalCardAddState extends State<AnimalCardAdd> {
  String? kind = "Выберите тип";
  String? sex = "Выберите пол";
  late File imageFile;
  late List<XFile> addImage;

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
        title: const Text("Добавление карточки животного"),
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
                        value: "Выберите тип", child: Text("Выберите тип")),
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
                        value: "Выберите пол", child: Text("Выберите пол")),
                    DropdownMenuItem(value: "M", child: Text("Мужской")),
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
                  decoration: InputDecoration(label: Text("Номер чипа")),
                ),
                const TextField(
                  decoration: InputDecoration(label: Text("Номер бирки")),
                ),
                const TextField(
                  decoration: InputDecoration(label: Text("Приметы")),
                ),
                const TextField(
                  decoration: InputDecoration(label: Text("Организация")),
                ),
                const TextField(
                  decoration: InputDecoration(label: Text("Муниципалитет")),
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