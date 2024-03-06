import 'package:alakh_car/models/admin/social.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/social_controller.dart';
import 'package:random_string/random_string.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final SocialController _socialController = SocialController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _facebookUrlController = TextEditingController();
  final TextEditingController _instagramUrlController = TextEditingController();
  final TextEditingController _youtubeUrlController = TextEditingController();
  String? selectedSocialId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social List'),
      ),
      body: StreamBuilder<List<SocialModel>>(
        stream: _socialController.getSocials(),
        builder: (context, AsyncSnapshot<List<SocialModel>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<SocialModel> socials = snapshot
              .requireData; // Use requireData to access the non-nullable data

          return ListView.builder(
            itemCount: socials.length,
            itemBuilder: (context, index) {
              SocialModel social = socials[index];
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email :${social.contactEmail}'),
                    Text('FaceBook Url :${social.facebookUrl}'),
                    Text('Instagram Url :${social.instagramUrl}'),
                    Text('YouTube Url  :${social.youtubeUrl}'),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    _contactEmailController.text = '';
    _facebookUrlController.text = '';
    _instagramUrlController.text = '';
    _youtubeUrlController.text = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Social'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _contactEmailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              TextField(
                controller: _facebookUrlController,
                decoration: const InputDecoration(labelText: 'Facebook Url'),
              ),
              TextField(
                controller: _instagramUrlController,
                decoration: const InputDecoration(labelText: 'Instagram Url'),
              ),
              TextField(
                controller: _youtubeUrlController,
                decoration: const InputDecoration(labelText: 'YouTube Url'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _addSocial();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateDeleteDialog(SocialModel social) async {
    selectedSocialId = social.id;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Social'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _contactEmailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              TextField(
                controller: _facebookUrlController,
                decoration: const InputDecoration(labelText: 'Facebook Url'),
              ),
              TextField(
                controller: _instagramUrlController,
                decoration: const InputDecoration(labelText: 'Instagram Url'),
              ),
              TextField(
                controller: _youtubeUrlController,
                decoration: const InputDecoration(labelText: 'YouTube Url'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateSocial();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSocial() async {
    String id = randomAlphaNumeric(10);
    final scaffoldContext = ScaffoldMessenger.of(context);
    SocialModel newSocial = SocialModel(
      id: id,
      contactEmail: _contactEmailController.text,
      facebookUrl: _facebookUrlController.text,
      instagramUrl: _instagramUrlController.text,
      youtubeUrl: _youtubeUrlController.text,
    );

    await _socialController.addSocial(newSocial, id);
  }

  Future<void> _updateSocial() async {
    if (selectedSocialId != null) {
      SocialModel updatedSocial = SocialModel(
        id: selectedSocialId!,
        contactEmail: _contactEmailController.text,
        facebookUrl: _facebookUrlController.text,
        instagramUrl: _instagramUrlController.text,
        youtubeUrl: _youtubeUrlController.text,
      );
      await _socialController.updateSocial(updatedSocial, selectedSocialId!);
    }
  }
}
