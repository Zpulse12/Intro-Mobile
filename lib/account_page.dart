import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic>? userData;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _preferenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auth.userChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          this.user = user;
        });
        _fetchUserData();
      }
    });
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>?;
            if (userData!['profileImageUrl'] != null) {
              _imageUrlController.text = userData!['profileImageUrl'];
            }
            if (userData!['name'] != null) {
              _nameController.text = userData!['name'];
            }
          });
          print("User data fetched: $userData");
        }
      } catch (e) {
        print("Error fetching user data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch user data: $e")),
        );
      }
    }
  }

  Future<void> _updateUserData(String field, String value) async {
    if (user != null && value.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(user!.uid).update({
          field: value,
        });

        // Refresh the user data
        _fetchUserData();
      } catch (e) {
        print("Error updating $field: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update $field: $e")),
        );
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showEditDialog(String field, String currentValue) {
    _preferenceController.text = currentValue;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: _preferenceController,
          decoration: InputDecoration(
            labelText: field,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateUserData(field, _preferenceController.text);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: userData!['profileImageUrl'] != null
                              ? NetworkImage(userData!['profileImageUrl'])
                              : const NetworkImage(
                                  'https://via.placeholder.com/150',
                                ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  userData!['name'] ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, size: 16),
                                  onPressed: () => _showEditDialog('name', userData!['name'] ?? ''),
                                ),
                              ],
                            ),
                            if (userData!['location'] != null)
                              Text(
                                userData!['location'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            if (userData!['matches'] != null)
                              Text(
                                '${userData!['matches']} Matches',
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Player Preferences',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPreferenceItem('Best hand', userData!['bestHand'] ?? 'No Preference'),
                        _buildPreferenceItem('Court position', userData!['courtPosition'] ?? 'No Preference'),
                        _buildPreferenceItem('Match type', userData!['matchType'] ?? 'No Preference'),
                        _buildPreferenceItem('Preferred time to play', userData!['preferredTime'] ?? 'No Preference'),
                        const SizedBox(height: 16),
                        const Text(
                          'Update Profile Image',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Profile Image URL',
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _updateUserData('profileImageUrl', _imageUrlController.text),
                          child: const Text('Update Image URL'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPreferenceItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 16),
            onPressed: () => _showEditDialog(title, value),
          ),
        ],
      ),
    );
  }
}
