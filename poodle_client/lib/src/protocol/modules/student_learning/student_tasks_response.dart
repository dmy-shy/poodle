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
import 'package:poodle_client/src/protocol/protocol.dart' as _iwqu1w6v;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../modules/student_learning/student_task_row.dart' as _iwl8rw5j;

abstract class StudentTasksResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentTasksResponse._({
    required this.serverTime,
    required this.tasks,
  });

  factory StudentTasksResponse({
    required DateTime serverTime,
    required List<_iwl8rw5j.StudentTaskRow> tasks,
  }) = _StudentTasksResponseImpl;

  factory StudentTasksResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StudentTasksResponse(
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      tasks: _iwqu1w6v.Protocol().deserialize<List<_iwl8rw5j.StudentTaskRow>>(
        jsonSerialization['tasks'],
      ),
    );
  }

  DateTime serverTime;

  List<_iwl8rw5j.StudentTaskRow> tasks;

  /// Returns a shallow copy of this [StudentTasksResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentTasksResponse copyWith({
    DateTime? serverTime,
    List<_iwl8rw5j.StudentTaskRow>? tasks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentTasksResponse',
      'serverTime': serverTime.toJson(),
      'tasks': tasks.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentTasksResponse',
      'serverTime': serverTime.toJson(),
      'tasks': tasks.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StudentTasksResponseImpl extends StudentTasksResponse {
  _StudentTasksResponseImpl({
    required DateTime serverTime,
    required List<_iwl8rw5j.StudentTaskRow> tasks,
  }) : super._(
         serverTime: serverTime,
         tasks: tasks,
       );

  /// Returns a shallow copy of this [StudentTasksResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentTasksResponse copyWith({
    DateTime? serverTime,
    List<_iwl8rw5j.StudentTaskRow>? tasks,
  }) {
    return StudentTasksResponse(
      serverTime: serverTime ?? this.serverTime,
      tasks: tasks ?? this.tasks.map((e0) => e0.copyWith()).toList(),
    );
  }
}
