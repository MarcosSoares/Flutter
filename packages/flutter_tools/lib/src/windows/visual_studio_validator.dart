// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../base/context.dart';
import '../base/user_messages.dart' hide userMessages;
import '../doctor_validator.dart';
import 'visual_studio.dart';

VisualStudioValidator? get visualStudioValidator => context.get<VisualStudioValidator>();

class VisualStudioValidator extends DoctorValidator {
  const VisualStudioValidator({
    required VisualStudio visualStudio,
    required UserMessages userMessages,
  }) : _visualStudio = visualStudio,
       _userMessages = userMessages,
       super('Visual Studio - develop for Windows');

  final VisualStudio _visualStudio;
  final UserMessages _userMessages;

  @override
  Future<ValidationResult> validate() async {
    final List<ValidationMessage> messages = <ValidationMessage>[];
    ValidationType status = ValidationType.missing;
    String? versionInfo;

    if (_visualStudio.isInstalled) {
      status = ValidationType.installed;

      messages.add(ValidationMessage(
          _userMessages.visualStudioLocation(_visualStudio.installLocation ?? 'unknown')
      ));

      messages.add(ValidationMessage(_userMessages.visualStudioVersion(
          _visualStudio.displayName ?? 'unknown',
          _visualStudio.fullVersion ?? 'unknown',
      )));

      if (_visualStudio.isPrerelease) {
        messages.add(ValidationMessage(_userMessages.visualStudioIsPrerelease));
      }

      final String? windows10SdkVersion = _visualStudio.getWindows10SDKVersion();
      if (windows10SdkVersion != null) {
        messages.add(ValidationMessage(_userMessages.windows10SdkVersion(windows10SdkVersion)));
      }

      final String? cmakeVersion = _visualStudio.getCmakeVersion();
      if (cmakeVersion != null) {
        if (double.parse(cmakeVersion) >= 3.15) {
          messages.add(ValidationMessage(_userMessages.visualStudioCmakeVersion(cmakeVersion)));
        } else {
          status = ValidationType.partial;
          messages.add(ValidationMessage.hint(_userMessages.cmakeTooOld('3.15')));
        }
      }

      // Messages for faulty installations.
      if (!_visualStudio.isAtLeastMinimumVersion) {
        status = ValidationType.partial;
        messages.add(ValidationMessage.error(
            _userMessages.visualStudioTooOld(
                _visualStudio.minimumVersionDescription,
                _visualStudio.workloadDescription,
            ),
        ));
      } else if (_visualStudio.isRebootRequired) {
        status = ValidationType.partial;
        messages.add(ValidationMessage.error(_userMessages.visualStudioRebootRequired));
      } else if (!_visualStudio.isComplete) {
        status = ValidationType.partial;
        messages.add(ValidationMessage.error(_userMessages.visualStudioIsIncomplete));
      } else if (!_visualStudio.isLaunchable) {
        status = ValidationType.partial;
        messages.add(ValidationMessage.error(_userMessages.visualStudioNotLaunchable));
      } else if (!_visualStudio.hasNecessaryComponents) {
        status = ValidationType.partial;
        messages.add(ValidationMessage.error(
            _userMessages.visualStudioMissingComponents(
                _visualStudio.workloadDescription,
                _visualStudio.necessaryComponentDescriptions(),
            ),
        ));
      } else if (windows10SdkVersion == null) {
        status = ValidationType.partial;
        messages.add(ValidationMessage.hint(_userMessages.windows10SdkNotFound));
      }
      versionInfo = '${_visualStudio.displayName} ${_visualStudio.displayVersion}';
    } else {
      status = ValidationType.missing;
      messages.add(ValidationMessage.error(
        _userMessages.visualStudioMissing(
          _visualStudio.workloadDescription,
        ),
      ));
    }

    return ValidationResult(status, messages, statusInfo: versionInfo);
  }
}
