import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../model/users_me.dart';
import '../../provider/account_provider.dart';
import '../../provider/pessoa_provider.dart';
import '../../utils/toastr_utils.dart';
import '../componentes/custom_campo_numerico_field.dart';
import '../componentes/custom_elevated_button.dart';
import '../componentes/data_field.dart';
import '../componentes/dropdown_field.dart';
import '../componentes/email_field.dart';
import '../componentes/nome_field.dart';
import '../componentes/telefone_field.dart';

class EnviarOfertaPage extends StatefulWidget {
  const EnviarOfertaPage({super.key});

  @override
  createState() => _EnviarOfertaPageState();
}

class _EnviarOfertaPageState extends State<EnviarOfertaPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  // Variáveis para armazenar a data de nascimento e o gênero selecionado
  DateTime? _selectedDate;

  // Lista de opções de gênero
  final List<DropdownItem> _tipomovimentacaoItems = [
    DropdownItem(value: 'o', title: 'Oferta'),
    DropdownItem(value: 'd', title: 'Dizimo'),
  ];

  DropdownItem? _selectedGenderItem;
  int _currentStep = 0;
  final String _pixCopiaCola = '00020126360014br.gov.bcb.pix0114+559299222840052040000530398654040.025802BR5925Juliano Pimentel Pinheiro6009Sao Paulo62070503***6304866E';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Acesse o provider e chame o método para listar os grupos de permissão
    PessoaProvider provider = context.read<PessoaProvider>();
    provider.getRoles();
    AccountProvider accountProvider = context.read<AccountProvider>();
    UsersMe me = accountProvider.getMe();
    _nameController.text = me.name ?? '';
    _phoneController.text = me.phone ?? '';
    _emailController.text = me.email ?? '';
  }

  // Função para avançar para a próxima etapa
  void _nextStep() {
    setState(() {
      _currentStep += 1;
    });
  }

  // Função para voltar para a etapa anterior
  void _previousStep() {
    setState(() {
      _currentStep -= 1;
    });
  }

  bool _isFirstStep() {
    return _currentStep == 0;
  }

  bool _isLastStep() {
    return _currentStep == 4;
  }

  void _enviarOferta() {
    final String name = _nameController.text;
    //final String phone = _phoneController.text;
    //final String email = _emailController.text;

    //convertendo a data para o formato yyyy-01-01

    if (name.isEmpty) {
      // Validação simples para garantir que ambos os campos sejam preenchidos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro de validação'),
            content: const Text('Por favor, preencha todos os campos obrigatórios.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Acesse o provider e chame o método para criar um visitante
      //provider.create(newPessoa, context);
    }
  }

  void _atualizarDataSelecionada(DateTime novaData) {
    setState(() {
      _selectedDate = novaData;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<PessoaProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envio de Ofertas e Dizimos'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _isLastStep() ? null : _nextStep,
        onStepCancel: _isFirstStep() ? null : _previousStep,
        steps: [
          Step(
            title: const Text('Informações Básicas'),
            content: _buildBasicInfoStep(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Tipo de Movimentação'),
            content: _buildPermissionsStep(provider),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Informações de Pagamento'),
            content: _buildAdditionalInfoStep(),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Transferência PIX'),
            content: _buildPixfoStep(),
            isActive: _currentStep >= 3,
          ),
          Step(
            title: const Text('Confirmação'),
            content: _buildFinishStep(),

          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(
      children: [
        NomeField(controller: _nameController, enabled: true),
        TelefoneField(controller: _phoneController, enabled: true),
        EmailField(controller: _emailController, enabled: true),
      ],
    );
  }

  Widget _buildAdditionalInfoStep() {
    return Column(
      children: [
        Text(
          'Para realizar o pagamento, por favor, informe a data de pagamento, informe o valor e realize a leitura do QR Code para transferir o valor via PIX.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        DataField(
          label: 'Data de Pagamento',
          selectedDate: _selectedDate,
          onDataSelect: _atualizarDataSelecionada,
        ),
        CustomCampoNumericoField(
          label: 'Valor',
          controller: _valorController,
        ),
      ],
    );
  }



  Widget _buildPermissionsStep(PessoaProvider provider) {
    return Column(
      children: [
        DropdownField(
          label: 'Tipo de Movimentação',
          selectedValue: _selectedGenderItem ?? _tipomovimentacaoItems[0],
          items: _tipomovimentacaoItems,
          onChanged: (DropdownItem? newValue) {
            setState(() {
              _selectedGenderItem = newValue ?? _selectedGenderItem;
            });
          },
        ),
      ],
    );
  }


  Widget _buildPixfoStep(){
    return Column(
      children: [
        Text(
          'Para realizar o pagamento, por favor, realize a leitura do QR Code para transferir o valor via PIX.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        // Widget para exibir o QR Code
        _buildQRCode(),
        const SizedBox(height: 20),
        // Copiar o valor do PIX
        Text(
          'Copie e cole o valor do PIX abaixo para realizar a transferência.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        SelectableText(
          _pixCopiaCola,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _pixCopiaCola));
            // O valor do PIX foi copiado para a área de transferência.
            // Exiba uma mensagem para o usuário.
            NotificationUtils.showSuccess(context,
                'Valor do PIX copiado para a área de transferência.');
          },
          child: const Text('Copiar PIX'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }


  Widget _buildFinishStep() {
    return _currentStep == 4
        ? Column(
            children: [
              Text(
                'Obrigado por enviar sua oferta ou dizimo.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              Text(
                'Clique em finalizar para concluir o envio.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _enviarOferta,
                label: 'Finalizar',
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildQRCode() {
    // Substitua _pixCopiaCola pelo valor do seu PIX copiado e colado
    final String pixData = _pixCopiaCola;
    return QrImageView(
      data: pixData,
      version: QrVersions.auto,
      size: 200.0,
    );
  }


}
