import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/person.dart';
import '../model/roles.dart';
import '../model/simples_pessoa_dto.dart';
import '../network/api_person.dart';
import '../network/api_roles.dart';
import '../ui/componentes/dropdown_field.dart';
import '../utils/toastr_utils.dart';

class PessoaProvider with ChangeNotifier {
  List<SimplesPessoaDto> _pessoaDto = []; // Uma lista para armazenar os visitantes
  Pessoa _pessoaById = Pessoa(); // Uma variável para armazenar os detalhes do visitante

  bool _isLoading = false; // Inicialmente, definido como falso
  bool get isLoading => _isLoading;
  List<DropdownItem> rolesItems = []; // Defina a lista de DropdownItem aqui

  List<SimplesPessoaDto> get pessoas => _pessoaDto;
  List<DropdownItem> get roles => rolesItems;

  Pessoa get pessoaById => _pessoaById;

  // Método para listar visitantes
  Future<void> getList() async {
    try {
      _isLoading = true; // Define isLoading como verdadeiro ao iniciar a operação
      // Lógica para listar visitantes (provavelmente uma chamada à API)
      List<SimplesPessoaDto> responseData = await ApiPerson.getList();

      // Atualize _visitors com a lista de visitantes
      _pessoaDto = responseData;

      // Notifique os ouvintes (consumers)
      notifyListeners();
      // Retorne a lista de visitantes
      _isLoading = false; // Define isLoading como falso ao concluir a operação com sucesso
    } catch (error) {
      _isLoading = false; // Define isLoading como falso ao ocorrer um erro
      notifyListeners();
      // Trate os erros, se necessário
      print("Erro ao buscar os dados: $error");
    }
  }

// Método para criar pessoa
  Future<void> create(Pessoa pessoa, BuildContext context) async {
    try {
      _isLoading = true; // Define isLoading como verdadeiro ao iniciar a operação
      await ApiPerson.create(pessoa);
      // GetList para atualizar a lista de pessoas
      await getList();

      // Notifique os ouvintes (consumers)
      _isLoading = false; // Define isLoading como falso ao concluir a operação com sucesso
      notifyListeners();

      Navigator.of(context).pop(); // Feche o diálogo

      NotificationUtils.showSuccess(context, 'Pessoa criada com sucesso');
      // Retorne a lista de visitantes
    } catch (error) {
      _isLoading = false; // Define isLoading como falso ao ocorrer um erro
      //notifyListeners();
      // Trate os erros, se necessário
      //print("Erro ao buscar os dados: $error");
      //NotificationUtils.showError('Ocorreu um erro ao criar a pessoa ${error}');
    }
  }
  // Método para buscar pessoa
  Future<Pessoa?> getById(int id) async {
    try {
      _isLoading = true; // Define isLoading como verdadeiro ao iniciar a operação
      // Lógica para buscar pessoa (provavelmente uma chamada à API)
      Pessoa responseData = await ApiPerson.getById(id);

      // Atualize _pessoaById com os detalhes da pessoa
      _pessoaById = responseData;

      // Notifique os ouvintes (consumers)
      _isLoading = false; // Define isLoading como falso ao concluir a operação com sucesso
      notifyListeners();

      return _pessoaById;
      // Retorne a lista de visitantes
    } catch (error) {
      _isLoading = false; // Define isLoading como falso ao ocorrer um erro
      if (kDebugMode) {
        print("Erro ao buscar os dados: $error");
      }
      //notifyListeners();
      return null;
    }
  }

  // Método para atualizar pessoa
  Future<void> update(Pessoa pessoa, BuildContext context) async {
    try {
      _isLoading = true; // Define isLoading como verdadeiro ao iniciar a operação
      // Lógica para atualizar pessoa (provavelmente uma chamada à API)
      await ApiPerson.update(pessoa);

      // GetList para atualizar a lista de pessoas
      await getList();

      // Notifique os ouvintes (consumers)
      _isLoading = false; // Define isLoading como falso ao concluir a operação com sucesso
      notifyListeners();

      Navigator.of(context).pop(); // Feche o diálogo

      NotificationUtils.showSuccess(context, 'Pessoa atualizada com sucesso');
      // Retorne a lista de visitantes
    } catch (error) {
      _isLoading = false; // Define isLoading como falso ao ocorrer um erro
      //notifyListeners();
      // Trate os erros, se necessário
      if (kDebugMode) {
        print("Erro ao buscar os dados: $error");
      }
      //NotificationUtils.showError('Ocorreu um erro ao atualizar a pessoa ${error}');
    }
  }

  // Método para excluir pessoa
  Future<void> delete(int id, BuildContext context) async {
    try {
      _isLoading = true; // Define isLoading como verdadeiro ao iniciar a operação
      // Lógica para excluir pessoa (provavelmente uma chamada à API)
      await ApiPerson.delete(id);

      // GetList para atualizar a lista de pessoas
      await getList();

      // Notifique os ouvintes (consumers)
      _isLoading = false;
      notifyListeners();

      NotificationUtils.showSuccess(context, 'Pessoa excluída com sucesso');
      // Retorne a lista de visitantes
    } catch (error) {
      _isLoading = false; // Define isLoading como falso ao ocorrer um erro
      //NotificationUtils.showError('Ocorreu um erro ao excluir a pessoa ${error}');
    }
  }

  // Método para consultar as permissões de acesso
  Future<void> getRoles() async {
    try {
      // Lógica para listar visitantes (provavelmente uma chamada à API)
      List<RolesDto> response = await ApiRoles.getList();
      // Suponha que você tenha obtido a resposta da API e armazenado em uma variável chamada 'response'
      List<Map<String, dynamic>> responseData = response.map((role) {
        return {
          'id': role.id,
          'name': role.name,
        };
      }).toList();

      // Crie uma lista de DropdownItem a partir dos dados da API
      rolesItems = responseData.map((roleData) {
        return DropdownItem(
          value: roleData['id'].toString(),
          title: roleData['name'],
        );
      }).toList();
      // Notifique os ouvintes (consumers)
      notifyListeners();
      // Retorne a lista de visitantes
    } catch (error) {
      // Trate os erros, se necessário
      if (kDebugMode) {
        print("Erro ao buscar os dados: $error");
      }
      //NotificationUtils.showError(context, 'Ocorreu um erro ao buscar as permissões de acesso ${error}');
    }
  }

}
