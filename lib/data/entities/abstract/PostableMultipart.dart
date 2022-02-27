import 'dart:io';

import 'package:dog_catch/data/entities/abstract/Postable.dart';

abstract class PostableMultipart extends Postable{
    Map<String, File> getFiles();
}