import 'package:flutter/material.dart';
import '../modelos/product.dart';
import '../modelos/cart_provider.dart';
import '../temas/app_theme.dart';
import '../widgets/product_card.dart';
import 'detalhe_produto.dart';

class SearchScreen extends StatefulWidget {
  final CartProvider cartProvider;

  const SearchScreen({super.key, required this.cartProvider});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String _selectedFilter = 'Relevância';

  final List<String> _recentSearches = [
    'Camisa Brasil',
    'Monitor 4K',
    'Fone Bluetooth',
  ];

  final List<String> _filterOptions = [
    'Relevância',
    'Menor Preço',
    'Maior Preço',
    'Avaliação',
  ];

  List<Product> get searchResults {
    if (_query.isEmpty) return [];
    return sampleProducts.where((p) =>
    p.name.toLowerCase().contains(_query.toLowerCase()) ||
        p.category.toLowerCase().contains(_query.toLowerCase()) ||
        p.description.toLowerCase().contains(_query.toLowerCase()),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.isNotEmpty;
    final results = searchResults;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Header with Search Bar
          _buildSearchHeader(),

          // Content
          Expanded(
            child: hasQuery
                ? _buildResults(results)
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(
        20, MediaQuery.of(context).padding.top + 12, 20, 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Pesquisar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            autofocus: false,
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'O que você procura?',
              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary, size: 22),
              suffixIcon: _query.isNotEmpty
                  ? GestureDetector(
                onTap: () {
                  _controller.clear();
                  setState(() => _query = '');
                },
                child: const Icon(Icons.close_rounded, color: AppTheme.textHint, size: 18),
              )
                  : null,
            ),
          ),
          if (_query.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildFilterChips(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (_, i) {
          final f = _filterOptions[i];
          final selected = _selectedFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.divider,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          const Text(
            'Buscas Recentes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._recentSearches.map((s) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.history_rounded, size: 18, color: AppTheme.textSecondary),
            ),
            title: Text(s, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary)),
            trailing: const Icon(Icons.north_west_rounded, size: 14, color: AppTheme.textHint),
            onTap: () {
              _controller.text = s;
              setState(() => _query = s);
            },
          )),
          const SizedBox(height: 24),

          // Trending
          const Text(
            'Em Alta 🔥',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Camisas', 'Eletrônicos', 'Tênis', 'Livros',
              'Fones', 'Shorts', 'Monitor',
            ].map((tag) => GestureDetector(
              onTap: () {
                _controller.text = tag;
                setState(() => _query = tag);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 32),

          // All Categories
          const Text(
            'Explorar Categorias',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
            children: [
              _CategoryTile(emoji: '👕', label: 'Roupas', color: const Color(0xFF10B981)),
              _CategoryTile(emoji: '🖥️', label: 'Eletrônicos', color: const Color(0xFF3B82F6)),
              _CategoryTile(emoji: '👟', label: 'Calçados', color: const Color(0xFFEF4444)),
              _CategoryTile(emoji: '📚', label: 'Livros', color: const Color(0xFFF59E0B)),
              _CategoryTile(emoji: '🎧', label: 'Acessórios', color: const Color(0xFF8B5CF6)),
              _CategoryTile(emoji: '🏠', label: 'Casa', color: const Color(0xFFEC4899)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<Product> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado para\n"$_query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tente buscar por outra palavra',
              style: TextStyle(fontSize: 13, color: AppTheme.textHint),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
          child: Row(
            children: [
              Text(
                '${results.length} resultado${results.length > 1 ? 's' : ''} para "$_query"',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemCount: results.length,
            itemBuilder: (_, i) {
              final product = results[i];
              return ProductCard(
                product: product,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      product: product,
                      cartProvider: widget.cartProvider,
                    ),
                  ),
                ),
                onAddToCart: () {
                  widget.cartProvider.addProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} adicionado!'),
                      backgroundColor: AppTheme.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _CategoryTile({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
