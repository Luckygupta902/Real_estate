import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../models/lead.dart';
import '../models/property.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/lead_service.dart';
import '../services/social_service.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final AuthService _auth = AuthService();
  final SocialService _social = SocialService();
  final LeadService _leads = LeadService();
  final TextEditingController _commentController =
      TextEditingController();

  bool _loggedIn = false;
  bool _liked = false;
  int _likeCount = 0;
  bool _likeBusy = false;

  List<Comment> _comments = [];
  // IDs of comments written by the logged-in user (editable/deletable).
  Set<int> _myCommentIds = {};
  bool _loadingComments = true;
  bool _posting = false;

  int? get _propertyId => widget.property.id;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = _propertyId;
    if (id == null) return;

    final loggedIn = await _auth.isLoggedIn();

    try {
      final count = await _social.getLikeCount(id);
      final liked = loggedIn ? await _social.isLikedByMe(id) : false;

      if (!mounted) return;
      setState(() {
        _loggedIn = loggedIn;
        _likeCount = count;
        _liked = liked;
      });
    } catch (e) {
      debugPrint('Loading likes failed: $e');
      if (mounted) setState(() => _loggedIn = loggedIn);
    }

    await _loadComments();
  }

  Future<void> _loadComments() async {
    final id = _propertyId;
    if (id == null) return;

    try {
      final comments = await _social.getComments(id);
      final mine = _loggedIn ? await _social.getMyComments() : <Comment>[];

      if (!mounted) return;
      setState(() {
        _comments = comments;
        _myCommentIds = mine.map((c) => c.id).toSet();
        _loadingComments = false;
      });
    } catch (e) {
      debugPrint('Loading comments failed: $e');
      if (mounted) setState(() => _loadingComments = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _toggleLike() async {
    final id = _propertyId;
    if (id == null || _likeBusy) return;

    if (!_loggedIn) {
      _showMessage('Please log in to like properties');
      return;
    }

    setState(() => _likeBusy = true);

    try {
      if (_liked) {
        await _social.unlikeProperty(id);
      } else {
        await _social.likeProperty(id);
      }

      final count = await _social.getLikeCount(id);

      if (!mounted) return;
      setState(() {
        _liked = !_liked;
        _likeCount = count;
      });
    } catch (e) {
      _showMessage('Could not update like: ${ApiClient.errorMessage(e)}');
    } finally {
      if (mounted) setState(() => _likeBusy = false);
    }
  }

  Future<void> _addComment() async {
    final id = _propertyId;
    final text = _commentController.text.trim();
    if (id == null || text.isEmpty || _posting) return;

    setState(() => _posting = true);

    try {
      final comment = await _social.addComment(id, text);

      if (!mounted) return;
      setState(() {
        _comments = [..._comments, comment];
        _myCommentIds = {..._myCommentIds, comment.id};
        _commentController.clear();
      });
    } catch (e) {
      _showMessage('Could not post comment: ${ApiClient.errorMessage(e)}');
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Future<void> _editComment(Comment comment) async {
    final controller = TextEditingController(text: comment.commentText);

    final newText = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit comment'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (newText == null ||
        newText.isEmpty ||
        newText == comment.commentText) {
      return;
    }

    try {
      final updated = await _social.updateComment(comment.id, newText);

      if (!mounted) return;
      setState(() {
        _comments = _comments
            .map((c) => c.id == updated.id ? updated : c)
            .toList();
      });
    } catch (e) {
      _showMessage('Could not update comment: ${ApiClient.errorMessage(e)}');
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _social.deleteComment(comment.id);

      if (!mounted) return;
      setState(() {
        _comments = _comments.where((c) => c.id != comment.id).toList();
        _myCommentIds = {..._myCommentIds}..remove(comment.id);
      });
    } catch (e) {
      _showMessage('Could not delete comment: ${ApiClient.errorMessage(e)}');
    }
  }

  Future<void> _sendEnquiry() async {
    final id = _propertyId;
    if (id == null) return;

    if (!_loggedIn) {
      _showMessage('Please log in to send an enquiry');
      return;
    }

    final controller = TextEditingController(
      text: "Hi, I'm interested in ${widget.property.title}.",
    );

    final message = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send enquiry'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Your message to the owner',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (message == null || message.isEmpty) return;

    try {
      final userId = await ApiClient.instance.getCurrentUserId();
      if (userId == null) {
        _showMessage('Please log in again to send an enquiry');
        return;
      }

      await _leads.createLead(
        Lead(
          customerId: userId,
          propertyId: id,
          message: message,
        ),
      );

      _showMessage('Enquiry sent');
    } catch (e) {
      _showMessage('Could not send enquiry: ${ApiClient.errorMessage(e)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            property.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text('Price: ₹${property.price ?? 0}'),
          Text('City: ${property.city ?? ''}'),
          Text('State: ${property.state ?? ''}'),
          const SizedBox(height: 12),
          Text(property.description ?? ''),

          if (_propertyId != null) ...[
            const SizedBox(height: 16),

            // ---------------- LIKES ----------------
            Row(
              children: [
                IconButton(
                  onPressed: _likeBusy ? null : _toggleLike,
                  icon: Icon(
                    _liked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
                Text('$_likeCount likes'),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _sendEnquiry,
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Send enquiry'),
                ),
              ],
            ),

            const Divider(height: 32),

            // ---------------- COMMENTS ----------------
            Text(
              'Comments (${_comments.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            if (_loggedIn)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                      ),
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                  IconButton(
                    onPressed: _posting ? null : _addComment,
                    icon: const Icon(Icons.send),
                  ),
                ],
              )
            else
              const Text('Log in to write a comment.'),

            const SizedBox(height: 8),

            if (_loadingComments)
              const Center(child: CircularProgressIndicator())
            else if (_comments.isEmpty)
              const Text('No comments yet.')
            else
              ..._comments.map(
                (c) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person),
                  title: Text(c.commentText),
                  subtitle: Text('User ${c.userId}'),
                  trailing: _myCommentIds.contains(c.id)
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editComment(c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteComment(c),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
