import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:sidekick/providers/user_provider.dart';
import 'package:sidekick/utils/message_tree.dart';
import 'package:sidekick/utils/is_typing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'dart:async';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<types.Message> _messages = [];
  final _John = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  final _Pierre = const types.User(id: 'b4878b96-efbc-479a-8291-474ef323dec7');
  bool _isTyping = false;
  Node _currNode = Node("empty", "empty", []);
  List<ElevatedButton> _choiceBubbles = [];
  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    var partner = Provider.of<UserProvider>(context, listen: false).partner;
    if (user != null) {
      final _tree = initTree(user.firstName!, partner.name!.split(" ")[0]);
      _currNode = _tree;
    }
    super.initState();
    _loadMessages();
    startTimeout(0);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _setChoiceBubbles(bool setEmpty) {
    if (setEmpty) {
      setState(() {
        _choiceBubbles = [];
      });
    } else {
      setState(() {
        _choiceBubbles = buildButtonsFromNode(context);
      });
    }
  }

  types.TextMessage _createTextMessageFromNode(Node n) {
    types.User user = (n.username) == "Pierre" ? _Pierre : _John;
    final message = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: n.message,
      status: types.Status.seen,
    );
    return (message);
  }

  void _handleTimeout() {
    types.TextMessage message = _createTextMessageFromNode(_currNode);
    _addMessage(message); //TODO replace isTyping message
    _setChoiceBubbles(false);
    setState(() {
      _isTyping = false;
    });
  }

  void _handleIsTypingTimeout() {
    setState(() {
      _isTyping = true;
    });
    startTimeout(3000);
  }

  Timer startTimeout([int? milliseconds]) {
    var duration = milliseconds == null
        ? const Duration(seconds: 3)
        : const Duration(milliseconds: 1) * milliseconds;
    return Timer(duration, _handleTimeout);
  }

  Timer startIsTypingTimeout([int? milliseconds]) {
    var duration = milliseconds == null
        ? Duration(seconds: 3)
        : Duration(milliseconds: 1) * milliseconds;
    return Timer(duration, _handleIsTypingTimeout);
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _John,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _John,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    if (_currNode.children.length == 0) {
      return;
    }
    final textMessage = types.TextMessage(
      author: _John,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    /*_addMessage(textMessage);       // TO implement later
    startTimeout(3000);
    _setChoiceBubbles(true);*/
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    messages.clear();
    setState(() {
      _messages = messages;
    });
  }

  List<ElevatedButton> buildButtonsFromNode(BuildContext context) {
    return _currNode.children
        .map((element) => (ElevatedButton(
              onPressed: () {
                if (_currNode.children.length == 0) {
                  return;
                }
                final textMessage = types.TextMessage(
                    author: _John,
                    createdAt: DateTime.now().millisecondsSinceEpoch,
                    id: const Uuid().v4(),
                    text: element.message,
                    status: types.Status.seen);

      _addMessage(textMessage);
      _currNode = _currNode.children.singleWhere((e) => e.message == element.message).children[0];
      startIsTypingTimeout(2000);
      _setChoiceBubbles(true);
    }, child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
          child: Text(
            element.message,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
        color: const Color(0xffc48efb),
      ),
    style: ElevatedButton.styleFrom(
      primary: Theme.of(context).secondaryHeaderColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
    ))).toList();
  }

  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    var partner = Provider.of<UserProvider>(context, listen: false).partner;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          flexibleSpace: Container(
            color: Theme.of(context).colorScheme.primary
          ),
          title: Text(partner.name!,
              style: TextStyle(color: Theme.of(context).dialogBackgroundColor)),
          leading: Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4.0, top: 4.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(partner.photo!),
              ))),
      body: SafeArea(
        bottom: false,
        child: Chat(
          customBottomWidget: Card(
            child: Column(
              children:
              (_isTyping == true) ? [TypingIndicator(
                showIndicator: true,
                bubbleColor: Theme.of(context).primaryColorLight,
              )] : _choiceBubbles,
                // TODO à rajouter quand on aura plus les choix
                // Input(
                //   onSendPressed: _handleSendPressed,
                //   sendButtonVisibilityMode: SendButtonVisibilityMode.editing)
            ),
            color: Theme.of(context).primaryColor,
            elevation: 0
          ),
          theme: DarkChatTheme(
            backgroundColor: Theme.of(context).primaryColor,
            inputBackgroundColor: Color(0xff111111),
            inputBorderRadius: BorderRadius.all(Radius.circular(0)),
            primaryColor: Theme.of(context).secondaryHeaderColor,
            secondaryColor: Theme.of(context).primaryColorLight,
              receivedMessageBodyTextStyle: TextStyle(
                  color: Theme.of(context).dialogBackgroundColor,
                  fontSize: 16, fontWeight: FontWeight.w500, height: 1.5
              ),
              dateDividerTextStyle: TextStyle(
                  color: Theme.of(context).dialogBackgroundColor,
                  fontSize: 12, fontWeight: FontWeight.w800, height: 1.333
              )
          ),
          messages: _messages,
          onAttachmentPressed: _handleAtachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: _John,
          scrollPhysics: const BouncingScrollPhysics()
              .applyTo(const AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }
}
