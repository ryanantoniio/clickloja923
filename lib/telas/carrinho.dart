// Importa os componentes visuais do Flutter (botões, textos, ícones, layouts, etc.)
import 'package:flutter/material.dart';

// Importa o CartProvider — classe que gerencia os dados do carrinho (itens, total, frete)
import '../modelos/cart_provider.dart';

// Importa o tema visual do app com todas as cores personalizadas
import '../temas/app_theme.dart';

// Importa a tela de checkout para fazer a navegação ao clicar em "Finalizar Pedido"
import 'checkout.dart';

// ─────────────────────────────────────────────
// CartScreen é um StatelessWidget porque
// ela não guarda estado próprio — quem avisa
// quando o carrinho muda é o CartProvider
// ─────────────────────────────────────────────
class CartScreen extends StatelessWidget {
  // Recebe o carrinho como parâmetro obrigatório para ler os itens e valores
  final CartProvider cartProvider;

  // Construtor: super.key é boas práticas no Flutter 3+
  const CartScreen({super.key, required this.cartProvider});

  // ─────────────────────────────────────────────
  // build(): monta a tela visualmente
  // É chamado toda vez que o Flutter precisa
  // redesenhar esse widget
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background, // cor de fundo da tela inteira
      body: ListenableBuilder(
        // ListenableBuilder "escuta" o cartProvider
        // Toda vez que o carrinho mudar (adicionar/remover item),
        // ele reconstrói automaticamente o conteúdo da tela
        listenable: cartProvider,
        builder: (context, _) {
          // Pega a lista atual de itens do carrinho
          final items = cartProvider.items;

          return Column(
            children: [
              // Cabeçalho da tela com ícone, título e botão "Limpar"
              _buildHeader(context),

              // Expanded faz o conteúdo do meio ocupar todo o espaço disponível
              Expanded(
                // Se o carrinho estiver vazio, mostra tela vazia
                // Se tiver itens, mostra a lista de produtos
                child: items.isEmpty ? _buildEmpty() : _buildCartList(context, items),
              ),

              // A barra de checkout (total + botão) só aparece se houver itens
              if (items.isNotEmpty) _buildCheckoutBar(context),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // _buildHeader(): constrói o cabeçalho da tela
  // com ícone de sacola, título, contagem de itens
  // e botão "Limpar" (aparece só se houver itens)
  // ─────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppTheme.surface, // fundo branco/claro do header
      // Padding com espaço extra no topo para não ficar atrás da barra de status do celular
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 16),
      child: Row(
        children: [
          // Ícone de sacola com gradiente de cor
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              // Gradiente da cor primária para a cor primária clara
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryLight],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10), // espaço horizontal de 10px

          // Coluna com título e quantidade de itens
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // alinha texto à esquerda
            children: [
              // Título principal da tela
              const Text(
                'Meu Carrinho',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              // Subtítulo dinâmico: "1 item" ou "3 itens"
              // O operador ternário (? :) escolhe entre "s" ou "" no plural
              Text(
                '${cartProvider.itemCount} item${cartProvider.itemCount != 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),

          // Spacer empurra o botão "Limpar" para o lado direito
          const Spacer(),

          // Botão "Limpar" — só é exibido se houver itens no carrinho
          if (cartProvider.items.isNotEmpty)
            TextButton(
              onPressed: () => cartProvider.clear(), // remove todos os itens
              child: const Text(
                'Limpar',
                style: TextStyle(color: AppTheme.error, fontSize: 13), // texto vermelho
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // _buildEmpty(): tela exibida quando o carrinho
  // não tem nenhum item
  // ─────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      // Centraliza tudo no meio da tela
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // centraliza verticalmente
        children: const [
          // Emoji de carrinho bem grande
          Text('🛒', style: TextStyle(fontSize: 70)),
          SizedBox(height: 20),

          // Mensagem principal
          Text(
            'Seu carrinho está vazio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),

          // Mensagem secundária incentivando o usuário a adicionar produtos
          Text(
            'Adicione produtos para começar!',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // _buildCartList(): lista rolável com todos
  // os itens que estão no carrinho
  // ─────────────────────────────────────────────
  Widget _buildCartList(BuildContext context, List items) {
    return ListView.builder(
      // Espaçamento interno da lista (esquerda, topo, direita, baixo)
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      itemCount: items.length, // quantidade de cards a exibir
      itemBuilder: (_, i) {
        // Pega o item da posição "i" na lista
        final item = items[i];

        // Retorna o card visual de cada produto no carrinho
        return _CartItemCard(
          item: item,
          // Callback: ao tocar no lixo, remove o produto pelo ID
          onRemove: () => cartProvider.removeProduct(item.product.id),
          // Callback: ao tocar em "-", diminui a quantidade em 1
          onDecrement: () => cartProvider.updateQuantity(item.product.id, item.quantity - 1),
          // Callback: ao tocar em "+", aumenta a quantidade em 1
          onIncrement: () => cartProvider.updateQuantity(item.product.id, item.quantity + 1),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // _buildCheckoutBar(): barra fixa no rodapé
  // com cupom, subtotal, frete, total e botão
  // de finalizar pedido
  // ─────────────────────────────────────────────
  Widget _buildCheckoutBar(BuildContext context) {
    return Container(
      // Padding com espaço extra embaixo para não ficar atrás da barra de navegação do celular
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppTheme.surface, // fundo branco/claro
        // Sombra para dar sensação de que a barra "flutua" sobre a lista
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, -4), // sombra projetada para cima
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ocupa só o espaço necessário (não expande)
        children: [

          // ── Campo de cupom de desconto ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant, // fundo levemente acinzentado
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.divider), // borda cinza fina
            ),
            child: Row(
              children: const [
                // Ícone de etiqueta (tag)
                Icon(Icons.local_offer_rounded, size: 18, color: AppTheme.primary),
                SizedBox(width: 10),
                // Texto do cupom — Expanded faz o texto não transbordar
                Expanded(
                  child: Text(
                    'Adicionar cupom de desconto',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ),
                // Seta indicando que é clicável
                Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textHint),
              ],
            ),
          ),
          const SizedBox(height: 14), // espaço entre o cupom e os totais

          // ── Linha do Subtotal ──
          // toStringAsFixed(2) formata o número com 2 casas decimais (ex: 149.90)
          _TotalRow(label: 'Subtotal', value: 'R\$ ${cartProvider.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 6),

          // ── Linha do Frete ──
          // Se shipping == 0, mostra "Grátis 🎉", senão mostra o valor
          _TotalRow(
            label: 'Frete',
            value: cartProvider.shipping == 0
                ? 'Grátis 🎉'
                : 'R\$ ${cartProvider.shipping.toStringAsFixed(2)}',
            // Cor verde quando o frete for grátis
            valueColor: cartProvider.shipping == 0 ? AppTheme.success : null,
          ),

          // Aviso de frete grátis — só aparece se houver cobrança de frete
          if (cartProvider.shipping > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Frete grátis acima de R\$ 200,00',
                style: const TextStyle(fontSize: 11, color: AppTheme.textHint),
              ),
            ),

          // Linha divisória entre frete e total
          const Divider(height: 20, color: AppTheme.divider),

          // ── Linha do Total (em destaque) ──
          _TotalRow(
            label: 'Total',
            value: 'R\$ ${cartProvider.total.toStringAsFixed(2)}',
            isBold: true, // deixa o total em negrito e maior
          ),
          const SizedBox(height: 14),

          // ── Botão Finalizar Pedido ──
          SizedBox(
            width: double.infinity, // ocupa toda a largura da tela
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                // MaterialPageRoute cria a animação padrão de navegar para nova tela
                MaterialPageRoute(
                  // Passa o cartProvider para o CheckoutScreen usar os valores
                  builder: (_) => CheckoutScreen(cartProvider: cartProvider),
                ),
              ),
              child: const Text('Finalizar Pedido →'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// _CartItemCard: widget que representa visualmente
// um único produto dentro do carrinho
// Recebe o item e 3 callbacks de ação
// ─────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final dynamic item;          // dados do item (produto + quantidade)
  final VoidCallback onRemove;   // função chamada ao tocar no ícone de lixo
  final VoidCallback onDecrement; // função chamada ao tocar no botão "-"
  final VoidCallback onIncrement; // função chamada ao tocar no botão "+"

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // espaço entre os cards
      padding: const EdgeInsets.all(14),         // espaço interno do card
      decoration: BoxDecoration(
        color: AppTheme.surface,                 // fundo branco/claro
        borderRadius: BorderRadius.circular(16), // bordas arredondadas
        // Sombra suave para dar profundidade ao card
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2), // sombra para baixo
          ),
        ],
      ),
      child: Row(
        children: [

          // ── Imagem/Emoji do produto ──
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              // Fundo com a cor do produto em 12% de opacidade (bem suave)
              color: item.product.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              // Exibe o emoji que representa o produto (ex: 👟, 👕)
              child: Text(item.product.emoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 14), // espaço entre imagem e texto

          // ── Informações do produto (nome, categoria, preço, quantidade) ──
          Expanded(
            // Expanded faz essa coluna ocupar o máximo de espaço horizontal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Nome do produto — trunca com "..." se for muito longo
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,                        // máximo 2 linhas
                  overflow: TextOverflow.ellipsis,    // coloca "..." no final se ultrapassar
                ),
                const SizedBox(height: 4),

                // Categoria do produto (ex: "Calçados", "Vestuário")
                Text(
                  item.product.category,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    // Preço unitário do produto em destaque
                    Text(
                      'R\$ ${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary, // cor primária para destaque
                      ),
                    ),

                    // Spacer empurra os controles de quantidade para a direita
                    const Spacer(),

                    // ── Controles de quantidade: [ - ] número [ + ] ──
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant, // fundo acinzentado
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // ocupa só o espaço dos filhos
                        children: [

                          // Botão de diminuir quantidade
                          GestureDetector(
                            onTap: onDecrement, // chama a função passada pelo pai
                            child: Container(
                              width: 30,
                              height: 30,
                              // Área de toque de 30x30px para facilitar o clique
                              child: const Icon(Icons.remove_rounded, size: 16, color: AppTheme.primary),
                            ),
                          ),

                          // Número atual da quantidade
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),

                          // Botão de aumentar quantidade
                          GestureDetector(
                            onTap: onIncrement, // chama a função passada pelo pai
                            child: Container(
                              width: 30,
                              height: 30,
                              child: const Icon(Icons.add_rounded, size: 16, color: AppTheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8), // espaço entre informações e botão de remover

          // ── Botão de remover o item do carrinho ──
          GestureDetector(
            onTap: onRemove, // chama a função de remoção passada pelo pai
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1), // fundo vermelho bem suave
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline_rounded, size: 16, color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// _TotalRow: widget reutilizável para exibir
// uma linha com label à esquerda e valor à direita
// Usado no rodapé para Subtotal, Frete e Total
// ─────────────────────────────────────────────
class _TotalRow extends StatelessWidget {
  final String label;       // texto do lado esquerdo (ex: "Subtotal")
  final String value;       // texto do lado direito (ex: "R$ 149,90")
  final bool isBold;        // se true, usa fonte maior e negrito
  final Color? valueColor;  // cor opcional para o valor (ex: verde para "Grátis")

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,  // padrão: sem negrito
    this.valueColor,      // padrão: null (usa a cor padrão)
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // SpaceBetween coloca o label na esquerda e o valor na direita
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // Label (ex: "Total", "Frete", "Subtotal")
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,          // total é maior que subtotal/frete
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),

        // Valor (ex: "R$ 349,70", "Grátis 🎉")
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
            // Ordem de prioridade da cor:
            // 1º valueColor (se passado) → 2º primary se isBold → 3º cor padrão
            color: valueColor ?? (isBold ? AppTheme.primary : AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}
