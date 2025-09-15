import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isConnected = true;
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    // Add initial welcome message
    _addMessage(ChatMessage(
      text: 'Hello! Welcome to Arc Vest support. How can I help you today?',
      isFromSupport: true,
      timestamp: DateTime.now(),
      senderName: 'Sarah',
      senderAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
                  ),
                ),
                if (_isConnected)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sarah - Support Agent',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _isConnected ? 'Online • Typically replies instantly' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isConnected ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isConnected) _buildConnectionBanner(),
          Expanded(child: _buildMessagesList()),
          if (_isTyping) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildConnectionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: AppColors.warning.withOpacity(0.1),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: AppColors.warning, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Connection lost. Trying to reconnect...',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.warning,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isFromSupport 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isFromSupport) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(message.senderAvatar ?? ''),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isFromSupport 
                    ? AppColors.surface 
                    : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isFromSupport ? 4 : 16),
                  bottomRight: Radius.circular(message.isFromSupport ? 16 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isFromSupport && message.senderName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: message.isFromSupport 
                          ? AppColors.textPrimary 
                          : Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: message.isFromSupport 
                          ? AppColors.textSecondary.withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!message.isFromSupport) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sarah is typing',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.2;
                        final animationValue = (_typingAnimationController.value - delay).clamp(0.0, 1.0);
                        final opacity = (animationValue * 2).clamp(0.0, 1.0);
                        
                        return Container(
                          margin: const EdgeInsets.only(right: 2),
                          child: Opacity(
                            opacity: opacity > 1 ? 2 - opacity : opacity,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.textSecondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.textSecondary),
            onPressed: _showAttachmentOptions,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.divider.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.divider.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    _addMessage(ChatMessage(
      text: text,
      isFromSupport: false,
      timestamp: DateTime.now(),
    ));

    _messageController.clear();
    
    // Simulate support response
    _simulateSupportResponse(text);
  }

  void _simulateSupportResponse(String userMessage) {
    setState(() => _isTyping = true);
    
    // Simulate typing delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isTyping = false);
      
      String response = _generateResponse(userMessage);
      
      _addMessage(ChatMessage(
        text: response,
        isFromSupport: true,
        timestamp: DateTime.now(),
        senderName: 'Sarah',
        senderAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      ));
    });
  }

  String _generateResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('order') || message.contains('purchase')) {
      return 'I can help you with your order! Could you please provide your order number? You can find it in your email confirmation or in the "My Orders" section of your profile.';
    } else if (message.contains('refund') || message.contains('return')) {
      return 'I understand you\'d like to return an item. Most items can be returned within 30 days. Let me help you start the return process. What item would you like to return?';
    } else if (message.contains('shipping') || message.contains('delivery')) {
      return 'For shipping questions, I can help track your package or explain our delivery options. Do you have a tracking number, or would you like to know about shipping times to your area?';
    } else if (message.contains('payment') || message.contains('card')) {
      return 'I can assist with payment issues. Are you having trouble adding a payment method, or is there an issue with a recent transaction?';
    } else if (message.contains('account') || message.contains('login')) {
      return 'I can help with account issues. Are you having trouble logging in, or do you need help updating your account information?';
    } else if (message.contains('vendor') || message.contains('seller')) {
      return 'For vendor-related questions, I can help you contact a specific vendor or explain how our vendor system works. What would you like to know?';
    } else if (message.contains('bug') || message.contains('error') || message.contains('problem')) {
      return 'I\'m sorry you\'re experiencing technical issues. Can you describe what\'s happening? Screenshots would be helpful if you have them. You can also report bugs through our Bug Report feature.';
    } else {
      return 'Thank you for reaching out! I\'m here to help with any questions about Arc Vest. Could you provide a bit more detail about what you need assistance with?';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: AppColors.primary),
              title: const Text('Email Transcript'),
              subtitle: const Text('Send chat history to your email'),
              onTap: () {
                Navigator.pop(context);
                _emailTranscript();
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline, color: AppColors.primary),
              title: const Text('Rate This Chat'),
              subtitle: const Text('Help us improve our support'),
              onTap: () {
                Navigator.pop(context);
                _rateChat();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.primary),
              title: const Text('FAQ'),
              subtitle: const Text('Browse frequently asked questions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/faq');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Send Attachment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Photo Library'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Photo attachment');
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Camera');
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: AppColors.primary),
              title: const Text('Document'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Document attachment');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _emailTranscript() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat transcript will be sent to your email address'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _rateChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate This Chat'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('How was your support experience?'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your feedback!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isFromSupport;
  final DateTime timestamp;
  final String? senderName;
  final String? senderAvatar;

  ChatMessage({
    required this.text,
    required this.isFromSupport,
    required this.timestamp,
    this.senderName,
    this.senderAvatar,
  });
}