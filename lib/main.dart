import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'temas/app_theme.dart';
import 'modelos/cart_provider.dart';
import 'telas/home_screen.dart';
// import 'telas/search_screen.dart'; enquanto guilherme coloca a parte dele
import 'telas/carrinho.dart';
// import 'telas/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  // Garante que os serviços do Flutter estejam prontos antes de executar o app
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração da barra de status do celular (hora, bateria, etc)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Deixa a barra transparente
      statusBarIconBrightness: Brightness.dark, // Ícones escuros para fundos claros
    ),
  );

  runApp(const ClickLojaApp());
}

// O Root (Raiz) do aplicativo
class ClickLojaApp extends StatelessWidget {
  const ClickLojaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickLoja',
      debugShowCheckedModeBanner: false, // Remove a faixa de "Debug" do canto da tela
      theme: AppTheme.theme, // Aplica o tema personalizado definido em outro arquivo
      home: const MainNavigator(), // Define qual será a primeira tela ao abrir
    );
  }
}

// Widget que controla a navegação entre as abas (BottomNavigationBar)
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  // Controla qual aba está selecionada atualmente
  int _currentIndex = 0;

  // Instância única do gerenciador de carrinho para todo o app
  final CartProvider _cartProvider = CartProvider();

  // Lista de telas que serão exibidas nas abas
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Escuta mudanças no carrinho (ex: se um item for adicionado em outra tela, esta tela reconstrói)
    _cartProvider.addListener(_onCartChanged);

    // Inicializa a lista de telas passando o provider necessário para elas
    _screens = [
      HomeScreen(cartProvider: _cartProvider),
      // SearchScreen(cartProvider: _cartProvider),
      // CartScreen(cartProvider: _cartProvider),
      // const ProfileScreen(),
    ];
  }

  // Função disparada sempre que o Carrinho muda (ex: adicionou produto)
  void _onCartChanged() {
    setState(() {}); // Força a atualização da interface (importante para atualizar o ícone do carrinho)
  }

  @override
  void dispose() {
    // Limpeza de memória: remove o listener e fecha o provider ao fechar o app
    _cartProvider.removeListener(_onCartChanged);
    _cartProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack: Mantém todas as telas "vivas" na memória.
      // Ao trocar de aba, o usuário não perde o scroll ou o estado da tela anterior.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Barra de navegação customizada (no rodapé)
      bottomNavigationBar: ClickLojaBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i), // Atualiza o índice ao clicar
        cartProvider: _cartProvider,
      ),
    );
  }
}