import 'package:flutter/foundation.dart';
import 'product.dart';

// O CartProvider gerencia a lista de itens e as regras de cálculo do carrinho
class CartProvider extends ChangeNotifier {
  // Lista privada para evitar que outras classes modifiquem os itens diretamente
  final List<CartItem> _items = [];

  // Getter para expor os itens apenas para leitura
  List<CartItem> get items => _items;

  // Calcula a quantidade total de itens individuais no carrinho (ex: 2 camisas + 1 fone = 3)
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Calcula o valor de todos os produtos somados
  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  // Regra de frete: Grátis para compras acima de R$ 200, senão custa R$ 19,99
  double get shipping => subtotal > 200 ? 0 : 19.99;

  // Valor total final da compra
  double get total => subtotal + shipping;

  // Adiciona um produto ou aumenta a quantidade se ele já existir
  void addProduct(Product product) {
    // Procura se o produto já está na lista pelo ID
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Se existe, apenas aumenta a contagem
      _items[index].quantity++;
    } else {
      // Se é novo, adiciona um novo CartItem
      _items.add(CartItem(product: product));
    }
    // AVISA O APP: "Ei, algo mudou aqui! Tratem de reconstruir as telas!"
    notifyListeners();
  }

  // Remove completamente um produto do carrinho
  void removeProduct(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Atualiza a quantidade manualmente (usado nos botões +/- da tela de detalhes)
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index); // Remove se a quantidade baixar de 1
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  // Esvazia o carrinho (ex: após finalizar uma compra)
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Verifica se um produto específico está no carrinho
  bool contains(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
}