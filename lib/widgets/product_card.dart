import 'package:flutter/material.dart';
import '../modelos/product.dart';
import '../temas/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;       // Ação ao clicar no card (abrir detalhes)
  final VoidCallback? onAddToCart; // Ação ao clicar no botão "+"

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Área da Imagem do Produto (com selo de desconto e favorito)
            Stack(
              children: [
                // Fundo colorido com o Emoji do produto
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: product.color.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),

                // Selo de Desconto (Só aparece se o desconto for maior que 0)
                if (product.discountPercent > 0)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${product.discountPercent.toInt()}%',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),

                // Botão de Favorito (Estético neste exemplo)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)],
                    ),
                    child: const Icon(Icons.favorite_border_rounded, size: 16, color: AppTheme.textHint),
                  ),
                ),
              ],
            ),

            // Informações do Produto (Nome, Preço, Categoria)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w700),
                    maxLines: 2, // Limita o nome a duas linhas para não quebrar o layout
                    overflow: TextOverflow.ellipsis, // Adiciona "..." se o nome for muito grande
                  ),
                  const SizedBox(height: 6),

                  // Linha de Avaliação (Estrela e nota)
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 2),
                      Text('${product.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                      Text(' (${product.reviewCount})', style: const TextStyle(fontSize: 10, color: AppTheme.textHint)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Linha de Preço e Botão de Adicionar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Preço Original (Riscado) se houver desconto
                          if (product.originalPrice != null)
                            Text(
                              'R\$ ${product.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 10, color: AppTheme.textHint, decoration: TextDecoration.lineThrough),
                            ),
                          Text(
                            'R\$ ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 15, color: AppTheme.primary, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),

                      // Botão "+" circular
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}