// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:dog_catch/data/entities/AnimalCard.dart';
import 'package:dog_catch/data/entities/AnimalKind.dart';
import 'package:dog_catch/data/entities/Claim.dart';
import 'package:dog_catch/data/entities/Municipality.dart';
import 'package:dog_catch/data/entities/Raid.dart';
import 'package:dog_catch/data/entities/User.dart';
import 'package:dog_catch/data/repository/AnimalCardSaveRepository.dart';
import 'package:dog_catch/data/repository/AnimalKindRepository.dart';
import 'package:dog_catch/data/repository/ClaimRepository.dart';
import 'package:dog_catch/data/repository/EventInfoSaveRepository.dart';
import 'package:dog_catch/data/repository/ImageRepository.dart';
import 'package:dog_catch/data/repository/MunicipalityRepository.dart';
import 'package:dog_catch/data/repository/RaidRepository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/entities/AnimalImage.dart';

class AnimalCardAdd extends StatefulWidget {
  const AnimalCardAdd({Key? key, required this.user}) : super(key: key);

  final AuthorizedUser user;

  @override
  _AnimalCardAddState createState() => _AnimalCardAddState();
}

class _AnimalCardAddState extends State<AnimalCardAdd> {
  int kind = 1;
  String? sex = AnimalCard.sexAlias;
  int municapality = 1;

  File? imageFile;
  late List<XFile> addImage;

  DateTime catchDate = DateTime.now();
  DateTime releaseDate = DateTime.now();

  //for AnimalCardSave
  TextEditingController chipController = TextEditingController();
  TextEditingController badgeController = TextEditingController();
  TextEditingController infoController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  AnimalCardSaveRepository animalCardSaveRepository =
      AnimalCardSaveRepository();
  ImageRepository imageRepository = ImageRepository();
  EventInfoSaveRepository eventInfoSaveRepository = EventInfoSaveRepository();
  MunicipalityRepository municipalityRepository = MunicipalityRepository();
  RaidRepository raidRepository = RaidRepository();
  ClaimRepository claimRepository = ClaimRepository();
  AnimalKindRepository animalKindRepository = AnimalKindRepository();

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
    }
  }

  save() {
    print("sdas");
    imageRepository.create(AnimalImage(File(imageFile!.path)), widget.user);
  }

  getData() async {
    animalKinds = await animalKindRepository.getAll();
    municapalitys = await municipalityRepository.getAll();
    setState(() {});
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  List<AnimalKind>? animalKinds;
  List<Municipality>? municapalitys;
  late List<Raid> raids;
  late List<Claim> claims;

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
                municapalitys != null ? DropdownButton(
                  focusColor: Theme.of(context).colorScheme.primary,
                  items:
                  municapalitys!.map((e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name))).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      municapality = value!;
                    });
                  },
                  value: municapality,
                ) : Text("Не работает"),
                DropdownButton(
                  focusColor: Theme.of(context).colorScheme.primary,
                  items: const [
                    DropdownMenuItem(
                        value: AnimalCard.sexAlias,
                        child: Text(AnimalCard.sexAlias)),
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
                animalKinds != null ? DropdownButton(
                  focusColor: Theme.of(context).colorScheme.primary,
                  items:
                  animalKinds!.map((e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.kind))).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      kind = value!;
                    });
                  },
                  value: kind,
                ) : Text("Не работает"),
                ElevatedButton(
                    onPressed: pickProfileImage,
                    child: const Text("Выбирите изображение профиля")),
                ElevatedButton(
                    onPressed: pickAdditionalImages,
                    child: const Text("Выбирите дополнительные изображения")),
                TextField(
                  controller: chipController,
                  decoration:
                      InputDecoration(label: Text(AnimalCard.chipAlias)),
                ),
                TextField(
                  controller: badgeController,
                  decoration:
                      InputDecoration(label: Text(AnimalCard.badgeAlias)),
                ),
                TextField(
                  controller: infoController,
                  decoration:
                      InputDecoration(label: Text(AnimalCard.infoAlias)),
                ),

                //orgaznization
                // DropdownButton(items: items, onChanged: onChanged),

                //municipalitet
                // DropdownButton(items: items, onChanged: onChanged)

                Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                            onPressed: save, child: Text("Добавить"))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
