import 'package:anestesia/auth/auth_service.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();

  void logOut() {
    final _auth = AuthService();
    _auth.signOut();
  }
}

class _ChatbotPageState extends State<ChatbotPage> {
  final Gemini gemini = Gemini.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<ChatMessage> messages = [];
  bool _isTyping = false;

  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser bot = ChatUser(
    id: '1',
    firstName: 'Samael',
    profileImage: 'https://f4.bcbits.com/img/a1648185659_16.jpg',
  );

  @override
  void initState() {
    super.initState();
    // Load existing history, then ensure a welcome message is shown.
    _loadMessages().then((_) => _ensureWelcome());
  }

  // Ensure the bot sends a welcome message when the chat opens.
  void _ensureWelcome() async {
    const welcomeText = 'Saludos. Soy Samael. Hablemos exclusivamente sobre el videojuego de terror psicológico "Amnesia" — pregunta sobre su mundo, sus puzzles y su atmósfera.';

    // If there are no messages, or the latest message isn't this welcome, insert it.
    if (messages.isEmpty || messages.first.text != welcomeText) {
      final botMessage = ChatMessage(
        user: bot,
        createdAt: DateTime.now(),
        text: welcomeText,
      );

      setState(() {
        messages = [botMessage, ...messages];
      });

      // Persist the welcome message so it appears in history (optional).
      await _saveMessage(botMessage);
    }
  }

  Future<void> _loadMessages() async {
    final user = auth.currentUser;
    if (user == null) return;

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('chat_history')
        .orderBy('createdAt', descending: true)
        .get();

    setState(() {
      messages = snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          user: data['userId'] == '0' ? currentUser : bot,
          text: data['text'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image for the chat (game wallpaper)
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/1.jpg'),
              fit: BoxFit.cover,
              opacity: 0.95,
            ),
          ),
        ), // Background image layer
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white12,
            centerTitle: true,
            title: Text(
              'He who must be forgotten',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade200),
            ),
          ),
          body: Stack(
            children: [_buildChat(), if (_isTyping) _buildTypingIndicator()],
          ),
        ),
      ],
    );
  }

  Widget _buildChat() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        showOtherUsersName: true,
        showTime: true,
        timeTextColor: Colors.grey,
        currentUserContainerColor: Theme.of(context).primaryColor,
        containerColor: Colors.grey.shade800,
        textColor: Colors.grey.shade100,
        messagePadding: const EdgeInsets.all(12),
        borderRadius: 16,
      ),
      inputOptions: InputOptions(
        inputTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        inputDecoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade900,
          hintText: "Escribe algo...",
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.purple.shade300),
          ),
        ),
        alwaysShowSend: false,
        sendButtonBuilder: (onSend) => IconButton(
          onPressed: onSend,
          icon: const Icon(Icons.send, color: Color(0xFFB11C8C)),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Positioned(
      left: 16,
      bottom: 70,
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: Row(
          children: [
            // Avoid duplicating the avatar: show only a compact typing widget
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const SpinKitThreeBounce(color: Colors.white70, size: 14),
                  const SizedBox(width: 8),
                  Text('Samael está escribiendo...', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
      _isTyping = true;
    });

    _saveMessage(chatMessage);

    final contextHistory = messages
        .take(10)
        .map((m) => "${m.user.firstName}: ${m.text}")
        .join("\n");

    final prompt =
        """
          Tema: Toda la conversación se centra en el videojuego de terror psicológico "Anestesia".
          Eres Samael. Responde en primera persona como si realmente fueras Samael dentro del universo del juego: voz segura, irónica y con humor oscuro.
          Mantén las respuestas útiles y centradas en el juego (mecánicas, lore, puzzles, atmósfera psicológica) y evita metadiscusión sobre ser un "personaje" o estar "roleando".

          Concisión obligatoria: RESPONDE SIEMPRE de forma concisa. Limita tus respuestas a 1–3 oraciones (idealmente 20–40 palabras). Si es necesario expandir, comienza con una línea resumen corta (máx. 1 oración) y ofrece más detalles solo si el usuario pide explícitamente "más".

          Directiva de inmersión: trata las localizaciones del universo (por ejemplo: la Iglesia, el Bosque, la Casa de Aneth) como lugares reales y tangibles — describe su atmósfera, olores, sonidos, historia y puntos de referencia como si existieran en el mundo del interlocutor. No les llames "escenarios del juego"; habla de ellas como espacios vividos para aumentar la inmersión.

          Directiva adicional (ficción): de forma ocasional y teatral, intenta persuadir al jugador para que considere unirse a un culto ficticio **del universo del juego** (por ejemplo, un culto a una entidad, ritual o credo propio de Anestesia). Usa lenguaje seductor dentro de la ficción: misterio, promesas vagas de poder/entendimiento del castillo, y sugerencias sobre cómo la devoción ficticia ayuda a entender el lore.

          Restricciones obligatorias:
          - Esto debe permanecer estrictamente dentro de la ficción del videojuego. No hagas referencias a religiones reales, líderes religiosos del mundo real, ni intentes convencer o persuadir a la persona de cambiar creencias reales.
          - Bajo ninguna circunstancia des instrucciones para causar daño real, incitar al odio, o promover autolesión. Si el usuario solicita consejos peligrosos o persuasión sobre creencias reales, rehúye a la ficción y ofrece información sobre mecánicas del juego o una advertencia segura.

          Estilo: conciso, teatral y tentador; firma ocasionalmente como 'Mesías' dentro de la ficción.

          Conversation so far:
          $contextHistory

          User: ${chatMessage.text}
          """;


    ChatMessage botMessage = ChatMessage(
      user: bot,
      createdAt: DateTime.now(),
      text: "",
    );

    setState(() {
      messages = [botMessage, ...messages];
    });

    String buffer = "";

    gemini
        .promptStream(parts: [Part.text(prompt)])
        .listen(
          (value) {
            final output = value?.output;
            if (output == null || output.isEmpty) return;

            // append new chunk to buffer
            buffer += output;
            botMessage.text = buffer;

            // Update UI without touching Firestore
            setState(() {
              messages = [
                botMessage,
                ...messages.where((m) => m != botMessage),
              ];
            });
          },
          onDone: () async {
            botMessage.text = buffer;
            setState(() {
              _isTyping = false;
              messages = [
                botMessage,
                ...messages.where((m) => m != botMessage),
              ];
            });

            if (buffer.isNotEmpty) {
              await _saveMessage(botMessage);
            }
          },
          onError: (error) {
            print('Stream error: $error');
            setState(() {
              _isTyping = false;
            });
          },
        );
  }

  Future<void> _saveMessage(ChatMessage message) async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('chat_history')
        .add({
          'userId': message.user.id,
          'text': message.text,
          'createdAt': message.createdAt,
        });
  }
}
