import 'package:abulfadhwl_frontend/models/song.dart';
import 'package:flutter/material.dart';

class Album {
  final int id;
  final String name;
  final int categoryId;
  final List<Song> songs;

  Album({
    @required this.id,
    @required this.name,
    @required this.categoryId,
    @required this.songs,
  });

  Album.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['category_id'] != null),
        id = map['id'],
        name = map['name'],
        categoryId = map['category_id'],
        songs = map['songs'] != null
            ? (map['songs'] as List)
                .map((song) => Song.fromMap(song))
                .toList()
            : null;
}
