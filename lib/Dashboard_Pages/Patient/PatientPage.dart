import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];
  final TextEditingController _textController = TextEditingController();

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
    "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "AarogyaBoT",
          style: TextStyle(color: Colors.black), // Black title text
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade700, // Lighter green
                Colors.teal.shade900,       // Darker teal
              ],// Example gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.teal.shade900], // Gradient from lighter to darker green
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isCurrentUser = message.user.id == currentUser.id;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.blueGrey.shade100 : Colors.teal.shade500,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrentUser ? Colors.black87 : Colors.black,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isCurrentUser ? Colors.black : Colors.black,
                        fontSize: 16, // Increase text size
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.white),
            onPressed: _sendMediaMessage,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 16), // Increase hint text size
                filled: true,
                fillColor: Colors.green.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 16), // Increase input text size
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _handleSendMessage,
          ),
        ],
      ),
    );
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: text,
      );
      _sendMessage(chatMessage);
      _textController.clear();
    }
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini.streamGenerateContent(
        question,
        images: images,
      ).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
            "",
                (previous, current) => "$previous ${current.text}",
          ) ?? "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
            "",
                (previous, current) => "$previous ${current.text}",
          ) ?? "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
