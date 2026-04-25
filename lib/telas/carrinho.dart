import'package:flutter/material.dart';
import'../models/cart_provider.dart';
import'../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget{
  final CartProvider cartProvider;
  const CheckoutScreen({super.key, required this.cartProvider});
  @override
  State<CheckoutScreen> createState()=> _CheckoutScreenState();
}
class _CheckoutScreenState extends State<CheckoutScreen> {
final _formKey = GlobalKey<FormState>();
String _pagamentoSelecionado = 'Cartão de Crédito';
bool _pedidoConfirmado = false;
final _nomeController =TextEditingController();
final _cepController =TextEditingController();
final _ruaController =TextEditingController();
final _bairroController = TextEditingController();
final _cidadeController =TextEditingController();
final _ufController = TextEditingController();
final List<Map<String,dynamic>> _formasPagamento=[
{'label': 'Cartão de Crédito', 'icon': Icons.credit_card_rounded},
{'label': 'Cartão de Débito',  'icon': Icons.credit_card_outlined},
{'label': 'Pix',               'icon': Icons.qr_code_rounded},
{'label': 'Boleto',            'icon': Icons.receipt_long_rounded},
];

@override
void dispose(){
  _nomeController.dispose();
  _cepController.dispose();
  _ruaController.dispose();
  _bairroController.dispose();
  _cidadeController.dispose();
  _ufController.dispose();
 super.dispose();
}

void _confirmarPedido() {
  if (_formKey.currentState!.validate()) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  content: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  Container(
  width: 72,
  height: 72,
  decoration: BoxDecoration(
  color: AppTheme.success.withOpacity(0.1),
  shape: BoxShape.circle, // formato circular
  ),
  child: const Icon(Icons.check_rounded, color: AppTheme.success, size: 40),
  ),
  const SizedBox(height: 16),

  const Text(
  'Pedido Confirmado!',
  style: TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w800,
  color: AppTheme.textPrimary,
  ),
  textAlign: TextAlign.center,
  ),

  const SizedBox(height: 8),
  const Text(
  'Seu pedido foi realizado com sucesso e será enviado em breve.',
  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
  textAlign: TextAlign.center,
  ),
  const SizedBox(height: 20),
  SizedBox(
  width: double.infinity,
  height: 46,
  child: ElevatedButton(
  onPressed: () {
  widget.cartProvider.clear();
  Navigator.popUntil(context, (route) => route.isFirst);
  },
    child: const Text('Voltar ao início'),
  ),
  ),
  ],
  ),
        ),
    );
  }
}
@override
Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
      children: [
      _buildHeader(context),
  Expanded(
  child: Form(
  key: _formKey,
  child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

  _buildSectionTitle('Endereço de Entrega'),
  const SizedBox(height: 14),

  _buildCampo(
  controller: _nomeController,
  label: 'Nome completo',
  icon: Icons.person_outline_rounded,
  validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
  ),
  const SizedBox(height: 10),
  Row(
  children: [
  Expanded(
  flex: 2,
  child: _buildCampo(
  controller: _cepController,
  label: 'CEP',
  icon: Icons.location_on_outlined,
  keyboardType: TextInputType.number,
  validator: (v) => v!.length < 8 ? 'CEP inválido' : null,
  ),
  ),
  ],
  ),
  const SizedBox(height: 10),
  _buildCampo(
  controller: _ruaController,
  label: 'Rua e número',
  icon: Icons.home_outlined,
  validator: (v) => v!.isEmpty ? 'Informe o endereço' : null,
  ),
  const SizedBox(height: 10),
  _buildCampo(
  controller: _bairroController,
  label: 'Bairro',
  icon: Icons.map_outlined,
  validator: (v) => v!.isEmpty ? 'Informe o bairro' : null,
  ),
  const SizedBox(height: 10),
  Row(
  children: [
  Expanded(
  flex: 3,
  child: _buildCampo(
  controller: _cidadeController,
  label: 'Cidade',
  icon: Icons.location_city_outlined,
  validator: (v) => v!.isEmpty ? 'Informe a cidade' : null,
  ),
  ),
  const SizedBox(width: 10),
  Expanded(
  flex: 1, // UF ocupa 1 parte (menor)
  child: _buildCampo(
  controller: _ufController,
  label: 'UF',
  icon: null,
  maxLength: 2,
  validator: (v) => v!.length < 2 ? 'UF inválida' : null,
  ),
  ),
  ],
  ),
  const SizedBox(height: 24),
  _buildSectionTitle(' Forma de Pagamento'),
  const SizedBox(height: 14),
  ..._formasPagamento.map((forma) => _buildPagamentoOption(forma)),
  const SizedBox(height: 24),
  _buildResumo(),
  const SizedBox(height: 100),
  ],
  ),
  ),
  ),
  ),
  ],
  ),
    bottomNavigationBar: _buildBotaoConfirmar(),
  );
}
Widget _buildHeader(BuildContext context) {
  return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 16),
  child: Row(
  children: [
      GestureDetector(
      onTap: () => Navigator.pop(context),
  child: Container(
  width: 36,
  height: 36,
  decoration: BoxDecoration(
  color: AppTheme.surfaceVariant,
  borderRadius: BorderRadius.circular(10),
  ),
  child: const Icon(Icons.arrow_back_rounded, size: 18, color: AppTheme.textPrimary),
  ),
  ),
  const SizedBox(width: 12),

    const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          'Finalize seu pedido',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    ),
  ],
  ),
  );
}
Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppTheme.textPrimary,
    ),
  );
}
Widget _buildCampo({
required TextEditingController controller,
required String label,
  IconData? icon,
TextInputType keyboardType = TextInputType.text,
String? Function(String?)? validator,
int? maxLength,
}) {
  return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
  decoration: InputDecoration(
  labelText: label,
  counterText: '',
  labelStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
  prefixIcon: icon != null ? Icon(icon, size: 18, color: AppTheme.textHint) : null,
  filled: true,
  fillColor: AppTheme.surface,
  border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: AppTheme.divider),
  ),
  enabledBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: AppTheme.divider),
  ),
  focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
  ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.error),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  ),
  );
}
Widget _buildPagamentoOption(Map<String, dynamic> forma) {
  final selecionado = _pagamentoSelecionado == forma['label'];
  return GestureDetector(
      onTap: () => setState(() => _pagamentoSelecionado = forma['label']),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  decoration: BoxDecoration(
  color: selecionado ? AppTheme.primary.withOpacity(0.06) : AppTheme.surface,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
  color: selecionado ? AppTheme.primary : AppTheme.divider,
  width: selecionado ? 1.5 : 1, // borda mais grossa quando selecionado
  ),
  ),
  child: Row(
  children: [
  Icon(
  forma['icon'],
  size: 20,
  color: selecionado ? AppTheme.primary : AppTheme.textSecondary,
  ),
  const SizedBox(width: 12),
  Text(
  forma['label'],
  style: TextStyle(
  fontSize: 14,
  fontWeight: selecionado ? FontWeight.w700 : FontWeight.w500,
  color: selecionado ? AppTheme.primary : AppTheme.textPrimary,
  ),
  ),
  const Spacer(),

  if (selecionado)
  Container(
  width: 20,
  height: 20,
  decoration: const BoxDecoration(
  color: AppTheme.primary,
  shape: BoxShape.circle,
  ),
    child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
  ),
  ],
  ),
      ),
  );
}
Widget _buildResumo() {
  return Container(
      padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: AppTheme.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: AppTheme.divider),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Text(
  'Resumo do Pedido',
  style: TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: AppTheme.textPrimary,
  ),
  ),
  const SizedBox(height: 12),
  _ResumoRow(
  label: 'Subtotal',
  value: 'R\$ ${widget.cartProvider.subtotal.toStringAsFixed(2)}',
  ),
  const SizedBox(height: 6),
  _ResumoRow(
  label: 'Frete',
  value: widget.cartProvider.shipping == 0
  ? 'Grátis'
      : 'R\$ ${widget.cartProvider.shipping.toStringAsFixed(2)}',
  valueColor: widget.cartProvider.shipping == 0 ? AppTheme.success : null,
  ),

  const Divider(height: 20, color: AppTheme.divider),
    _ResumoRow(
      label: 'Total',
      value: 'R\$ ${widget.cartProvider.total.toStringAsFixed(2)}',
      isBold: true, // destaca o total com fonte maior e negrito
    ),
  ],
  ),
  );
}

Widget _buildBotaoConfirmar() {
  return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
  decoration: BoxDecoration(
  color: AppTheme.surface,
  boxShadow: [
  BoxShadow(
  color: AppTheme.cardShadow,
  blurRadius: 20,
  offset: const Offset(0, -4),
  ),
  ],
  ),
  child: SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
  onPressed: _confirmarPedido,
    child: const Text(
      'Confirmar Pedido ✓',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  ),
  ),
  );
}
}
class _ResumoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _ResumoRow({
  required this.label,
  required this.value,
  this.isBold = false,
  this.valueColor,

  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      Text(
      label,
      style: TextStyle(
        fontSize: isBold ? 15 : 13,
        fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
        color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
      ),
    ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 17 : 13,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
              color: valueColor ?? (isBold ? AppTheme.primary : AppTheme.textPrimary),
            ),
          ),
        ],
    );
  }
}
