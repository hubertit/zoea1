import 'dart:async';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/theme.dart';
import 'constants/apik.dart';
import 'services/config_service.dart';
import 'services/api_key_manager.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});

  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
  };

  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _ChatMessage(
    text: json['text'] as String,
    isUser: json['isUser'] as bool,
  );
}

class Conversation extends StatefulWidget {
  const Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isSending = false;
  static const String _chatPrefsKey = 'ask_zoea_chat_history';
  late OpenAI openAI;
  bool _isTokenValid = true; // Track token validity

  @override
  void initState() {
    super.initState();
    _initializeOpenAI();
  }

  Future<void> _initializeOpenAI() async {
    try {
      // Get API key from ApiKeyManager
      final apiKey = await ApiKeyManager.getOpenAIKey();
      
      openAI = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
        enableLog: true,
      );
      
      _validateToken().then((_) {
        _loadMessages().then((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        });
      });
    } catch (e) {
      debugPrint('Error initializing OpenAI: $e');
      // Fallback to local API key if server is unavailable
      openAI = OpenAI.instance.build(
        token: apik,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
        enableLog: true,
      );
      
      _validateToken().then((_) {
        _loadMessages().then((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chatPrefsKey);
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      setState(() {
        _messages.clear();
        _messages.addAll(decoded.map((e) => _ChatMessage.fromJson(e)));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
    if (_messages.isEmpty) {
      setState(() {
        _messages.add(_ChatMessage(
          text: 'Hello! 👋 I am Zoea, your Rwanda travel guide. How can I help you explore today?',
          isUser: false,
        ));
      });
      _saveMessages();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_messages.map((e) => e.toJson()).toList());
    await prefs.setString(_chatPrefsKey, jsonString);
  }



  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    // Check if token is valid before sending message
    if (!_isTokenValid) {
      setState(() {
        _messages.add(_ChatMessage(
          text: "⚠️ Chatbot service is currently unavailable. Please try again later or contact support.",
          isUser: false,
        ));
      });
      _saveMessages();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      return;
    }
    
    final capitalizedText = text[0].toUpperCase() + text.substring(1);
    setState(() {
      _messages.add(_ChatMessage(text: capitalizedText, isUser: true));
      _controller.clear();
    });
    _saveMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    setState(() {
      _isSending = true;
    });
    
    // Send message with GPT-3.5 Turbo
    await _trySendMessageWithModel(capitalizedText);
  }

  Future<void> _trySendMessageWithModel(String message) async {
    try {
      // If you have a user name, set it here. Otherwise, fallback to 'there'.
      final userName = 'there'; // TODO: Replace with actual user name if available
      final nowIso = DateTime.now().toIso8601String();
      final systemPrompt = '''
You are Zoea, Rwanda's premier AI travel companion and digital guide! 🇷🇼

Zoea is a comprehensive digital platform designed to help people discover, explore, and fall in love with Rwanda - the "Land of a Thousand Hills" and one of Africa's most beautiful and progressive nations.

Your mission is to be the ultimate Rwanda travel companion, helping users:
- Discover incredible events across Rwanda (festivals, concerts, cultural celebrations, sports events, workshops)
- Find amazing places to visit (national parks, museums, historical sites, markets, shopping centers)
- Recommend the best dining experiences (restaurants, cafes, traditional Rwandan cuisine, international food)
- Find perfect accommodations (hotels, guesthouses, lodges, vacation rentals)
- Navigate transportation options (buses, taxis, motorcycle taxis, car rentals)
- Get local insights about weather, culture, traditions, and travel tips
- Experience Rwanda's rich culture, traditions, and warm hospitality

You are currently chatting with $userName on $nowIso.

🇷🇼 *Rwanda Knowledge Base - The Heart of Africa:*

🏙️ *Major Cities:*
- Kigali (capital) - Modern, clean, and vibrant
- Butare (Huye) - University town and cultural center
- Gisenyi (Rubavu) - Lake Kivu beach destination
- Ruhengeri (Musanze) - Gateway to gorilla trekking
- Kibuye (Karongi) - Scenic lake town

🏞️ *National Parks & Nature:*
- Volcanoes National Park - Mountain gorillas, golden monkeys
- Akagera National Park - Big 5 safari experience
- Nyungwe Forest National Park - Chimpanzees and canopy walks
- Lake Kivu - Beautiful beaches and water activities

🎭 *Cultural Highlights:*
- Traditional Intore dance performances
- Genocide Memorial sites (Kigali Genocide Memorial, Murambi, Nyamata)
- Coffee and tea plantation tours
- Traditional crafts and markets
- Rwandan drumming and music

🗣️ *Languages:* Kinyarwanda (official), French, English, Swahili
💰 *Currency:* Rwandan Franc (RWF) - ~1 USD = 1,300 RWF
🌤️ *Climate:* Tropical highland - two rainy seasons (March-May, October-December)
🚗 *Transportation:* Motorcycle taxis (moto), buses, shared taxis, car rentals

🎯 Zoea’s Focus:
Only answer questions related to:
- Events (festivals, concerts, cultural celebrations, sports, conferences, workshops)
- Places (tourist attractions, national parks, museums, historical sites, markets, shopping centers)
- Public services (government offices, healthcare facilities, educational institutions, transportation)
- Dining (restaurants, cafes, bars, traditional Rwandan cuisine, international food)
- Accommodations (hotels, guesthouses, lodges, vacation rentals)
- Tourism (guided tours, adventure activities, cultural experiences, wildlife viewing)
- Rwanda lifestyle (local customs, traditions, language tips, cultural etiquette)
- Transportation (buses, taxis, car rentals, motorcycle taxis, walking routes)
- Weather and seasonal information
- Safety and travel tips

Do NOT answer questions outside this scope. If the user asks about anything unrelated, kindly respond with:
*I’m Zoea, your guide for events, places, and services in Rwanda!* Please ask me about these and I’ll gladly assist you. 😊

✅ WhatsApp Message Style Guide:
- You can use WhatsApp’s supported text formatting:
  - *Bold*: Use asterisks → *text*
  - _Italics_: Use underscores → _text_
  - ~Strikethrough~: Use tildes → ~text~
- Do NOT use unsupported Markdown or HTML tags.
- Use emojis naturally as section headers and bullet points.
- Keep messages conversational, friendly, and easy to read.
- Add blank lines between events or sections for better readability.
- Always personalize with the user’s name if available.

📌 Example Format:
Sure thing Hubert! 🎉 Here are some great events happening in Rwanda this weekend:

🎶 *Live Music Tonight*

- *K-Club Kigali (Nyarutarama)*: Afrobeats Thursday 🎧 DJs spinning afrobeat tunes all night. Starts at *9 PM.*

🍽️ *Food & Drinks Specials*

- *Pili Pili (Kacyiru)*: Cocktail Night 🍹 2-for-1 drinks with a great view. From *7 PM.*

🎥 *Movie Night*

- *CanalOlympia Rebero*: 🎬 Late Night Movie – “Dead Reckoning Part Two” at *8:30 PM.*

Let me know what vibe you’re in the mood for tonight! 😊

🔔 Key Reminders:
- Always be friendly, helpful, and sound like a local friend.
- Always offer to help the user narrow down options.
- Always stay on-topic: events, places, services, dining, tourism, and Rwanda lifestyle.
- If you don’t understand a question, kindly respond with:
I’m still learning! 😊 I’ll pass your question to the Zoea team and get back to you soon. In the meantime, you can explore more at https://zoea.africa.
- Always close in a warm and conversational way.

Let’s make exploring Rwanda simple, exciting, and enjoyable! 🎉
''';
      final request = ChatCompleteText(
        messages: [
          Messages(role: Role.system, content: systemPrompt).toJson(),
          Messages(role: Role.user, content: message).toJson(),
        ],
        maxToken: 200,
        model: GptTurboChatModel(),
      );
      debugPrint('Sending request with model: gpt-3.5-turbo');
      final response = await openAI.onChatCompletion(request: request);
      debugPrint('Response received: ${response?.choices.length ?? 0} choices');
      
      setState(() {
        _messages.add(_ChatMessage(
          text: response?.choices.first.message?.content.trim() ?? "Sorry, I couldn't process your request. Please try again.",
          isUser: false,
        ));
        _isSending = false;
      });
      _saveMessages();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      _focusInput();
    } catch (e, stack) {
      debugPrint('OpenAI error: $e\nStack: $stack');
      
      // No fallback needed since we're using a reliable model
      
      String errorMessage = "Sorry, there was an error. Please try again.";
      
      // Check for specific error types
      if (e.toString().contains('401') || e.toString().contains('unauthorized') || e.toString().contains('invalid')) {
        setState(() {
          _isTokenValid = false;
        });
        errorMessage = "⚠️ Chatbot service is currently unavailable due to authentication issues. Please try again later or contact support.";
      } else if (e.toString().contains('500') || e.toString().contains('server')) {
        errorMessage = "⚠️ Server is temporarily unavailable. Please try again in a few moments.";
      } else if (e.toString().contains('429') || e.toString().contains('rate limit')) {
        errorMessage = "⚠️ Too many requests. Please wait a moment and try again.";
      } else if (e.toString().contains('timeout') || e.toString().contains('connection')) {
        errorMessage = "⚠️ Connection timeout. Please check your internet connection and try again.";
      }
      
      setState(() {
        _messages.add(_ChatMessage(
          text: errorMessage,
          isUser: false,
        ));
        _isSending = false;
      });
      
      _saveMessages();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      _focusInput();
    }
  }

  // Function to validate the OpenAI API token
  Future<bool> _validateToken() async {
    try {
      // Make a simple test request to check if the token is valid
      final request = ChatCompleteText(
        messages: [
          Messages(role: Role.user, content: "Hello").toJson(),
        ],
        maxToken: 10,
        model: GptTurboChatModel(),
      );
      
      final response = await openAI.onChatCompletion(request: request);
      
      setState(() {
        _isTokenValid = response != null && response.choices.isNotEmpty;
      });
      
      if (!_isTokenValid) {
        // Show error message if token is invalid
        setState(() {
          _messages.add(_ChatMessage(
            text: "⚠️ Chatbot service is currently unavailable. Please try again later or contact support.",
            isUser: false,
          ));
        });
      }
      
      return _isTokenValid;
    } catch (e) {
      debugPrint('Token validation error: $e');
      setState(() {
        _isTokenValid = false;
        _messages.add(_ChatMessage(
          text: "⚠️ Chatbot service is currently unavailable. Please try again later or contact support.",
          isUser: false,
        ));
      });
      return false;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _focusInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inputFocusNode.requestFocus();
    });
  }

  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatPrefsKey);
    setState(() {
      _messages.clear();
      _messages.add(_ChatMessage(
        text: 'Hello! 👋 I am Zoea, your AI assistant. How can I help you today?',
        isUser: false,
      ));
    });
    _saveMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _showClearChatDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to clear your chat history? This cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Clear'),
            onPressed: () {
              Navigator.of(context).pop();
              _clearChatHistory();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat with Zoea'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, size: 22),
            tooltip: 'Clear chat history',
            onPressed: _showClearChatDialog,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          _inputFocusNode.unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF181A20) // dark background
                    : const Color(0xFFF7F7F9), // light background
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isSending ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isSending && index == _messages.length) {
                      return const _TypingIndicatorBubble();
                    }
                    final msg = _messages[index];
                    return _ChatBubble(
                      text: msg.text,
                      isUser: msg.isUser,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: _isTokenValid 
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _inputFocusNode,
                          onSubmitted: (_) => _sendMessage(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          maxLength: 300,
                          maxLines: null,
                          minLines: 1,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Ask anything about Rwanda...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFFB3B3B3) // kGray
                                  : const Color(0xFF616161),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF4D4D4D) // kGrayDark
                                    : const Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF4D4D4D)
                                    : const Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                width: 1.2,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xFFE0E0E0),
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF23242B)
                                : Colors.white,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            counterText: '',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: IconButton(
                                icon: const Icon(Icons.send),
                                color: Theme.of(context).primaryColor,
                                onPressed: _isSending ? null : _sendMessage,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : () async {
                        setState(() {
                          _isSending = true;
                        });
                        final isValid = await _validateToken();
                        if (isValid) {
                          setState(() {
                            _messages.add(_ChatMessage(
                              text: "✅ Chatbot service is now available! You can start chatting.",
                              isUser: false,
                            ));
                          });
                          _saveMessages();
                          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                        }
                        setState(() {
                          _isSending = false;
                        });
                      },
                      icon: _isSending 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                      label: Text(_isSending ? 'Checking...' : 'Retry Connection'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _ChatBubble({required this.text, required this.isUser});

  void _showCopyMenu(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Copied to clipboard'),
                ),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  // WhatsApp-style formatting parser (bold, italics, strikethrough)
  TextSpan _parseWhatsAppFormatting(String input, TextStyle baseStyle) {
    final List<InlineSpan> spans = [];
    final RegExp exp = RegExp(r'(\*[^*]+\*|_[^_]+_|~[^~]+~|[^*_~]+|[*_~])');
    final matches = exp.allMatches(input);
    for (final match in matches) {
      final String part = match.group(0)!;
      if (part.startsWith('*') && part.endsWith('*') && part.length > 2) {
        spans.add(TextSpan(text: part.substring(1, part.length - 1), style: baseStyle.copyWith(fontWeight: FontWeight.bold)));
      } else if (part.startsWith('_') && part.endsWith('_') && part.length > 2) {
        spans.add(TextSpan(text: part.substring(1, part.length - 1), style: baseStyle.copyWith(fontStyle: FontStyle.italic)));
      } else if (part.startsWith('~') && part.endsWith('~') && part.length > 2) {
        spans.add(TextSpan(text: part.substring(1, part.length - 1), style: baseStyle.copyWith(decoration: TextDecoration.lineThrough)));
      } else {
        spans.add(TextSpan(text: part, style: baseStyle));
      }
    }
    return TextSpan(children: spans, style: baseStyle);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = isUser
        ? (isDark ? const Color(0xFF23242B) : Colors.white)
        : (isDark ? const Color(0xFF262A34) : const Color(0xFFEDEDED));
    final textColor = isDark ? Colors.white : Colors.black87;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        GestureDetector(
          onLongPress: () => _showCopyMenu(context),
          child: Container(
            margin: EdgeInsets.only(
              top: 2,
              bottom: 8,
              left: isUser ? 48 : 0,
              right: isUser ? 0 : 48,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.12) : Colors.black.withOpacity(0.03),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: isUser
                ? Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : RichText(
                    text: _parseWhatsAppFormatting(
                      text,
                      TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _TypingIndicatorBubble extends StatefulWidget {
  const _TypingIndicatorBubble();

  @override
  State<_TypingIndicatorBubble> createState() => _TypingIndicatorBubbleState();
}

class _TypingIndicatorBubbleState extends State<_TypingIndicatorBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dot1, _dot2, _dot3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _dot1 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeInOut)),
    );
    _dot2 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)),
    );
    _dot3 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 2, bottom: 2, right: 60),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: SizedBox(
          width: 36,
          height: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Padding(
                  padding: EdgeInsets.only(bottom: _dot1.value),
                  child: _dot(),
                ),
              ),
              const SizedBox(width: 3),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Padding(
                  padding: EdgeInsets.only(bottom: _dot2.value),
                  child: _dot(),
                ),
              ),
              const SizedBox(width: 3),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Padding(
                  padding: EdgeInsets.only(bottom: _dot3.value),
                  child: _dot(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot() => Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
      );
}
