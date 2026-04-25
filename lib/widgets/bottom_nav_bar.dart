import 'package:flutter/material.dart';
import '../temas/app_theme.dart';
import '../modelos/cart_provider.dart';

class ClickLojaBottomNav extends StatelessWidget {
  final int currentIndex;       // Índice da aba selecionada (0 a 3)
  final Function(int) onTap;    // Função que avisa ao MainNavigator que o usuário clicou
  final CartProvider cartProvider; // Provider para ler a quantidade de itens no carrinho

  const ClickLojaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Decoração da barra: Fundo branco com uma sombra sutil para cima
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, -4), // Sombra projetada para cima
          ),
        ],
      ),
      child: SafeArea(
        // SafeArea: Garante que a barra não fique embaixo do "Home Indicator" (barra de gestos) do iPhone/Android
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribui os ícones uniformemente
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Início',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.search_rounded,
                label: 'Pesquisar',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              // Item especial: O Carrinho precisa mostrar o contador de itens
              _CartNavItem(
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
                count: cartProvider.itemCount,
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Perfil',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget privado para itens comuns (Início, Busca, Perfil)
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Melhora a área de clique
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Suaviza a mudança de cor
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          // Fica levemente roxo quando está selecionado
          color: isActive ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ocupa o mínimo de espaço vertical
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primary : AppTheme.textHint,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppTheme.primary : AppTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget privado exclusivo para o Carrinho (inclui o Badge/Contador)
class _CartNavItem extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  final int count;

  const _CartNavItem({required this.isActive, required this.onTap, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stack: Usado para colocar o número em cima do ícone do carrinho
            Stack(
              clipBehavior: Clip.none, // Permite que o número "escape" dos limites do ícone
              children: [
                Icon(
                  Icons.shopping_cart_rounded,
                  color: isActive ? AppTheme.primary : AppTheme.textHint,
                  size: 24,
                ),
                // Só mostra o círculo se houver itens no carrinho
                if (count > 0)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppTheme.accent, // Laranja de destaque
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$count',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Carrinho',
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppTheme.primary : AppTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}