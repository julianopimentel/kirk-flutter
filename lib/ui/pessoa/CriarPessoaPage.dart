import 'package:KirkDigital/model/person.dart';
import 'package:KirkDigital/provider/pessoa_provider.dart';
import 'package:KirkDigital/ui/componentes/custom_elevated_button.dart';
import 'package:KirkDigital/ui/componentes/email_field.dart';
import 'package:KirkDigital/ui/componentes/foto_field.dart';
import 'package:KirkDigital/ui/componentes/nome_field.dart';
import 'package:KirkDigital/ui/componentes/telefone_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../componentes/data_field.dart';
import '../componentes/dropdown_field.dart';

class CriarPersonPage extends StatefulWidget {
  const CriarPersonPage({super.key});

  @override
  createState() => _CriarPersonPageState();
}

class _CriarPersonPageState extends State<CriarPersonPage> {
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedImageFile;

  bool _acessoPlataforma = false;
  DateTime? _selectedDate;
  int _currentPage = 0;
  final int _currentTotal = 4;

  final List<DropdownItem> _genderItems = [
    DropdownItem(value: 'm', title: 'Masculino'),
    DropdownItem(value: 'f', title: 'Feminino'),
  ];
  DropdownItem? _selectedGenderItem;
  DropdownItem? _selectedRolesItem;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    PessoaProvider provider = context.read<PessoaProvider>();
    provider.getRoles();
    //valores iniciais
    _selectedGenderItem = _genderItems[0];
  }

  void _nextPage() {
    if (_pageController.page! < _currentTotal) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentPage += 1;
      });
    }
  }

  void _previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentPage -= 1;
      });
    }
  }

  bool _isFirstPage() {
    return _currentPage == 0;
  }

  bool _isLastPage() {
    return _currentPage == _currentTotal;
  }

  void _criarPessoa() {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    final String email = _emailController.text;

    if (name.isEmpty || _selectedRolesItem == null) {
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
      Pessoa newPessoa = Pessoa(
          name: name,
          phone: phone,
          email: email,
          birthAt: _selectedDate != null
              ? [_selectedDate!.year, _selectedDate!.month, _selectedDate!.day]
              : null,
          sex: _selectedGenderItem?.value,
          roles: _selectedRolesItem?.value,
          image: _selectedImageFile ?? '',
          createAccess: _acessoPlataforma
      );

      final PessoaProvider provider = context.read<PessoaProvider>();
      provider.create(newPessoa, context);
    }
  }

  void _onImageSelected(String base64ImageData) {
    setState(() {
      _selectedImageFile = base64ImageData;
    });
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
        title: const Text('Criar Pessoa'),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildBasicInfoPage(),
          _buildAdditionalInfoPage(),
          _buildPermissionsPage(provider),
          _buildImagePicture(),
          _buildFinishPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!_isFirstPage())
                ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  ),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              if (!_isLastPage())
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  ),
                  child: const Text(
                    'Avançar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return ListView(
      padding: const EdgeInsets.all(14.0),
      children: [
        const SizedBox(height: 20.0),
        const Center(
            child: Text(
          'Informações Básicas',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        )),
        const SizedBox(height: 50.0),
        NomeField(controller: _nameController, required: true),
        TelefoneField(controller: _phoneController),
        EmailField(controller: _emailController),
      ],
    );
  }

  Widget _buildAdditionalInfoPage() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20.0),
        const Center(
          child: Text(
            'Informações Adicionais',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 50.0),
        DataField(
          label: 'Data de Nascimento',
          selectedDate: _selectedDate,
          onDataSelect: _atualizarDataSelecionada,
        ),
        DropdownField(
          label: 'Gênero',
          selectedValue: _selectedGenderItem,
          items: _genderItems,
          onChanged: (DropdownItem? newValue) {
            setState(() {
              _selectedGenderItem = newValue ?? _selectedGenderItem;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPermissionsPage(PessoaProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20.0),
        const Center(
          child: Text(
            'Permissões',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 50.0),
        DropdownField(
          label: 'Grupo de Permissão',
          required: true,
          selectedValue: _selectedRolesItem,
          items: provider.rolesItems,
          onChanged: (DropdownItem? newValue) {
            setState(() {
              _selectedRolesItem = newValue ?? _selectedRolesItem;
            });
          },
        ),
        Row(
          children: [
            const Text(
              'Criar acesso à plataforma?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 7),
            Checkbox(
              value: _acessoPlataforma,
              onChanged: (value) {
                setState(() {
                  _acessoPlataforma = value ?? false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePicture() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20.0),
        const Center(
          child: Text(
            'Foto',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 50.0),
        FotoField(
          name: _nameController.text,
          imageUrl: _selectedImageFile,
          imageSize: 100.0,
          fontSize: 40.0,
          isEditable: true,
          selectedImageFilePath: _selectedImageFile,
          onImageSelected: (String? imagePath) {
            if (imagePath != null) {
              _onImageSelected(imagePath);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFinishPage() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20.0),
        const Center(
          child: Text(
            'Finalizar Cadastro',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 150.0),
        const Text(
          'Confira os dados e clique em "Salvar" para finalizar o cadastro.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30.0),
        CustomElevatedButton(onPressed: _criarPessoa, label: 'Salvar'),
        const SizedBox(height: 50.0),
      ],
    );
  }
}
