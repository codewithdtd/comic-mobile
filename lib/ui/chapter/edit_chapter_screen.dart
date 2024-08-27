import 'package:ct484_project/ui/screens.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: duplicate_import
import '../../models/chapter.dart';

import '../shared/dialog_utils.dart';

// ignore: duplicate_import
import 'chapter_manager.dart';
class EditChapterScreen extends StatefulWidget {
  static const routeName = '/edit-chapter';


  EditChapterScreen(
    String productId,
    Chapter? chapter, {
      super.key,
    }) {
    if (chapter == null) {
      this.chapter = Chapter(
        id: null,
        title: '',
        content: '',
        image: [],
        productId: productId,
      );
    } else {
        this.chapter = chapter;
    }
  }
  late final Chapter chapter;
  late final String productId;

  @override
  State<EditChapterScreen> createState() => _EditChapterScreenState();
}

class _EditChapterScreenState extends State<EditChapterScreen> {
  // final _imageUrlController = TextEditingController();
  late List<TextEditingController> _imageUrlControllers;
  // final _imageUrlFocusNode = FocusNode();
  late List<FocusNode> _imageUrlFocusNodes;
  final _editForm = GlobalKey<FormState>();
  late Chapter _editedchapter;
  var _isLoading = false;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https'));
  }
  @override

  void initState() {
    // _editedchapter = widget.chapter;
    _editedchapter = widget.chapter.id == null ? widget.chapter : context.read<ChapterManager>().findById(widget.chapter.id.toString())! ;
    // _imageUrlController.text = _editedchapter.image;
    _imageUrlControllers = List.generate(
      _editedchapter.image.length,
      (index) => TextEditingController(text: _editedchapter.image[index]),
    );
    _imageUrlFocusNodes = List.generate(
      _editedchapter.image.length,
      (index) => FocusNode(),
    );
    for (int i = 0; i < _imageUrlFocusNodes.length; i++) {
      _imageUrlFocusNodes[i].addListener(() {
        if (!_imageUrlFocusNodes[i].hasFocus) {
          for (int j = 0; j < _imageUrlControllers.length; j++) {
            if (!_isValidImageUrl(_imageUrlControllers[j].text)) {
              return;
            }
          }
          // Ảnh hợp lệ -> Vẽ lại màn hình để hiện preview
          setState(() {});
        }
      });
  }
    
    super.initState();
  }

  void deleteImageAtIndex(int index) {
    setState(() {
      _editedchapter.image.removeAt(index);
      _imageUrlControllers.removeAt(index);
      _imageUrlFocusNodes.removeAt(index);
    });
  }

  @override
  void dispose() {
    // _imageUrlController.dispose();
    for (var controller in _imageUrlControllers) {
      controller.dispose();
    }
    // _imageUrlFocusNode.dispose();
    for (var focusNode in _imageUrlFocusNodes) {
      focusNode.dispose();
    }
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
      final chapterManager = context.read<ChapterManager>();
      if (_editedchapter.id != null){
        await chapterManager.updateChapter(_editedchapter);

      }else {
        await chapterManager.addChapter(_editedchapter);
      }
    }catch (error){
      // ignore: use_build_context_synchronously
      await showErrorDialog(context, 'Something went wrong.');

    }
    setState((){
      _isLoading = false;
    });
    if (mounted){
      Navigator.of(context).pop();
      // Navigator.of(context).pushNamed(
      //   EditProductScreen.routeName,
      //   arguments: _editedchapter.productId,
      // );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit chapter'),
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
                _buildProductIdField(),
                _buidButtonAddChapter(),
                _buildchapterPreview(),
              ],
            ),
          ),
        ),
    );
  }
TextFormField _buildNameField(){
  return TextFormField(
    initialValue: _editedchapter.title,
    decoration: const InputDecoration(labelText: 'Title'),
    textInputAction: TextInputAction.next,
    autofocus: true,
    validator: (value){
      if (value!.isEmpty){
        return 'Please privide a value.';
      }
      return null;
    },
    onSaved: (value){
      _editedchapter = _editedchapter.copyWith(title: value);
    },
  );
}
TextFormField _buildProductIdField(){
  return TextFormField(
    initialValue: _editedchapter.productId,
    decoration: const InputDecoration(labelText: 'Product'),
    textInputAction: TextInputAction.next,
    autofocus: true,
    enabled: false,
    validator: (value){
      if (value!.isEmpty){
        return 'Please privide a value.';
      }
      return null;
    },
    onSaved: (value){
      _editedchapter = _editedchapter.copyWith(productId: value);
    },
  );
}
  Widget _buildchapterPreview(){
    return Column(
      children: List.generate(
      _editedchapter.image.length,
      (index) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 8, right: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: _imageUrlControllers[index].text.isEmpty
              ? const Text('Enter a URL')
              : FittedBox(
                child: Image.network(
                  _imageUrlControllers[index].text,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: _buildImageURLField(index),
            ),
            DeleteUserButton(
              onPressed: () {
                deleteImageAtIndex(index);
              },
            ),
          ],
        ),
    ),
      );
}
TextFormField _buildImageURLField(int index){
  return TextFormField(
    decoration: const InputDecoration(labelText: 'Image URL'),
    keyboardType: TextInputType.url,
    textInputAction: TextInputAction.done,
    controller: _imageUrlControllers[index],
    focusNode: _imageUrlFocusNodes[index],
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
      // _editedchapter = _editedchapter.copyWith(image[index]: value);
      setState(() {
        _editedchapter.image[index] = value;
      });
    },
  );
}

  Widget _buidButtonAddChapter() {
    return ElevatedButton(
      onPressed: () async {
        

        final updatedChapter = await Navigator.of(context).pushNamed(
          EditChapterDetailScreen.routeName,
          arguments: _editedchapter.id,
        ) as Chapter?;
        if (updatedChapter != null) {
          setState(() {
            _editedchapter = updatedChapter; // Cập nhật _editedchapter với dữ liệu mới
            _imageUrlControllers = List.generate(
              _editedchapter.image.length,
              (index) => TextEditingController(text: _editedchapter.image[index]),
            );
            _imageUrlFocusNodes = List.generate(
              _editedchapter.image.length,
              (index) => FocusNode(),
            );
          });
        }
        
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 15, 153, 70)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),   
      ), 
      child: const Text('+ Thêm mới', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
    );
  }
}

class DeleteUserButton extends StatelessWidget {
  const DeleteUserButton({
    super.key,
    this.onPressed,
    this.index,
  });

  final void Function()? onPressed;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.error, 
    );
  }
}
