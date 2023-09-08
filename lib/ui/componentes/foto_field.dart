import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FotoField extends StatefulWidget {
  final String? imageUrl;
  final double imageSize;
  final String? name;
  final double? fontSize;
  final bool? isEditable;
  final void Function(String?)? onImageSelected; // Atualize a definição
  final String? selectedImageFilePath;

  FotoField({
    this.imageUrl,
    this.imageSize = 48.0,
    this.name,
    this.fontSize = 24.0,
    this.isEditable = false,
    this.selectedImageFilePath,
    this.onImageSelected,
  });

  @override
  _FotoFieldState createState() => _FotoFieldState();
}

class _FotoFieldState extends State<FotoField> {
  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null) {
      _imageData = _decodeBase64Image(widget.imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: ClipOval(
            child: _imageData != null
                ? Image.memory(
                    _imageData!,
                    width: widget.imageSize,
                    height: widget.imageSize,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: widget.imageSize,
                    height: widget.imageSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // Cor de fundo para o círculo
                    ),
                    child: Center(
                      child: Text(
                        widget.name != null && widget.name!.isNotEmpty
                            ? widget.name![0]
                            : '?',
                        style: TextStyle(
                          color: Colors.white, // Cor do texto
                          fontSize: widget.fontSize, // Tamanho da fonte
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        if (widget.isEditable!)
          SizedBox(height: 10.0), // Espaçamento entre o círculo e o botão
        if (widget.isEditable!)
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Alterar Foto'),
          ),
      ],
    );
  }

  // Função para decodificar a imagem a partir de uma string Base64
  Uint8List _decodeBase64Image(String base64String) {
    return Uint8List.fromList(base64.decode(base64String));
  }

  Future<void> _pickImage() async {
    if (!widget.isEditable!) {
      return;
    }

    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      final base64ImageData = base64Encode(imageBytes); // Converte para base64
      setState(() {
        widget.onImageSelected?.call(base64ImageData);
        _imageData = Uint8List.fromList(imageBytes);
      });
    }
  }

}
