import 'package:flutter/material.dart';
import '../temas/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _isLoggedIn ? _buildProfile() : _buildLogin(),
    );
  }

  Widget _buildLogin() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 40, 24, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ClickLoja',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Entre na sua conta',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Login Form
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Bem-vindo de volta!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Faça login para continuar comprando',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 28),

                // Email
                const Text(
                  'Seu email',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Digite seu email',
                    prefixIcon: Icon(Icons.email_outlined, size: 20, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                const Text(
                  'Sua senha',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppTheme.primary),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ),
                ),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(color: AppTheme.primary, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Login Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _handleLogin,
                    child: _loading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : const Text('Entrar'),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: AppTheme.divider)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ou continue com',
                        style: TextStyle(fontSize: 12, color: AppTheme.textHint),
                      ),
                    ),
                    Expanded(child: Divider(color: AppTheme.divider)),
                  ],
                ),
                const SizedBox(height: 20),

                // Social Buttons
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        icon: '🌐',
                        label: 'Google',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SocialButton(
                        icon: '📘',
                        label: 'Facebook',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta?',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Crie uma conta',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _loading = false;
      _isLoggedIn = true;
    });
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 20, 24, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: const Center(
                        child: Text('👤', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'João Silva',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'joao.silva@email.com',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatBadge(label: 'Pedidos', value: '12'),
                    _Divider(),
                    _StatBadge(label: 'Favoritos', value: '8'),
                    _Divider(),
                    _StatBadge(label: 'Avaliações', value: '5'),
                  ],
                ),
              ],
            ),
          ),

          // Menu Options
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Minha Conta',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _ProfileMenuItem(icon: Icons.shopping_bag_rounded, label: 'Meus Pedidos', color: AppTheme.primary),
                      _ProfileMenuItem(icon: Icons.favorite_rounded, label: 'Lista de Desejos', color: AppTheme.accent),
                      _ProfileMenuItem(icon: Icons.location_on_rounded, label: 'Endereços', color: AppTheme.success),
                      _ProfileMenuItem(icon: Icons.payment_rounded, label: 'Formas de Pagamento', color: const Color(0xFFF59E0B), hasBorder: false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Preferências',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _ProfileMenuItem(icon: Icons.notifications_rounded, label: 'Notificações', color: const Color(0xFF8B5CF6)),
                      _ProfileMenuItem(icon: Icons.shield_rounded, label: 'Privacidade e Segurança', color: AppTheme.success),
                      _ProfileMenuItem(icon: Icons.help_rounded, label: 'Ajuda e Suporte', color: const Color(0xFF3B82F6), hasBorder: false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _isLoggedIn = false),
                    icon: const Icon(Icons.logout_rounded, size: 18, color: AppTheme.error),
                    label: const Text(
                      'Sair da Conta',
                      style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.error, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withOpacity(0.2),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool hasBorder;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: hasBorder
            ? const Border(bottom: BorderSide(color: AppTheme.divider, width: 0.5))
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.textHint,
          size: 20,
        ),
        onTap: () {},
      ),
    );
  }
}
