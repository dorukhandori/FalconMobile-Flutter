import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/domain/models/announcement.dart';

final announcementsProvider = StateProvider<List<Announcement>>((ref) => [
      Announcement(
        id: 9,
        picturePath:
            'https://cdn.epic-soft.net/files/e2d5688a-3851-4a2f-8cfa-d6df89075593.png',
        query: '#',
      ),
      Announcement(
        id: 10,
        picturePath:
            'https://cdn.epic-soft.net/files/a3269a6a-73cf-408d-8b4e-b0e1bffe11d7.jpg',
        query: '#',
      ),
      Announcement(
        id: 11,
        picturePath:
            'https://cdn.epic-soft.net/files/28d4284d-f244-48d9-aa53-c0b5c1d5c2a3.jpg',
        query: '#',
      ),
      Announcement(
        id: 12,
        picturePath:
            'https://cdn.epic-soft.net/files/a2a31a8a-42cc-490d-bd0d-5806ec04dfc4.jpg',
        query: '#',
      ),
      Announcement(
        id: 13,
        picturePath:
            'https://cdn.epic-soft.net/files/c97fb621-c6ed-4f9d-87fb-5f6dd451baeb.jpg',
        query: '#',
      ),
    ]);
