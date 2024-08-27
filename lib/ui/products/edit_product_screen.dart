import 'package:ct484_project/ui/screens.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: duplicate_import
import '../../models/product.dart';

import '../chapter/edit_chapter_grid.dart';
import '../shared/dialog_utils.dart';

// ignore: duplicate_import
import 'products_manager.dart';
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  EditProductScreen(
    Product? product, {
      super.key,
    }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        // price: 0,
        creatorId: '',
        author: '',
        description: '',
        imageUrl: '',
      );
    } else {
        this.product = product;
    }
  }
  late final Product product;
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isLoading = false;

  late Future<void> _fetchChapters;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https'))&&
          (value.endsWith('.png')||
              value.endsWith('.jpg') ||
              value.endsWith('jpeg'));
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
    _editedProduct = widget.product;
    _imageUrlController.text = _editedProduct.imageUrl;
    _fetchChapters = context.read<ChapterManager>().fetchChapters();
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
      final productsManager = context.read<ProductsManager>();
      if (_editedProduct.id != null){
        await productsManager.updateProduct(_editedProduct);

      }else {
        await productsManager.addProduct(_editedProduct);
      }
    }catch (error){
      await showErrorDialog(context, 'Something went wrong.');

    }
    setState((){
      _isLoading = false;
    });
    if (mounted){
      Navigator.of(context).pop();
      // Navigator.of(context).pushNamed(
      //   UserProductsScreen.routeName,
      // );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
      : FutureBuilder(
        future: _fetchChapters,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    _buildTitleField(),
                    // _buildPriceField(),
                    _buildAuthorField(),
                    _buildDescriptionField(),
                    _buildProductPreview(),
                    const SizedBox(height: 10,),
                    if(_editedProduct.id != null) const Text('Danh sách chương', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                    if(_editedProduct.id != null) EditChapterGrid(_editedProduct),
                    if(_editedProduct.id != null) _buidButtonAddChapter(),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
TextFormField _buildTitleField(){
  return TextFormField(
    initialValue: _editedProduct.title,
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
      _editedProduct = _editedProduct.copyWith(title: value);
    },
  );
}
TextFormField _buildAuthorField(){
  return TextFormField(
    initialValue: _editedProduct.author,
    decoration: const InputDecoration(labelText: 'Author'),
    textInputAction: TextInputAction.next,
    autofocus: true,
    validator: (value){
      if (value!.isEmpty){
        return 'Please privide a value.';
      }
      return null;
    },
    onSaved: (value){
      _editedProduct = _editedProduct.copyWith(author: value);
    },
  );
}
// TextFormField _buildPriceField(){
//   return TextFormField(
//     initialValue: _editedProduct.price.toString(),
//     decoration: const InputDecoration(labelText: 'Price'),
//     textInputAction: TextInputAction.next,
//     keyboardType: TextInputType.number,
//     validator: (value){
//       if (value!.isEmpty){
//         return 'Please enter a price.';
//       }
//       if (double.tryParse(value)==null){
//         return 'Please enter a valid number';
//       }
//       if(double.parse(value)<= 0){
//         return 'Please enter a number greater than zero.';
//       }
//       return null;
//     },
//     onSaved: (value){
//       _editedProduct = _editedProduct.copyWith(price: int.parse(value!));
//       },
//     );
//   }
  TextFormField _buildDescriptionField(){
    return TextFormField (
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value){
        if(value!.isEmpty){
          return 'Please enter a description.';
        }
        if (value.length < 10){
          return 'Should be at least 10 characters long.';
        }
        return null;
      },
      onSaved: (vaule){
        _editedProduct = _editedProduct.copyWith(description: vaule);
      },
    );
  }
  Widget _buildProductPreview(){
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
      _editedProduct = _editedProduct.copyWith(imageUrl: value);
    },
  );
}

  Widget _buidButtonAddChapter() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditChapterScreen.routeName,
          arguments: {
            'chapterId': '',
            'productId': _editedProduct.id,
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 15, 153, 70)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),   
      ), 
      child: const Text('+ Thêm chương mới', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
    );
  }
}