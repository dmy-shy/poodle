/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class NotebookChatInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookChatInput._({
    required this.notebookId,
    required this.requestKey,
    required this.question,
  });

  factory NotebookChatInput({
    required _is.UuidValue notebookId,
    required String requestKey,
    required String question,
  }) = _NotebookChatInputImpl;

  factory NotebookChatInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookChatInput(
      notebookId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['notebookId'],
      ),
      requestKey: jsonSerialization['requestKey'] as String,
      question: jsonSerialization['question'] as String,
    );
  }

  _is.UuidValue notebookId;

  String requestKey;

  String question;

  /// Returns a shallow copy of this [NotebookChatInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookChatInput copyWith({
    _is.UuidValue? notebookId,
    String? requestKey,
    String? question,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookChatInput',
      'notebookId': notebookId.toJson(),
      'requestKey': requestKey,
      'question': question,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookChatInput',
      'notebookId': notebookId.toJson(),
      'requestKey': requestKey,
      'question': question,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NotebookChatInputImpl extends NotebookChatInput {
  _NotebookChatInputImpl({
    required _is.UuidValue notebookId,
    required String requestKey,
    required String question,
  }) : super._(
         notebookId: notebookId,
         requestKey: requestKey,
         question: question,
       );

  /// Returns a shallow copy of this [NotebookChatInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookChatInput copyWith({
    _is.UuidValue? notebookId,
    String? requestKey,
    String? question,
  }) {
    return NotebookChatInput(
      notebookId: notebookId ?? this.notebookId,
      requestKey: requestKey ?? this.requestKey,
      question: question ?? this.question,
    );
  }
}
