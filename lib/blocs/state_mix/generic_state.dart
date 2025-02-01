// Copyright (c) 2023 by Salama Enigma (salama92work@gmail.com)
// All rights reserved.
// Check out my Github account (https://github.com/salamaEnigma) for more projects.

import 'package:easy_localization/easy_localization.dart';
import 'package:great_quran/generated/locale_keys.g.dart';
import 'mix_extensions.dart';

/// * All purposes generic state class
/// Usually used with for `Notifiers` & `StateNotifiers`
class GenericState<T> {
  final Status _status;
  final T? _data;
  final String? error;

  // * Constructors for the different status one for each `Status` enum value.

  /// Initial State Constructor
  GenericState.initial([T? initialData])
      : _status = Status.initial,
        _data = initialData,
        error = null;

  /// Success State Constructor
  GenericState.success(T data)
      : _status = Status.success,
        _data = data,
        error = null;

  /// Fail State Constructor
  GenericState.fail([this.error])
      : _status = Status.fail,
        _data = null;

  /// Loading State Constructor
  GenericState.loading()
      : _status = Status.loading,
        _data = null,
        error = null;

  /// Gets GenericState `Status`
  Status get status => _status;

  /// Checks `state` is success or not
  bool get isSuccess => _status == Status.success;

  /// Checks `state` is loading or not, useful to show loading indicators
  bool get isLoading => _status == Status.loading;

  /// Checks `state` is failed or not, useful to show error messages
  bool get isFailed => _status == Status.fail;

  /// Gets the state data directly, if the `status` is not a `success` it returns null.
  /// so you call this only when your are sure that the state is success or provide a onDataAbsence callback that returns a default value of you data.
  T? getData({
    T? Function()? onDataAbsence,
  }) =>
      isSuccess ? _data : onDataAbsence?.call();

  /// Gets the error message of the fail state
  String? getError() => isFailed ? error : null;

  /// All cases are required except `initial` (optional), which allows returning a non-nullable value.
  /// if initial is not provider ([loading] callback is used by default).
  /// Usually this is used with UI with a `Widget` return type.
  R when<R>({
    R Function(T? data)? initial,
    required R Function(T data) data,
    required R Function() loading,
    required R Function(String error) error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial != null ? initial(_data) : loading();
      case Status.success:
        return data(_data as T);
      case Status.fail:
        return error(
          this.error ?? LocaleKeys.error_error.tr(),
        );
      case Status.loading:
        return loading();
    }
  }

  /// Guard function that evaluate a future and returns either Success state Or Fail state.
  static Future<GenericState<T>> guard<T>(Future<T> Function() future) async {
    try {
      return GenericState.success(await future());
    } catch (err, stack) {
      err.log();
      stack.log(isError: true);
      return GenericState.fail(
        err.toString(),
      );
    }
  }

  R? whenOrNull<R>({
    R Function(T? data)? initial,
    R Function(T data)? data,
    R Function()? loading,
    R Function(String error)? error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial?.call(_data);
      case Status.success:
        return data?.call(_data as T);
      case Status.fail:
        return error?.call(this.error ?? LocaleKeys.error_error.tr());
      case Status.loading:
        return loading?.call();
      default:
        return null;
    }
  }
}

/// Optional state handler for cases where not all states need to be handled.

enum Status { initial, success, fail, loading }
