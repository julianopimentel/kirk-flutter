import 'package:KirkDigital/network/api_visitante.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


import '../model/visitante.dart'; // Importe a classe Visitor

class VisitorProvider with ChangeNotifier {
  List<Visitor> _visitors = []; // Uma lista para armazenar os visitantes
  bool _isLoading = false; // Inicialmente, definido como falso
  bool get isLoading => _isLoading;

  List<Visitor> get visitors => _visitors;

  // Método para listar visitantes
  Future<void> getList() async {
    try {
      _isLoading = true; // Define isLoading como verdadeiro ao iniciar a operação
      // Lógica para listar visitantes (provavelmente uma chamada à API)
      List<Visitor> responseData = await ApiVisitante.getList();

      // Agora, você pode iterar pelos dados e converter birthAt para o formato desejado
      List<Visitor> visitors = responseData.map((data) {
        dynamic birthAtData = data.birthAt.toString();
        String birthAtString;

        if (birthAtData is List<int> && birthAtData.length == 3) {
          int year = birthAtData[0];
          int month = birthAtData[1];
          int day = birthAtData[2];
          birthAtString = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        } else if (birthAtData is String) {
          // Se birthAtData já for uma string, não precisa fazer a conversão
          birthAtString = birthAtData;
        } else {
          // Lide com outros casos, se necessário
          birthAtString = 'Data de Nascimento Não Disponível';
        }

        // Agora, crie um objeto Visitor com birthAt ajustado
        return Visitor.fromJson(
          {
            'id': data.id,
            'name': data.name,
            'phone': data.phone,
            'email': data.email,
            'aniversario': birthAtString,
            'sex': data.sex,
            'birthAt': data.birthAt,
          },
        );
      }).toList();


      // Atualize _visitors com a lista de visitantes
      _visitors = visitors;

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

  // Método para criar um visitante
  Future<void> createVisitor(Visitor visitor) async {
    try {
      // Lógica para criar um visitante (provavelmente uma chamada à API)
      await ApiVisitante.createVisitor(visitor);

      // Adicione o visitante à lista _visitors
      _visitors.add(visitor);

      // Notifique os ouvintes (consumers)
      notifyListeners();
    } catch (error) {
      // Trate os erros, se necessário
      print("Erro ao buscar os dados: $error");
    }

    notifyListeners();
  }

  // Método para excluir um visitante
  Future<void> deleteVisitor(int id) async {
    try {
      // Lógica para excluir um visitante (provavelmente uma chamada à API)
      await ApiVisitante.deleteVisitor(id);

      // Remova o visitante da lista _visitors
      _visitors.removeWhere((visitor) => visitor.id == id);

      // Notifique os ouvintes (consumers)
      notifyListeners();
    } catch (error) {
      // Trate os erros, se necessário
      print("Erro ao buscar os dados: $error");
    }
    notifyListeners();
  }

}
