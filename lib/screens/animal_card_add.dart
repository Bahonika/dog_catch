// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:dog_catch/data/entities/AnimalCard.dart';
import 'package:dog_catch/data/entities/AnimalCardSave.dart';
import 'package:dog_catch/data/entities/AnimalImage.dart';
import 'package:dog_catch/data/entities/AnimalKind.dart';
import 'package:dog_catch/data/entities/Claim.dart';
import 'package:dog_catch/data/entities/EventInfo.dart';
import 'package:dog_catch/data/entities/EventInfoSave.dart';
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

class AnimalCardAdd extends StatefulWidget {
  const AnimalCardAdd({Key? key, required this.user}) : super(key: key);

  final AuthorizedUser user;

  @override
  _AnimalCardAddState createState() => _AnimalCardAddState();
}

class _AnimalCardAddState extends State<AnimalCardAdd> {
  int kind = 1;
  int raidN = 1;
  int catchClaimN = 1;
  int releaseClaimN = 1;
  String? sex = AnimalCard.sexAlias;
  int municapality = 1;

  File? profileImage;
  File? catchVideo;
  File? releaseVideo;
  late List<XFile> pictures = [];

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

  pickVideoForEvent() async {
    XFile? pickedVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 21),
    );
    if (pickedVideo != null) {
      setState(() {
        catchVideo = File(pickedVideo.path);
      });
    }
  }

  pickProfileImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
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
          pictures.add(pickedFile);
        }
      });
    }
  }

  save() async {
    int profileImageId = await imageRepository.create(
        AnimalImage(File(profileImage!.path)), widget.user);

    List<int> picturesId = [];

    for (final picture in pictures) {
      picturesId.add(await imageRepository.create(
          AnimalImage(File(picture.path)), widget.user));
    }

    EventInfoSave catchEventInfoSave = EventInfoSave(
        adress: addressController.text.toString(),
        claimId: catchClaimN,
        lat: 68,
        long: 34,
        video: File(catchVideo!.path),
        raidId: raidN);

    int catchId =
        await eventInfoSaveRepository.create(catchEventInfoSave, widget.user);

    //TODO add bool checker
    EventInfoSave releaseEventInfoSave = EventInfoSave(
      adress: addressController.text,
      claimId: releaseClaimN,
      lat: 68,
      long: 34,
      video: File(catchVideo!.path),
    );

    int releaseId =
        await eventInfoSaveRepository.create(releaseEventInfoSave, widget.user);

    AnimalCardSave animalCardSave = AnimalCardSave(
        pickedProfilePicId: profileImageId,
        images: picturesId,
        kindId: kind,
        sex: sex!,
        info: infoController.text,
        municipalityId: municapality,
        catchInfoId: catchId,
        badgeN: badgeController.text,
        chipN: chipController.text,
        );

    animalCardSaveRepository.create(animalCardSave, widget.user);
  }

  getData() async {
    animalKinds = await animalKindRepository.getAll();
    municapalitys = await municipalityRepository.getAll();
    raids = await raidRepository.getAll(user: widget.user);
    catchClaims = await claimRepository
        .getAll(user: widget.user, queryParams: {"claim_type": "O"});
    releaseClaims = await claimRepository
        .getAll(user: widget.user, queryParams: {"claim_type": "V"});

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<AnimalKind>? animalKinds;
  List<Municipality>? municapalitys;
  List<Raid>? raids;
  List<Claim>? catchClaims;
  List<Claim>? releaseClaims;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавление карточки"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                municapalitys != null
                    ? DropdownButton(
                        focusColor: Theme.of(context).colorScheme.primary,
                        items: municapalitys!
                            .map((e) => DropdownMenuItem(
                                value: e.id, child: Text(e.name)))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            municapality = value!;
                          });
                        },
                        value: municapality,
                      )
                    : Text("Не работает"),
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
                animalKinds != null
                    ? DropdownButton(
                        focusColor: Theme.of(context).colorScheme.primary,
                        items: animalKinds!
                            .map((e) => DropdownMenuItem(
                                value: e.id, child: Text(e.kind)))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            kind = value!;
                          });
                        },
                        value: kind,
                      )
                    : Text("Не работает"),
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
                Center(child: Text("Информация об отлове")),
                TextField(
                  controller: addressController,
                  decoration:
                      InputDecoration(label: Text(EventInfo.adressAlias)),
                ),
                raids != null
                    ? DropdownButton(
                        focusColor: Theme.of(context).colorScheme.primary,
                        items: raids!
                            .map((e) => DropdownMenuItem(
                                value: e.raidN, child: Text(e.toString())))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            raidN = value!;
                          });
                        },
                        value: raidN,
                      )
                    : Text("Не работает"),
                catchClaims != null
                    ? DropdownButton(
                        focusColor: Theme.of(context).colorScheme.primary,
                        items: catchClaims!
                            .map((e) => DropdownMenuItem(
                                value: e.claimN, child: Text(e.toString())))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            catchClaimN = value!;
                          });
                        },
                        value: catchClaimN,
                      )
                    : Text("Не работает"),
                Center(child: Text("Информация о выпуске")),
                releaseClaims != null
                    ? DropdownButton(
                        focusColor: Theme.of(context).colorScheme.primary,
                        items: releaseClaims!
                            .map((e) => DropdownMenuItem(
                                value: e.claimN, child: Text(e.toString())))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            releaseClaimN = value!;
                          });
                        },
                        value: releaseClaimN,
                      )
                    : Text("Не работает"),
                ElevatedButton(
                    onPressed: pickVideoForEvent,
                    child: const Text("Выберите видео")),
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
