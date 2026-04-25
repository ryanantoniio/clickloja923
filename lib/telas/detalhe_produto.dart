import 'package:flutter/material.dart';
import '../modelos/product.dart';
import '../modelos/cart_provider.dart';
import '../temas/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final CartProvider cartProvider;

  const ProductDetailScreen({super.key, required this.product, required this.cartProvider});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Estados para controlar a interação do usuário
  bool _isFavorite = false;
  int _quantity = 1;
  int _selectedSize = 1;
  int _selectedColor = 0;
  bool _addedToCart = false;

  final List<String> _sizes = ['P', 'M', 'G', 'GG'];
  final List<Color> _colors = [
    AppTheme.primary,
    const Color(0xFF10B981),
    const Color(0xFFEF4444),
    const Color(0xFF1A1A2E)
  ];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppTheme.surface,
                leading: _buildBackButton(context),
                actions: [_buildFavoriteButton()],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: product.color.withOpacity(0.08),
                    child: Center(
                      child: Text(product.emoji, style: const TextStyle(fontSize: 110)),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ESTAS ERAM AS FUNÇÕES FALTANTES:
                      _buildCategoryTag(product),
                      const SizedBox(height: 10),
                      Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),

                      _buildRatingRow(product),
                      const SizedBox(height: 16),

                      _buildPriceSection(product),
                      const SizedBox(height: 24),

                      _buildSectionTitle('Cor'),
                      _buildColorPicker(),
                      const SizedBox(height: 20),

                      _buildSectionTitle('Tamanho'),
                      _buildSizePicker(),
                      const SizedBox(height: 24),

                      _buildSectionTitle('Descrição'),
                      Text(
                          product.description,
                          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6)
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(bottom: 0, left: 0, right: 0, child: _buildBuyBar()),
        ],
      ),
    );
  }

  // --- IMPLEMENTAÇÃO DAS FUNÇÕES QUE CORRIGEM OS ERROS DA FOTO ---

  Widget _buildCategoryTag(Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        product.category.toUpperCase(),
        style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRatingRow(Product product) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Text('(${product.reviewCount} avaliações)', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildPriceSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'R\$ ${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primary),
        ),
        const Text('em até 12x sem juros no cartão', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildColorPicker() {
    return Row(
      children: List.generate(_colors.length, (index) {
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = index),
          child: Container(
            margin: const
            EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _selectedColor == index ? AppTheme.primary : Colors.transparent, width: 2),
            ),
            child: CircleAvatar(backgroundColor: _colors[index], radius: 15),
          ),
        );
      }),
    );
  }

  Widget _buildSizePicker() {
    return Row(
      children: List.generate(_sizes.length, (index) {
        bool isSelected = _selectedSize == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedSize = index),
          child: Container(
            margin: const
            EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : AppTheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.divider),
            ),
            child: Text(_sizes[index], style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontWeight: FontWeight.bold)),
          ),
        );
      }),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textPrimary),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () => setState(() => _isFavorite = !_isFavorite),
      child: Container(
        margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
        width: 40,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Icon(
          _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: _isFavorite ? AppTheme.accent : AppTheme.textHint,
        ),
      ),
    );
  }

  Widget _buildBuyBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(color: AppTheme.surface, boxShadow: [BoxShadow(color: AppTheme.cardShadow, blurRadius: 20)]),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                IconButton(onPressed: () { if (_quantity > 1) setState(() => _quantity--); }, icon: const Icon(Icons.remove)),
                Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                for (int i = 0; i < _quantity; i++) {
                  widget.cartProvider.addProduct(widget.product);
                }
                setState(() => _addedToCart = true);
              },
              style: ElevatedButton.styleFrom(backgroundColor: _addedToCart ? AppTheme.success : AppTheme.primary),
              child: _addedToCart ? const Text('Adicionado!') : const Text('Adicionar ao Carrinho'),
            ),
          ),
        ],
      ),
    );
  }
}