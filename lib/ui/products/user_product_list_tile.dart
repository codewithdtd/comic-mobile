import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../screens.dart';

class UserProductListTile extends StatelessWidget { 
  final Product product;

  const UserProductListTile( 
    this.product, {
    super.key,
  });

  @override
  Widget build (BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      title: Text (product.title, overflow: TextOverflow.ellipsis,),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10), 
        child: SizedBox(
          height: double.infinity, // Chiều cao mong muốn của hình ảnh
          width: 100, // Chiều rộng của hình ảnh
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            EditUserProductButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: product.id,
                );
              },
            ),
            DeleteUserProductButton(
              onPressed: () {
                context.read<ProductsManager>().deleteProduct(product.id!);
                context.read<ChapterManager>().deleteChapterWithProduct(product.id!);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Product deleted',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteUserProductButton extends StatelessWidget {
  const DeleteUserProductButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.error, 
    );
  }
}

class EditUserProductButton extends StatelessWidget {
  const EditUserProductButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary, 
    );
  }
}