import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магазин машинок',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [
    Product('Машина 1', 'assets/product1.jpg', 'Описание товара.'),
    Product('Что-то большее чем машина', 'assets/product2.jpg', 'Описание чего-то большего чем машина.'),
    Product('Машина 3', 'assets/product3.jpg', 'описание машины 3.'),
    Product('Машина 4', 'assets/product4.jpg', 'Тут есть описание.'),
    Product('Машина 5', 'assets/product5.jpg', 'Описание?'),
  ];

  List<Product> favoriteProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Магазин машинок'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteScreen(
                    favoriteProducts: favoriteProducts,
                    onRemove: (product) {
                      setState(() {
                        favoriteProducts.remove(product);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 столбца
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: products[index],
                    onDelete: () {
                      setState(() {
                        products.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                    onFavorite: () {
                      setState(() {
                        if (favoriteProducts.contains(products[index])) {
                          favoriteProducts.remove(products[index]);
                        } else {
                          favoriteProducts.add(products[index]);
                        }
                      });
                    },
                    isFavorite: favoriteProducts.contains(products[index]),
                  ),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      products[index].imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(products[index].name, style: TextStyle(fontSize: 16)),
                  ),
                  IconButton(
                    icon: Icon(
                      favoriteProducts.contains(products[index]) ? Icons.favorite : Icons.favorite_border,
                      color: favoriteProducts.contains(products[index]) ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (favoriteProducts.contains(products[index])) {
                          favoriteProducts.remove(products[index]);
                        } else {
                          favoriteProducts.add(products[index]);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;
  final bool isFavorite;

  ProductDetailScreen({
    required this.product,
    required this.onDelete,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(product.description, style: TextStyle(fontSize: 16)),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavorite,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Подтверждение удаления'),
                      content: Text('Вы уверены, что хотите удалить этот товар?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete();
                          },
                          child: Text('Удалить'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Удалить товар'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  final List<Product> favoriteProducts;
  final Function(Product) onRemove;

  FavoriteScreen({required this.favoriteProducts, required this.onRemove});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: widget.favoriteProducts.isEmpty
          ? Center(child: Text('Избранных товаров нет'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: widget.favoriteProducts.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    widget.favoriteProducts[index].imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.favoriteProducts[index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.onRemove(widget.favoriteProducts[index]);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ФИО: Быков Александр', style: TextStyle(fontSize: 18)),
            Text('Группа: ЭФБО-03-22', style: TextStyle(fontSize: 18)),
            Text('Телефон: +7 123 456 7890', style: TextStyle(fontSize: 18)),
            Text('Почта: bykov@mail.com', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String imagePath;
  final String description;

  Product(this.name, this.imagePath, this.description);
}
