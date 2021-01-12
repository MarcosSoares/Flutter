// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'system_channels.dart';

/// Manages the installation and loading of deferred component modules.
///
/// Deferred components allow Flutter applications to download precompiled AOT
/// dart code and assets at runtime, reducing the install size of apps and
/// avoiding installing unnessecary code/assets on end user devices. Common
/// use cases include deferring installation of advanced or infrequently
/// used features and limiting locale specific features to users of matching
/// locales. Deferred components can only deliver split off parts of the same
/// app that was built and installed on the device. It cannot load new code
/// written after the app is distributed.
///
/// Deferred components are currently and Android-only feature. The methods in
/// this class are a no-op and all assets and dart code are already available
/// without installation if called on other platforms.
class DeferredComponent {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  DeferredComponent._();

  // TODO(garyq): We should eventually expand this to install modules by loadingUnitId
  // as well as moduleName, but currently, loadingUnitId is opaque to the dart code
  // so this is not possible. The API has been left flexible to allow adding
  // loadingUnitId as a parameter.

  /// Requests that an assets-only deferred component identified by the [moduleName]
  /// be downloaded and installed.
  ///
  /// This method returns a Future<void> that will complete when the feature is
  /// installed and any assets are ready to be used. When an error occurs, the
  /// future will complete with an error.
  ///
  /// This method should be used for asset-only deferred components or loading just
  /// the assets from a component with both dart code and assets. Deferred components
  /// containing dart code should call `loadLibrary()` on a deferred imported
  /// library's prefix to ensure that the dart code is properly loaded as
  /// `loadLibrary()` will provide the loading unit id needed for the dart
  /// library loading process. For example:
  ///
  /// ```dart
  /// import 'split_module.dart' deferred as SplitModule;
  /// ...
  /// SplitModule.loadLibrary();
  /// ```
  ///
  /// This method will not load associated dart libraries contained in the dynamic
  /// feature module, though it will download the files necessary and subsequent
  /// calls to `loadLibrary()` to load will complete faster.
  ///
  /// Assets installed by this method may be accessed in the same way as any other
  /// local asset by providing a string path to the asset.
  ///
  /// See also:
  ///
  ///  * [uninstallDeferredComponent], a method to request the uninstall of a component.
  ///  * [loadLibrary](https://api.dart.dev/dart-mirrors/LibraryDependencyMirror/loadLibrary.html),
  ///    the dart method to trigger the installation of the corresponding deferred component that
  ///    contains the dart library.
  static Future<void> installDeferredComponent({required String moduleName}) async {
    await SystemChannels.deferredComponent.invokeMethod<void>(
      'installDeferredComponent',
      <String, dynamic>{ 'loadingUnitId': -1, 'moduleName': moduleName },
    );
  }

  /// Requests that a deferred component identified by the [moduleName] be
  /// uninstalled.
  ///
  /// Since uninstallation typically requires significant disk i/o, this method only
  /// signals the intent to uninstall. Completion of the returned future indicates
  /// that the request to uninstall has been registered. Actual uninstallation (eg,
  /// removal of assets and files) may occur at a later time. However, once uninstallation
  /// is requested, the deferred component should not be used anymore until
  /// [installDeferredComponent] or `loadLibrary()` is called again.
  ///
  /// It is safe to request an uninstall when dart code from the component is in use,
  /// but assets from the component should not be used once the component uninstall is
  /// requested. The dart code will remain usable in the app's current session but
  /// is not guaranteed to work in future sessions.
  ///
  /// See also:
  ///
  ///  * [installDeferredComponent], a method to install asset-only components.
  ///  * [loadLibrary](https://api.dart.dev/dart-mirrors/LibraryDependencyMirror/loadLibrary.html),
  ///    the dart method to trigger the installation of the corresponding deferred component that
  ///    contains the dart library.
  static Future<void> uninstallDeferredComponent({required String moduleName}) async {
    await SystemChannels.deferredComponent.invokeMethod<void>(
      'uninstallDeferredComponent',
      <String, dynamic>{ 'loadingUnitId': -1, 'moduleName': moduleName },
    );
  }
}
