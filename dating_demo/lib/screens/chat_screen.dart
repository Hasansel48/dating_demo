import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final int userAge;
  final String userCity;
  final List<Map<String, dynamic>> initialMessages;
  final Function(List<Map<String, dynamic>>) onMessagesSaved;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.userAge,
    required this.userCity,
    required this.initialMessages,
    required this.onMessagesSaved,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.initialMessages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    // Mesajları kaydet
    widget.onMessagesSaved(_messages);
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isSent': true,
          'time': TimeOfDay.now().format(context),
        });
      });
      _messageController.clear();
      // Her mesaj gönderişinde kaydet
      widget.onMessagesSaved(_messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade300,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userName, style: const TextStyle(fontSize: 16)),
                    Text(
                      '${widget.userAge} yaş, ${widget.userCity}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Video arama
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Ses arama
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Daha fazla seçenek
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mesajlar listesi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSent = message['isSent'] as bool;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isSent
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSent ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isSent ? 16 : 0),
                            bottomRight: Radius.circular(isSent ? 0 : 16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message['text'],
                              style: TextStyle(
                                color: isSent ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message['time'],
                              style: TextStyle(
                                color: isSent
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Mesaj yazma alanı
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Dosya ekleme
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesaj yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
