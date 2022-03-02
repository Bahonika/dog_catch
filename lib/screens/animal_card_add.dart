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
import 'package:dog_catch/utils/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AnimalCardAdd extends StatefulWidget {
  const AnimalCardAdd({Key? key, required this.user}) : super(key: key);

  final AuthorizedUser user;

  @override
  _AnimalCardAddState createState() => _AnimalCardAddState();
}

class _AnimalCardAddState extends State<AnimalCardAdd> {
  //Variables
  int? kind;
  int? raidN;
  int? catchClaimN;
  int? releaseClaimN;
  int? municipality;
  String? sex = "M";
  String validateMessage = "";
  bool isReleased = false;

  //Files
  File? profileImage;
  File? catchVideo;
  File? releaseVideo;
  List<XFile>? pictures = [];

  //Lists
  List<AnimalKind>? animalKinds;
  List<Municipality>? municipalities;
  List<Raid>? raids;
  List<Claim>? catchClaims;
  List<Claim>? releaseClaims;

  //Text controllers
  TextEditingController chipController = TextEditingController();
  TextEditingController badgeController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController catchAddressController = TextEditingController();
  TextEditingController releaseAddressController = TextEditingController();

  //Repositories
  AnimalCardSaveRepository animalCardSaveRepository =
      AnimalCardSaveRepository();
  ImageRepository imageRepository = ImageRepository();
  EventInfoSaveRepository eventInfoSaveRepository = EventInfoSaveRepository();
  MunicipalityRepository municipalityRepository = MunicipalityRepository();
  RaidRepository raidRepository = RaidRepository();
  ClaimRepository claimRepository = ClaimRepository();
  AnimalKindRepository animalKindRepository = AnimalKindRepository();

  pickVideoForEvent(String fileName) async {
    XFile? pickedVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 21),
    );
    setState(() {
      if (pickedVideo != null) {
        if (fileName == "catch") {
          catchVideo = File(pickedVideo.path);
        } else if (fileName == "release") {
          releaseVideo = File(pickedVideo.path);
        }
      }
    });
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
        pictures = pickedFiles;
      });
    }
  }

  save() async {
    List<int> picturesId = [];

    if (profileImage == null || pictures == null) {
      setState(() {
        validateMessage = "Добавьте фотографии животного";
      });
    } else if (infoController.text == "" || catchAddressController.text == "") {
      setState(() {
        validateMessage = "Заполните обязательные поля";
      });
    } else if (catchVideo == null) {
      setState(() {
        validateMessage = "Добавьте видео отлова животного";
      });
    } else if (isReleased && releaseVideo == null) {
      setState(() {
        validateMessage = "Добавьте видео выпуска животного";
      });
    } else if (isReleased && releaseAddressController.text == "") {
      setState(() {
        validateMessage = "Заполните обязательные поля";
      });
    } else {
      setState(() {
        validateMessage = "";
      });
      try {
        int profileImageId = await imageRepository.create(
            AnimalImage(File(profileImage!.path)), widget.user);
        for (final picture in pictures!) {
          picturesId.add(await imageRepository.create(
              AnimalImage(File(picture.path)), widget.user));
        }

        EventInfoSave catchEventInfoSave = EventInfoSave(
            adress: catchAddressController.text.toString(),
            claimId: catchClaimN!,
            lat: 68,
            long: 34,
            video: File(catchVideo!.path),
            raidId: raidN);

        int catchId = await eventInfoSaveRepository.create(
            catchEventInfoSave, widget.user);

        AnimalCardSave animalCardSave = AnimalCardSave(
          pickedProfilePicId: profileImageId,
          images: picturesId,
          kindId: kind!,
          sex: sex!,
          info: infoController.text,
          municipalityId: municipality!,
          catchInfoId: catchId,
          badgeN: badgeController.text,
          chipN: chipController.text,
        );

        if (isReleased) {
          EventInfoSave releaseEventInfoSave = EventInfoSave(
            adress: releaseAddressController.text,
            claimId: releaseClaimN!,
            lat: 68,
            long: 34,
            video: File(releaseVideo!.path),
          );

          animalCardSave.releaseInfoId = await eventInfoSaveRepository.create(
              releaseEventInfoSave, widget.user);
        }

        animalCardSaveRepository.create(animalCardSave, widget.user);
      } catch (e) {
        setState(() {
          validateMessage = "Что - то пошло не так";
        });
      }
    }
  }

  getData() async {
    animalKinds = await animalKindRepository.getAll();
    kind = animalKinds?.first.id;
    municipalities = await municipalityRepository.getAll();
    municipality = municipalities?.first.id;
    raids = await raidRepository.getAll(user: widget.user);
    raidN = raids?.first.raidN;
    catchClaims = await claimRepository
        .getAll(user: widget.user, queryParams: {"claim_type": "O"});
    catchClaimN = catchClaims?.first.claimN;
    releaseClaims = await claimRepository
        .getAll(user: widget.user, queryParams: {"claim_type": "V"});
    releaseClaimN = releaseClaims?.first.claimN;

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавление карточки"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Main information block
              CustomCard(
                  title: "Основная информация",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                            visible: municipalities != null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AnimalCard.municipalityAlias),
                                DropdownButton(
                                  items: municipalities
                                      ?.map((e) => DropdownMenuItem(
                                          value: e.id, child: Text(e.name)))
                                      .toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      municipality = value!;
                                    });
                                  },
                                  value: municipality,
                                ),
                              ],
                            )),
                        Visibility(
                          visible: animalKinds != null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AnimalCard.sexAlias),
                              DropdownButton(
                                focusColor:
                                    Theme.of(context).colorScheme.primary,
                                items: const [
                                  DropdownMenuItem(
                                      value: "M", child: Text("Самец")),
                                  DropdownMenuItem(
                                      value: "F", child: Text("Самка"))
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    sex = value;
                                  });
                                },
                                value: sex,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: animalKinds != null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AnimalCard.kindAlias),
                                DropdownButton(
                                  focusColor:
                                      Theme.of(context).colorScheme.primary,
                                  items: animalKinds
                                      ?.map((e) => DropdownMenuItem(
                                          value: e.id, child: Text(e.kind)))
                                      .toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      kind = value!;
                                    });
                                  },
                                  value: kind,
                                ),
                              ],
                            )),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: pickProfileImage,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Изображение профиля",
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              )),
                        ),
                        profileImage != null
                            ? Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 4),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                child: Image.file(
                                  profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: pickAdditionalImages,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Дополнительные изображения",
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              )),
                        ),
                        pictures!.isNotEmpty
                            ? Flexible(
                                child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                    itemCount: pictures!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        child: Image.file(
                                          File(pictures![index].path),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),
                              ))
                            : SizedBox(),
                        TextField(
                          controller: chipController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              label: Text(
                                  AnimalCard.chipAlias + " (Необязательно)")),
                        ),
                        TextField(
                          controller: badgeController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              label: Text(
                                  AnimalCard.badgeAlias + " (Необязательно)")),
                        ),
                        TextField(
                          controller: infoController,
                          decoration: InputDecoration(
                              label: Text(AnimalCard.infoAlias)),
                        ),
                      ],
                    ),
                  )),

              //Catch information block
              CustomCard(
                  title: "Информация об отлове",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: catchAddressController,
                          decoration: InputDecoration(
                              label: Text(
                                  EventInfo.adressAlias + " (Улица, № дома)")),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Рейд"),
                              Visibility(
                                  visible: raids != null,
                                  replacement: SizedBox(),
                                  child: DropdownButton(
                                    focusColor:
                                        Theme.of(context).colorScheme.primary,
                                    items: raids
                                        ?.map((e) => DropdownMenuItem(
                                            value: e.raidN,
                                            child: Text(e.toString())))
                                        .toList(),
                                    onChanged: (int? value) {
                                      setState(() {
                                        raidN = value;
                                      });
                                    },
                                    value: raidN,
                                  )),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Заявка на отлов"),
                            Visibility(
                                visible: catchClaims != null,
                                child: DropdownButton(
                                  focusColor:
                                      Theme.of(context).colorScheme.primary,
                                  items: catchClaims
                                      ?.map((e) => DropdownMenuItem(
                                          value: e.claimN,
                                          child: Text(e.toString())))
                                      .toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      catchClaimN = value!;
                                    });
                                  },
                                  value: catchClaimN,
                                )),
                          ],
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: () => pickVideoForEvent("catch"),
                              child: Text(
                                "Выберите видео отлова",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              )),
                        ),
                        catchVideo != null
                            ? Text(catchVideo.toString().substring(
                                catchVideo.toString().lastIndexOf("r") + 1,
                                catchVideo.toString().length - 1))
                            : SizedBox()
                      ],
                    ),
                  )),

              //isReleased controller
              CheckboxListTile(
                value: isReleased,
                activeColor: Theme.of(context).colorScheme.secondary,
                checkColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) => setState(() {
                  isReleased = value!;
                }),
                title: Text("Заполнить информацию о выпуске"),
              ),
              //Release information block
              Visibility(
                  child: Visibility(
                visible: isReleased,
                child: CustomCard(
                  title: "Информация о выпуске",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: catchAddressController,
                          decoration: InputDecoration(
                              label: Text(
                                  EventInfo.adressAlias + " (Улица, № дома)")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Заявка на выпуск"),
                            Visibility(
                                visible: releaseClaims != null,
                                child: DropdownButton(
                                  focusColor:
                                      Theme.of(context).colorScheme.primary,
                                  items: releaseClaims
                                      ?.map((e) => DropdownMenuItem(
                                          value: e.claimN,
                                          child: Text(e.toString())))
                                      .toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      releaseClaimN = value!;
                                    });
                                  },
                                  value: releaseClaimN,
                                )),
                          ],
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: () => pickVideoForEvent("release"),
                              child: Text(
                                "Выберите видео выпуска",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              )),
                        ),
                        releaseVideo != null
                            ? Text(releaseVideo.toString().substring(
                                releaseVideo.toString().lastIndexOf("r") + 1,
                                catchVideo.toString().length - 1))
                            : SizedBox()
                      ],
                    ),
                  ),
                ),
              )),
              Text(
                validateMessage,
                style: TextStyle(color: Colors.redAccent),
              ),
              Center(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                          onPressed: save,
                          child: Text(
                            "Добавить",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(fontSize: 20),
                          ))))
            ],
          ),
        ),
      ),
    );
  }
}
