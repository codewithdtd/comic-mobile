import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: duplicate_import
import '../../models/chapter.dart';

import '../shared/dialog_utils.dart';

// ignore: duplicate_import
import 'chapter_manager.dart';

class EditChapterDetailScreen extends StatefulWidget {
  static const routeName = '/edit-chapter-detail';


  EditChapterDetailScreen(
    Chapter? chapter, {
      super.key,
    }) {
    if (chapter == null) {
      this.chapter = Chapter(
        id: null,
        title: '',
        content: '',
        image: [],
        productId: '',
      );
    } else {
        this.chapter = chapter;
    }
  }
  late final Chapter chapter;


  @override
  State<EditChapterDetailScreen> createState() => _EditChapterDetailScreenState();
}

class _EditChapterDetailScreenState extends State<EditChapterDetailScreen> {
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
    _editedchapter = widget.chapter;
    _editedchapter.image.add('');
    // _imageUrlController.text = _editedchapter.image;
    _imageUrlControllers = List.generate(
      _editedchapter.image.length,
      (index) => TextEditingController(text: _editedchapter.image[index]),
    );
    _imageUrlFocusNodes = List.generate(
      _editedchapter.image.length,
      (index) => FocusNode(),
    );
    // _imageUrlControllers.add(TextEditingController(text: ''));
    // _imageUrlFocusNodes.add(FocusNode());
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
      // final chapterManager = Provider.of<ChapterManager>(context);
      // final fetchedChapter = chapterManager.findById(_editedchapter.id);

      final chapterManager = context.read<ChapterManager>();
      if (_editedchapter.id != null){
        // await chapterManager.updateChapter(_editedchapter);
        chapterManager.updateChapterDetail(_editedchapter);
      }else {
        chapterManager.updateChapterDetail(_editedchapter);
      }
    }catch (error){
      await showErrorDialog(context, 'Something went wrong.');

    }
    setState((){
      _isLoading = false;
    });

    if (mounted){
      _editedchapter.image[_editedchapter.image.length - 1] != '' 
      ? Navigator.of(context).pop(_editedchapter)
      : Navigator.of(context).pop(null);
      // Navigator.of(context).pushNamed(
      //   EditChapterScreen.routeName,
      //   // arguments: chapter.id,
      //   arguments: {
      //     'chapterId': _editedchapter.id,
      //     'productId': _editedchapter.productId,
      //   },
      // );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit chapter detail'),
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
                Text('Thêm mới'),
                _buildchapterPreview(),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildchapterPreview(){
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
              child: _imageUrlControllers[_editedchapter.image.length - 1].text.isEmpty
              ? const Text('Enter a URL')
              : FittedBox(
                child: Image.network(
                  _imageUrlControllers[_editedchapter.image.length - 1].text,
                  fit: BoxFit.cover,
                ),
              ),
          ),
            Expanded(
              child: _buildImageURLField(_editedchapter.image.length - 1),
            ),
          ],
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


}
