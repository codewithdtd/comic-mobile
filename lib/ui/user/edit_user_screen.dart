import 'package:ct484_project/ui/screens.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: duplicate_import
import '../../models/user.dart';

import '../shared/dialog_utils.dart';

// ignore: duplicate_import
import 'user_manager.dart';
class EditUserScreen extends StatefulWidget {
  static const routeName = '/edit-user';

  EditUserScreen(
    User? user, {
      super.key,
    }) {
    if (user == null) {
      this.user = User(
        id: null,
        title: '',
        creatorId: '',
        description: '',
        imageAvatar: '',
        imageBackground: '',
      );
    } else {
        this.user = user;
    }
  }
  late final User user;
  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _imageUrlController = TextEditingController();
  final _backgroundImageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _backgroundImageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late User _editedUser;
  var _isLoading = false;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https'));
      // return (value.startsWith('http') || value.startsWith('https'));
  }

  bool _isValidBackgroundImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https'));
      // return (value.startsWith('http') || value.startsWith('https'));
  }
  @override

  void initState() {
    _imageUrlFocusNode.addListener((){
      if (!_imageUrlFocusNode.hasFocus){
        if (!_isValidImageUrl(_imageUrlController.text)){
          return;
        }
        // Ảnh hợp lệ -> Vẽ lại màn hình để hiện preview
        setState(() {});
      }
    });
    _backgroundImageUrlFocusNode.addListener((){
      if (!_backgroundImageUrlFocusNode.hasFocus){
        if (!_isValidBackgroundImageUrl(_backgroundImageUrlController.text)){
          return;
        }
        // Ảnh hợp lệ -> Vẽ lại màn hình để hiện preview
        setState(() {});
      }
    });
    _editedUser = widget.user;
    _imageUrlController.text = _editedUser.imageAvatar;
    _backgroundImageUrlController.text = _editedUser.imageBackground;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid){
      return;
    }
    _editForm.currentState!.save();
    setState((){
      _isLoading = true;
    });
    try {
      final userManager = context.read<UserManager>();
      if (_editedUser.id != null){
        await userManager.updateUser(_editedUser);

      }else {
        await userManager.addUser(_editedUser);
      }
    }catch (error){
      await showErrorDialog(context, 'Something went wrong.');

    }
    setState((){
      _isLoading = false;
    });
    if (mounted){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProductsOverviewScreen(),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
        ? const Center(
          child: CircularProgressIndicator(),
        )
      : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _editForm,
            child: ListView(
              children: <Widget>[
                _buildNameField(),
                _buildDescriptionField(),
                Text('Avatar'),
                _buildUserPreview(),
                Text('Background'),
                _buildBackgroundUserPreview(),
              ],
            ),
          ),
        ),
    );
  }
TextFormField _buildNameField(){
  return TextFormField(
    initialValue: _editedUser.title,
    decoration: const InputDecoration(labelText: 'Name'),
    textInputAction: TextInputAction.next,
    autofocus: true,
    validator: (value){
      if (value!.isEmpty){
        return 'Please privide a value.';
      }
      return null;
    },
    onSaved: (value){
      _editedUser = _editedUser.copyWith(title: value);
    },
  );
}

  TextFormField _buildDescriptionField(){
    return TextFormField (
      initialValue: _editedUser.description,
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value){
        if(value!.isEmpty){
          return 'Please enter a description.';
        }
        if (value.length > 20){
          return 'Should be maximum 20 characters long.';
        }
        return null;
      },
      onSaved: (vaule){
        _editedUser = _editedUser.copyWith(description: vaule);
      },
    );
  }
  Widget _buildUserPreview(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _imageUrlController.text.isEmpty
          ? const Text('Enter a URL')
          : FittedBox(
            child: Image.network(
              _imageUrlController.text,
              fit: BoxFit.cover,
            ),
          ),
      ),
        Expanded(
          child: _buildImageURLField(),
        ),
      ],
    );
}
TextFormField _buildImageURLField(){
  return TextFormField(
    decoration: const InputDecoration(labelText: 'Image URL'),
    keyboardType: TextInputType.url,
    textInputAction: TextInputAction.done,
    controller: _imageUrlController,
    focusNode: _imageUrlFocusNode,
    onFieldSubmitted: (value)=> _saveForm(),
    validator: (value){
      if (value!.isEmpty){
        return 'Please enter image URL.';
      }
      if(!_isValidImageUrl((value))){
        return 'Please enter a valid image URL.';
      }
      return null;
    },
    onSaved: (value){
      _editedUser = _editedUser.copyWith(imageAvatar: value);
    },
  );
}

  Widget _buildBackgroundUserPreview(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _backgroundImageUrlController.text.isEmpty
          ? const Text('Enter a URL')
          : FittedBox(
            child: Image.network(
              _backgroundImageUrlController.text,
              fit: BoxFit.cover,
            ),
          ),
      ),
        Expanded(
          child: _buildBackgroundImageURLField(),
        ),
      ],
    );
}
TextFormField _buildBackgroundImageURLField(){
  return TextFormField(
    decoration: const InputDecoration(labelText: 'Image URL'),
    keyboardType: TextInputType.url,
    textInputAction: TextInputAction.done,
    controller: _backgroundImageUrlController,
    focusNode: _backgroundImageUrlFocusNode,
    onFieldSubmitted: (value)=> _saveForm(),
    validator: (value){
      if (value!.isEmpty){
        return 'Please enter image URL.';
      }
      if(!_isValidBackgroundImageUrl((value))){
        return 'Please enter a valid image URL.';
      }
      return null;
    },
    onSaved: (value){
      _editedUser = _editedUser.copyWith(imageBackground: value);
    },
  );
}

}