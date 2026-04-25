import 'package:flutter/material.dart';

class AppTheme {
  // --- Cores da Marca (Brand Colors) ---
  // Definir cores como constantes estáticas facilita o acesso em qualquer lugar do app.
  static const Color primary = Color(0xFF6C3CE1);      // Roxo principal
  static const Color primaryDark = Color(0xFF4A1FA8);  // Tom mais escuro para gradientes ou estados
  static const Color primaryLight = Color(0xFF9B72FF); // Tom mais claro para destaques
  static const Color accent = Color(0xFFFF6B35);       // Laranja para botões de ação e chamadas
  static const Color accentLight = Color(0xFFFF8C5A);

  // --- Cores de Layout ---
  static const Color background = Color(0xFFF6F5FB);   // Fundo geral das telas (cinza muito claro)
  static const Color surface = Color(0xFFFFFFFF);      // Fundo de cards e menus (branco)
  static const Color surfaceVariant = Color(0xFFF0EDF9); // Variante para campos de input

  // --- Cores de Texto ---
  static const Color textPrimary = Color(0xFF1A1A2E);  // Títulos e textos principais
  static const Color textSecondary = Color(0xFF6B7280); // Descrições e textos menos importantes
  static const Color textHint = Color(0xFFB0B7C3);      // Textos de ajuda (placeholder) em inputs

  // --- Cores de Status ---
  static const Color success = Color(0xFF10B981);      // Mensagens positivas
  static const Color error = Color(0xFFEF4444);        // Alertas e erros
  static const Color warning = Color(0xFFF59E0B);      // Avisos

  // --- Elementos Decorativos ---
  static const Color divider = Color(0xFFE5E7EB);      // Linhas de separação
  static const Color cardShadow = Color(0x1A6C3CE1);   // Cor da sombra dos cards (com transparência)

  // Getter que constrói o objeto ThemeData completo para o Flutter
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true, // Ativa o design system mais moderno do Google

      // ColorScheme: Mapeia as cores principais para as propriedades padrão do Flutter
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        background: background,
        surface: surface,
      ),

      scaffoldBackgroundColor: background, // Cor padrão de fundo para cada Scaffold
      fontFamily: 'Roboto', // Define a fonte global do aplicativo

      // Estilo global para a AppBar (barra do topo)
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0, // Remove a sombra padrão da barra
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),

      // Estilo padrão para botões elevados (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // Botões levemente arredondados
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Estilo para campos de texto (TextField/TextFormField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant, // Cor de fundo do campo
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        // Define as bordas para diferentes estados (habilitado, focado, etc)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5), // Borda roxa ao clicar
        ),
        hintStyle: const TextStyle(color: textHint, fontSize: 14),
      ),

      // Estilo padrão para os Cards
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}