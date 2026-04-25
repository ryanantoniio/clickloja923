import 'package:flutter/material.dart';
import '../modelos/product.dart';
import '../modelos/cart_provider.dart';
import '../temas/app_theme.dart';
import '../widgets/product_card.dart';
import 'detalhe_produto.dart';

class HomeScreen extends StatefulWidget {
  final CartProvider cartProvider; // Recebe o provider para gerenciar o carrinho globalmente

  const HomeScreen({super.key, required this.cartProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Estado local para controlar qual categoria está selecionada
  String _selectedCategory = 'Tudo';

  // Lógica de filtragem: computada toda vez que o estado muda
  List<Product> get filteredProducts {
    if (_selectedCategory == 'Tudo') return sampleProducts;
    return sampleProducts.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      // CustomScrollView permite misturar diferentes tipos de listas e componentes com scroll único
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter: transforma um widget comum em um "membro" do scroll do Sliver
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),

          SliverToBoxAdapter(
            child: _buildBanner(),
          ),

          SliverToBoxAdapter(
            child: _buildCategories(),
          ),

          // Seção de título antes da grade
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Produtos em Destaque',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Ver todos')),
                ],
              ),
            ),
          ),

          // SliverGrid: Grade de produtos otimizada para performance
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _openProduct(product), // Navegação para detalhes
                    onAddToCart: () {
                      // Ação de adicionar ao carrinho usando o provider recebido
                      widget.cartProvider.addProduct(product);
                      // Feedback visual (Snackbar)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} adicionado!'),
                          backgroundColor: AppTheme.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
                childCount: filteredProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 colunas
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.62, // Controla a altura proporcional do card
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função de Navegação: Passa o produto selecionado e o cartProvider adiante
  void _openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          cartProvider: widget.cartProvider,
        ),
      ),
    );
  }

  // Widget do Cabeçalho: Logo e notificações
  Widget _buildHeader() {
    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 16),
      child: Row(
        children: [
          // Logo estilizada com Container e Icon
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryLight]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ClickLoja', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              Text('Bem-vindo de volta! 👋', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
          const Spacer(),
          // Botão de notificação (apenas visual neste exemplo)
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.notifications_rounded, size: 20, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  // Widget do Banner: Usa Stack para posicionar círculos decorativos atrás do texto
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decoração: Círculo vazado à direita
          Positioned(
            right: -10, bottom: -20,
            child: Container(width: 150, height: 150, decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), shape: BoxShape.circle)),
          ),
          // Conteúdo do Banner
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(20)),
                  child: const Text('OFERTA ESPECIAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 8),
                const Text('Até 50% OFF', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget de Categorias: Lista horizontal que altera o estado local
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat), // Atualiza a tela ao clicar
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.divider),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppTheme.textSecondary),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}