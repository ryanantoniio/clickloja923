import 'package:flutter/material.dart';

// Representa um produto da loja
class Product {
  final String id;
  final String name;
  final String description;
  final double price;           // Preço atual (com desconto)
  final double? originalPrice;  // Preço antigo (para mostrar o "DE: R$ X")
  final String emoji;           // Usado como imagem temporária
  final String category;
  final double rating;          // Nota de 0 a 5
  final int reviewCount;
  final Color color;            // Cor base para a identidade visual do card
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.emoji,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.color,
    this.isFavorite = false,
  });

  // Getter que calcula a porcentagem de desconto automaticamente
  // Se houver preço original, aplica a fórmula:
  // $$\text{discount} = \frac{\text{originalPrice} - \text{price}}{\text{originalPrice}} \times 100$$
  double get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }
}

// Representa a união de um Produto + uma Quantidade no carrinho
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Calcula o preço total deste item (Preço x Quantidade)
  double get total => product.price * quantity;
}

// --- DADOS DE EXEMPLO (MOCK DATA) ---
// Usados para testar o app sem precisar de um banco de dados real
final List<Product> sampleProducts = [
  const Product(
    id: '1',
    name: 'Camisa Seleção Brasileira',
    description: 'Camisa oficial da Seleção Brasileira de Futebol...',
    price: 49.99,
    originalPrice: 89.99,
    emoji: '👕',
    category: 'Roupas',
    rating: 4.8,
    reviewCount: 342,
    color: Color(0xFF10B981),
  ),
  // ... outros produtos
];

// Lista de categorias disponíveis para os filtros da HomeScreen
final List<String> categories = [
  'Tudo',
  'Roupas',
  'Eletrônicos',
  'Calçados',
  'Livros',
  'Acessórios',
];