// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import '../../src/common.dart';
import 'deferred_components_config.dart';
import 'project.dart';

class DeferredComponentsProject extends Project {
  DeferredComponentsProject(this.deferredComponents);

  @override
  final String pubspec = '''
  name: test
  environment:
    sdk: ">=2.12.0-0 <3.0.0"

  dependencies:
    flutter:
      sdk: flutter
  flutter:
    assets:
      - test_assets/asset1.txt
    deferred-components:
      - name: component1
        libraries:
          - package:test/deferred_library.dart
        assets:
          - test_assets/asset2.txt
  ''';

  @override
  final String main = r'''
  import 'dart:async';

  import 'package:flutter/material.dart';
  import 'deferred_library.dart' deferred as DeferredLibrary;

  Future<void>? libFuture;
  String deferredText = 'incomplete';

  Future<void> main() async {
    while (true) {
      if (libFuture == null) {
        libFuture = DeferredLibrary.loadLibrary();
        libFuture?.whenComplete(() => deferredText = 'complete ${DeferredLibrary.add(10, 42)}');
      }
      runApp(new MyApp());
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      topLevelFunction();
      return new MaterialApp( // BUILD BREAKPOINT
        title: 'Flutter Demo',
        home: new Container(),
      );
    }
  }

  topLevelFunction() {
    print(deferredText); // TOP LEVEL BREAKPOINT
  }
  ''';

  @override
  final DeferredComponentsConfig deferredComponents;
}

/// Contains the necessary files for a bare-bones deferred component release app.
class BasicDeferredComponentsConfig extends DeferredComponentsConfig {
  @override
  String get deferredLibrary => r'''
  library DeferredLibrary;

  int add(int i, int j) {
    return i + j;
  }
  ''';

  @override
  String get deferredComponentsGolden => r'''
  loading-units:
    - id: 2
      libraries:
        - package:test/deferred_library.dart
  ''';

  @override
  String get androidSettings => r'''
  include ':app', ':component1'

  def localPropertiesFile = new File(rootProject.projectDir, "local.properties")
  def properties = new Properties()

  assert localPropertiesFile.exists()
  localPropertiesFile.withReader("UTF-8") { reader -> properties.load(reader) }

  def flutterSdkPath = properties.getProperty("flutter.sdk")
  assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
  apply from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle"
  ''';

  @override
  String get androidBuild => r'''
  buildscript {
      ext.kotlin_version = '1.3.50'
      repositories {
          google()
          jcenter()
      }

      dependencies {
          classpath 'com.android.tools.build:gradle:4.1.0'
          classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
      }
  }

  allprojects {
      repositories {
          google()
          jcenter()
      }
  }

  rootProject.buildDir = '../build'
  subprojects {
      project.buildDir = "${rootProject.buildDir}/${project.name}"
      project.evaluationDependsOn(':app')
  }

  task clean(type: Delete) {
      delete rootProject.buildDir
  }
  ''';

  @override
  String get appBuild => r'''
  def localProperties = new Properties()
  def localPropertiesFile = rootProject.file('local.properties')
  if (localPropertiesFile.exists()) {
      localPropertiesFile.withReader('UTF-8') { reader ->
          localProperties.load(reader)
      }
  }

  def flutterRoot = localProperties.getProperty('flutter.sdk')
  if (flutterRoot == null) {
      throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
  }

  def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
  if (flutterVersionCode == null) {
      flutterVersionCode = '1'
  }

  def flutterVersionName = localProperties.getProperty('flutter.versionName')
  if (flutterVersionName == null) {
      flutterVersionName = '1.0'
  }

  def keystoreProperties = new Properties()
  def keystorePropertiesFile = rootProject.file('key.properties')
  if (keystorePropertiesFile.exists()) {
      keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
  }

  apply plugin: 'com.android.application'
  apply plugin: 'kotlin-android'
  apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

  android {
      compileSdkVersion 30

      sourceSets {
          main.java.srcDirs += 'src/main/kotlin'
      }

      lintOptions {
          disable 'InvalidPackage'
      }

      defaultConfig {
          // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
          applicationId "ninja.qian.splitaottest1"
          minSdkVersion 16
          targetSdkVersion 30
          versionCode flutterVersionCode.toInteger()
          versionName flutterVersionName
      }
      signingConfigs {
          release {
              keyAlias keystoreProperties['keyAlias']
              keyPassword keystoreProperties['keyPassword']
              storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
              storePassword keystoreProperties['storePassword']
          }
      }
      buildTypes {
          release {
              // TODO: Add your own signing config for the release build.
              // Signing with the debug keys for now, so `flutter run --release` works.
              signingConfig signingConfigs.release
          }
      }
  }

  flutter {
      source '../..'
  }

  dependencies {
      implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
      implementation "com.google.android.play:core:1.8.0"
  }

  ''';

  @override
  String get androidLocalProperties => '''
  flutter.sdk=${getFlutterRoot()}
  flutter.buildMode=release
  flutter.versionName=1.0.0
  flutter.versionCode=22
  ''';

  @override
  String get androidGradleProperties => '''
  org.gradle.jvmargs=-Xmx1536M
  android.useAndroidX=true
  android.enableJetifier=true
  android.enableR8=true
  android.experimental.enableNewResourceShrinker=true
  ''';

  @override
  String get androidKeyProperties => '''
  storePassword=123456
  keyPassword=123456
  keyAlias=test_release_key
  storeFile=key.jks
  ''';

  // This is a test jks keystore, generated for testing use only. Do not use this key in an actual
  // application.
  @override
  final List<int> androidKey = <int>[
    0xfe, 0xed, 0xfe, 0xed, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x10, 0x74, 0x65, 0x73, 0x74, 0x5f, 0x72, 0x65, 0x6c, 0x65, 0x61, 0x73, 0x65, 0x5f, 0x6b,
    0x65, 0x79, 0x00, 0x00, 0x01, 0x77, 0x87, 0xc9, 0x8c, 0x4f, 0x00, 0x00, 0x05, 0x00, 0x30, 0x82,
    0x04, 0xfc, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06, 0x01, 0x04, 0x01, 0x2a, 0x02, 0x11, 0x01, 0x01,
    0x05, 0x00, 0x04, 0x82, 0x04, 0xe8, 0xe2, 0xca, 0x1f, 0xd5, 0x47, 0xf1, 0x6a, 0x4a, 0xc5, 0xf8,
    0x0b, 0xc1, 0x11, 0x36, 0xfc, 0xb3, 0x25, 0xb3, 0x54, 0x34, 0x53, 0x2c, 0x71, 0x81, 0xd6, 0x64,
    0x54, 0xef, 0x5f, 0x85, 0x27, 0xbe, 0xe5, 0x0a, 0x08, 0xc0, 0x76, 0x2d, 0xec, 0xbf, 0x82, 0x9f,
    0xf9, 0xf0, 0xb3, 0x20, 0x86, 0x9b, 0x25, 0x01, 0x02, 0x15, 0xa8, 0x78, 0x53, 0xd9, 0x97, 0xb8,
    0x15, 0x84, 0xad, 0x21, 0xe7, 0x04, 0x01, 0x53, 0xc0, 0x8f, 0x14, 0x0c, 0x45, 0xe0, 0x7a, 0x4e,
    0x95, 0x4e, 0xa9, 0xcd, 0x23, 0xbf, 0x78, 0xcd, 0x10, 0xd3, 0x09, 0xec, 0xfd, 0x64, 0x8d, 0xec,
    0xe8, 0x02, 0x3e, 0x5a, 0x04, 0x0b, 0xd3, 0x57, 0x66, 0xb9, 0xd0, 0x28, 0xcf, 0x28, 0x04, 0x6e,
    0x45, 0x67, 0x81, 0xb9, 0x1a, 0x64, 0xd6, 0x05, 0xf5, 0x3d, 0x90, 0x8e, 0x2d, 0x52, 0x95, 0x51,
    0x5c, 0x26, 0xcc, 0x43, 0x86, 0x7f, 0x07, 0x8c, 0xf8, 0x06, 0x25, 0xff, 0x53, 0xb4, 0x2b, 0x87,
    0xef, 0x93, 0xac, 0x99, 0xc3, 0x35, 0x6e, 0x1c, 0xf0, 0x9f, 0xb1, 0xda, 0x30, 0x88, 0x1a, 0x50,
    0xa5, 0x53, 0x39, 0xef, 0x4b, 0x5c, 0xc7, 0x72, 0xc6, 0xe2, 0xf6, 0x2e, 0xf3, 0xcc, 0xc8, 0xd8,
    0x80, 0xe5, 0x64, 0x45, 0xcb, 0xcc, 0x8c, 0x93, 0x7e, 0x00, 0x49, 0x3f, 0x27, 0xd8, 0xa1, 0xb2,
    0xa4, 0x7c, 0xc7, 0x39, 0xc9, 0x27, 0x1a, 0x2e, 0xca, 0x88, 0x7f, 0xf1, 0xf1, 0xad, 0x68, 0xb9,
    0x6b, 0xd8, 0xfe, 0xf1, 0xda, 0xad, 0x2d, 0xb2, 0x08, 0x33, 0x42, 0x12, 0x4b, 0x1f, 0x93, 0x17,
    0x7d, 0x50, 0xba, 0x68, 0x86, 0xdd, 0x61, 0x74, 0x0c, 0xed, 0x55, 0x60, 0x90, 0x01, 0x93, 0x11,
    0x13, 0xc2, 0x39, 0x78, 0xf6, 0xa4, 0x28, 0x8f, 0xa6, 0x63, 0x35, 0x28, 0xbd, 0xa1, 0x95, 0xc5,
    0x31, 0xa2, 0xae, 0x59, 0x67, 0x58, 0x08, 0x57, 0x45, 0xf3, 0x27, 0xfe, 0x83, 0x6a, 0xb3, 0x56,
    0x2c, 0x9b, 0xae, 0xf7, 0x78, 0x88, 0x88, 0xd4, 0xbe, 0x67, 0x11, 0x6a, 0x64, 0x39, 0x99, 0xaf,
    0xad, 0xc5, 0xd6, 0x3e, 0x30, 0x91, 0xee, 0x94, 0xdc, 0x50, 0x33, 0x57, 0x80, 0x1c, 0x4d, 0x80,
    0xda, 0x07, 0xea, 0x8c, 0x37, 0x26, 0x0e, 0xfe, 0xbc, 0x8c, 0x7a, 0xf7, 0x33, 0x3b, 0x85, 0x7c,
    0xc9, 0xf6, 0x44, 0x15, 0xc1, 0xa6, 0x95, 0x1e, 0x3e, 0x4a, 0x70, 0xb1, 0x31, 0xae, 0x1f, 0x61,
    0xad, 0x59, 0xc3, 0xc9, 0xa2, 0x0e, 0x11, 0xb8, 0x25, 0x84, 0x90, 0x66, 0x0c, 0x4b, 0x4a, 0xf4,
    0xec, 0xc0, 0x6a, 0x95, 0x81, 0x22, 0xfc, 0xd1, 0xda, 0xd0, 0x4f, 0x8a, 0x39, 0x6f, 0x24, 0x49,
    0xd7, 0xa6, 0x82, 0xbd, 0x8d, 0x5e, 0xbd, 0xe2, 0x69, 0x9b, 0xb4, 0xde, 0x37, 0x6a, 0x02, 0x7e,
    0x40, 0x8c, 0x3c, 0x34, 0x97, 0xfd, 0xc9, 0xc5, 0x75, 0x74, 0xa5, 0x04, 0x93, 0xa4, 0x04, 0x64,
    0x9f, 0xfd, 0xe2, 0x57, 0x63, 0x11, 0x5e, 0x51, 0x25, 0x36, 0xcc, 0x25, 0xe0, 0xda, 0x6d, 0x82,
    0xfe, 0xd2, 0x7b, 0x40, 0x82, 0x33, 0x69, 0xb0, 0xe8, 0x91, 0xb7, 0x23, 0xac, 0x22, 0x85, 0x98,
    0x3e, 0x02, 0x81, 0xa5, 0x4e, 0xaf, 0x99, 0xf1, 0x1b, 0x73, 0x38, 0xcd, 0x4c, 0xaa, 0x33, 0xdc,
    0x49, 0xd6, 0xf7, 0xdc, 0xa6, 0x59, 0x38, 0x67, 0x89, 0x78, 0x26, 0x8e, 0x1c, 0xee, 0xbe, 0x8b,
    0x6c, 0xae, 0xcf, 0x26, 0x67, 0x2a, 0xe6, 0xbe, 0x24, 0xc3, 0x6f, 0x2b, 0x1a, 0xcf, 0xb6, 0xd0,
    0x82, 0x58, 0x05, 0x44, 0x19, 0x91, 0xfb, 0x9f, 0x53, 0x14, 0x4a, 0xf5, 0x84, 0x54, 0x57, 0x8e,
    0xcc, 0xec, 0x6f, 0x29, 0xdd, 0xa6, 0x38, 0xa4, 0x17, 0x0e, 0x86, 0x63, 0x62, 0xd6, 0x43, 0x1c,
    0xd5, 0xee, 0x93, 0x35, 0x2f, 0x66, 0x35, 0xc8, 0x33, 0x5c, 0x2b, 0xbe, 0xc7, 0xba, 0xf2, 0xd5,
    0xe6, 0x51, 0xe1, 0xac, 0xac, 0x80, 0x71, 0x05, 0xed, 0x8a, 0x2f, 0x47, 0x30, 0xb5, 0x6b, 0x3d,
    0x1d, 0x90, 0xe0, 0x82, 0x76, 0xba, 0x85, 0x7b, 0xb1, 0x78, 0xc1, 0x6f, 0x9c, 0xc1, 0x45, 0xfc,
    0x31, 0x51, 0x04, 0xf3, 0x80, 0x98, 0x9d, 0xd7, 0xd3, 0xef, 0x4b, 0x1a, 0xeb, 0x59, 0x62, 0x97,
    0x64, 0xcd, 0x4b, 0x7f, 0xaf, 0x07, 0x2a, 0xc1, 0x77, 0x4c, 0xa0, 0x29, 0x41, 0x80, 0x01, 0xca,
    0xc5, 0xb2, 0xe0, 0x6e, 0x30, 0x70, 0xc4, 0xcf, 0xf7, 0xd6, 0x7f, 0x1d, 0x84, 0x9e, 0x31, 0x4b,
    0xa8, 0xa8, 0x26, 0x60, 0x7f, 0x76, 0x4c, 0x75, 0x46, 0xcf, 0x86, 0x39, 0xbd, 0x5b, 0x99, 0x1b,
    0x0f, 0xa2, 0x1a, 0x94, 0x62, 0xe7, 0x95, 0x9c, 0xcb, 0x4d, 0x13, 0xa4, 0x84, 0x79, 0xec, 0xd3,
    0x7c, 0xbd, 0x3f, 0xb7, 0x22, 0xa9, 0x14, 0xf0, 0xd3, 0x66, 0xb0, 0xa9, 0xe7, 0xdf, 0x01, 0x47,
    0x5c, 0xb0, 0x8e, 0x49, 0xfa, 0xfd, 0xa9, 0x9f, 0xf4, 0x29, 0x7e, 0x0c, 0x6a, 0x9f, 0x67, 0x7f,
    0x38, 0xe0, 0xe6, 0x48, 0x0d, 0x51, 0x7d, 0x79, 0x0d, 0xb8, 0x27, 0xec, 0x6e, 0x99, 0x3e, 0x00,
    0xb2, 0x18, 0x8e, 0x8d, 0xbf, 0x89, 0xd2, 0x4b, 0xce, 0xcc, 0x64, 0xb7, 0xae, 0x4a, 0x34, 0x8d,
    0xe1, 0x73, 0x4e, 0x2c, 0x50, 0x7e, 0xc5, 0xc7, 0x14, 0xa6, 0x8c, 0x51, 0x5b, 0x4a, 0x94, 0xf2,
    0x16, 0x58, 0x11, 0x1c, 0xc4, 0x81, 0x9d, 0xfc, 0x5d, 0x57, 0xe2, 0x8e, 0xdb, 0x51, 0x99, 0x5f,
    0xd5, 0x71, 0x72, 0x3a, 0xa1, 0xe0, 0xc1, 0x6f, 0xdb, 0x0c, 0xf0, 0x91, 0x7c, 0xb7, 0xc0, 0xf5,
    0x6f, 0x6c, 0x3c, 0xea, 0x0e, 0xd3, 0xab, 0x13, 0xed, 0x1e, 0x55, 0x9e, 0xdf, 0xf7, 0x37, 0x75,
    0x38, 0xb5, 0x07, 0x97, 0x1d, 0x82, 0x5b, 0x28, 0x1f, 0xbd, 0xe3, 0x70, 0xdb, 0x18, 0x3f, 0x69,
    0x95, 0x84, 0x8f, 0x99, 0xc4, 0xa6, 0xed, 0x60, 0xfc, 0x1e, 0x3b, 0x4d, 0x63, 0x34, 0xeb, 0xb8,
    0xd6, 0x18, 0x24, 0xf5, 0xd9, 0x3b, 0xc3, 0xdd, 0x3e, 0x49, 0x55, 0x7a, 0xa3, 0x49, 0x2c, 0x58,
    0x2a, 0x9c, 0x11, 0x21, 0xdc, 0x82, 0xa5, 0xc2, 0xf7, 0x87, 0x3a, 0xd8, 0xe8, 0x03, 0x3a, 0x5c,
    0xdf, 0xac, 0xa7, 0xbe, 0x34, 0x7f, 0x1a, 0xaa, 0xe9, 0x27, 0x91, 0xd0, 0x7c, 0x23, 0x8d, 0x6e,
    0x00, 0x86, 0x4f, 0x23, 0x87, 0xdc, 0x53, 0x99, 0x99, 0x9b, 0xc9, 0xae, 0x50, 0xf1, 0x55, 0xd0,
    0x04, 0x89, 0xe2, 0x2d, 0x5a, 0x2a, 0x54, 0x89, 0xc7, 0x70, 0x48, 0x3e, 0xf1, 0xc8, 0x01, 0x87,
    0x67, 0x35, 0xdb, 0x0f, 0x08, 0x82, 0x62, 0x53, 0xb5, 0x7b, 0xcb, 0xc5, 0x60, 0x85, 0x56, 0xc0,
    0xda, 0xed, 0x1b, 0x06, 0x02, 0xfc, 0xa9, 0x55, 0x99, 0x71, 0x54, 0x88, 0xd7, 0x33, 0xb4, 0xce,
    0x85, 0x2f, 0x24, 0x82, 0x80, 0xb3, 0xca, 0x56, 0x33, 0x3b, 0x5a, 0x2a, 0xd5, 0xed, 0xbb, 0x6b,
    0xc9, 0xc1, 0x26, 0x93, 0x51, 0xe2, 0x01, 0x88, 0x39, 0xe4, 0xe7, 0x56, 0xd3, 0x0f, 0x5d, 0xe9,
    0xfd, 0xcd, 0xeb, 0x13, 0xd6, 0xa0, 0xe3, 0x6c, 0x57, 0x50, 0x09, 0xe8, 0xb2, 0xd4, 0x47, 0xd9,
    0x0c, 0x3e, 0xac, 0xee, 0x65, 0x53, 0x8d, 0x00, 0x95, 0x90, 0x58, 0x94, 0x32, 0x1a, 0x32, 0xe2,
    0xe2, 0xc9, 0x66, 0x6d, 0xc8, 0xf2, 0x1e, 0x70, 0xe5, 0xaa, 0xa6, 0x48, 0xad, 0x4a, 0xaf, 0x2a,
    0x97, 0x59, 0x5e, 0x79, 0xec, 0xdf, 0x1f, 0xe1, 0x37, 0xb5, 0x48, 0x6f, 0x0e, 0xab, 0xce, 0x29,
    0x32, 0x99, 0x8d, 0xe0, 0xc9, 0x73, 0xba, 0x76, 0xa1, 0x25, 0xd8, 0x98, 0x19, 0x67, 0x87, 0x24,
    0x00, 0xbb, 0x52, 0x15, 0x41, 0x28, 0x56, 0x1a, 0x6c, 0xb5, 0xbc, 0x4c, 0xcc, 0x17, 0x8a, 0xc7,
    0x1b, 0xc9, 0xea, 0x31, 0xbb, 0x68, 0x16, 0x5a, 0x72, 0x04, 0xbf, 0x9d, 0x3a, 0xb1, 0xc6, 0xe0,
    0x45, 0x51, 0x39, 0x03, 0x48, 0x82, 0xa6, 0x0c, 0x8a, 0xd2, 0x22, 0x30, 0xf3, 0x74, 0x4d, 0xd3,
    0x5c, 0x6c, 0x3e, 0x36, 0x90, 0xc5, 0xe6, 0xcf, 0xd3, 0xde, 0x68, 0x6a, 0x43, 0x5b, 0x2b, 0x90,
    0xbe, 0xa6, 0x23, 0xa0, 0x3b, 0x40, 0x6b, 0x99, 0x60, 0xdf, 0xff, 0x9f, 0x7c, 0x84, 0xc7, 0xf0,
    0xc7, 0x99, 0x1b, 0x99, 0x50, 0x06, 0x9b, 0xe7, 0x78, 0x2a, 0x4e, 0x76, 0x81, 0xea, 0x06, 0x29,
    0xab, 0xd8, 0xa6, 0x1e, 0x7f, 0x5a, 0x28, 0x0b, 0x90, 0x0e, 0x5d, 0x04, 0xf7, 0x57, 0x0a, 0x31,
    0x14, 0x2c, 0x84, 0x56, 0x57, 0x17, 0x8a, 0xa0, 0xd7, 0x7c, 0x3a, 0xf7, 0xda, 0x8d, 0x8a, 0xcb,
    0x47, 0xe8, 0xb2, 0xee, 0x32, 0x2a, 0xf8, 0x42, 0x42, 0xd8, 0x75, 0x8c, 0x47, 0x73, 0x2a, 0x87,
    0xe0, 0x0a, 0xe8, 0x6f, 0xed, 0xf2, 0x1a, 0x14, 0x3a, 0x59, 0xc7, 0x8e, 0x21, 0x72, 0xf7, 0x05,
    0x5b, 0xd1, 0x2b, 0x7d, 0x53, 0xfb, 0x22, 0xfb, 0x7e, 0xe7, 0x25, 0x0b, 0x1c, 0x15, 0xb2, 0xde,
    0xdf, 0x66, 0xcc, 0xe9, 0x30, 0xfc, 0x75, 0x8c, 0xa3, 0x09, 0xab, 0x42, 0x27, 0x6b, 0x33, 0xa0,
    0xdf, 0x15, 0xa4, 0x00, 0x10, 0x18, 0xe5, 0x10, 0x97, 0x47, 0xe9, 0x2e, 0x65, 0xd3, 0x9e, 0x44,
    0x1b, 0xaf, 0x36, 0x60, 0xcf, 0xe2, 0x1a, 0x6b, 0xbe, 0x7b, 0x1f, 0x80, 0xdd, 0x5c, 0x10, 0x5c,
    0x89, 0x23, 0xba, 0xa1, 0x98, 0xcc, 0x88, 0x74, 0xbf, 0x26, 0x4c, 0x0c, 0xa5, 0xc7, 0x00, 0x00,
    0x00, 0x01, 0x00, 0x05, 0x58, 0x2e, 0x35, 0x30, 0x39, 0x00, 0x00, 0x03, 0x7f, 0x30, 0x82, 0x03,
    0x7b, 0x30, 0x82, 0x02, 0x63, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x04, 0x22, 0x12, 0x53, 0x46,
    0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x0b, 0x05, 0x00, 0x30,
    0x6d, 0x31, 0x0b, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31, 0x13,
    0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x08, 0x13, 0x0a, 0x43, 0x61, 0x6c, 0x69, 0x66, 0x6f, 0x72,
    0x6e, 0x69, 0x61, 0x31, 0x16, 0x30, 0x14, 0x06, 0x03, 0x55, 0x04, 0x07, 0x13, 0x0d, 0x4d, 0x6f,
    0x75, 0x6e, 0x74, 0x61, 0x69, 0x6e, 0x20, 0x56, 0x69, 0x65, 0x77, 0x31, 0x10, 0x30, 0x0e, 0x06,
    0x03, 0x55, 0x04, 0x0a, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74, 0x65, 0x72, 0x31, 0x10, 0x30,
    0x0e, 0x06, 0x03, 0x55, 0x04, 0x0b, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74, 0x65, 0x72, 0x31,
    0x0d, 0x30, 0x0b, 0x06, 0x03, 0x55, 0x04, 0x03, 0x13, 0x04, 0x44, 0x61, 0x73, 0x68, 0x30, 0x20,
    0x17, 0x0d, 0x32, 0x31, 0x30, 0x32, 0x30, 0x39, 0x31, 0x37, 0x31, 0x34, 0x32, 0x37, 0x5a, 0x18,
    0x0f, 0x32, 0x32, 0x39, 0x34, 0x31, 0x31, 0x32, 0x35, 0x31, 0x37, 0x31, 0x34, 0x32, 0x37, 0x5a,
    0x30, 0x6d, 0x31, 0x0b, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31,
    0x13, 0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x08, 0x13, 0x0a, 0x43, 0x61, 0x6c, 0x69, 0x66, 0x6f,
    0x72, 0x6e, 0x69, 0x61, 0x31, 0x16, 0x30, 0x14, 0x06, 0x03, 0x55, 0x04, 0x07, 0x13, 0x0d, 0x4d,
    0x6f, 0x75, 0x6e, 0x74, 0x61, 0x69, 0x6e, 0x20, 0x56, 0x69, 0x65, 0x77, 0x31, 0x10, 0x30, 0x0e,
    0x06, 0x03, 0x55, 0x04, 0x0a, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74, 0x65, 0x72, 0x31, 0x10,
    0x30, 0x0e, 0x06, 0x03, 0x55, 0x04, 0x0b, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74, 0x65, 0x72,
    0x31, 0x0d, 0x30, 0x0b, 0x06, 0x03, 0x55, 0x04, 0x03, 0x13, 0x04, 0x44, 0x61, 0x73, 0x68, 0x30,
    0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01,
    0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00, 0x30, 0x82, 0x01, 0x0a, 0x02, 0x82, 0x01, 0x01, 0x00,
    0x94, 0x7d, 0x0d, 0x32, 0x57, 0xf8, 0x90, 0x9b, 0x5a, 0xc5, 0x61, 0x48, 0xa8, 0xbb, 0x5e, 0x9d,
    0x4c, 0x4f, 0x53, 0xb9, 0x3b, 0x1f, 0x46, 0xc4, 0xd1, 0xba, 0x69, 0x7b, 0x71, 0x37, 0x20, 0xa1,
    0x44, 0x4f, 0xd1, 0x87, 0x71, 0x88, 0xc9, 0xe4, 0x49, 0xe1, 0xf0, 0x3d, 0x18, 0xca, 0xf7, 0x56,
    0xc4, 0x61, 0x4e, 0xa7, 0x9a, 0x93, 0x26, 0x8b, 0x03, 0x01, 0xa8, 0xef, 0x44, 0x89, 0xc6, 0x4d,
    0xab, 0x63, 0x92, 0xb2, 0xb5, 0xcd, 0x51, 0xb4, 0x12, 0x98, 0x2b, 0x89, 0x73, 0x28, 0xfa, 0x73,
    0xb2, 0xf4, 0xb7, 0xf2, 0x85, 0x3f, 0xe8, 0xf0, 0x38, 0x4f, 0x1d, 0xd0, 0x3b, 0xe7, 0xd3, 0xf0,
    0x22, 0xfd, 0x50, 0x11, 0x6d, 0x20, 0xe4, 0x8d, 0x87, 0xd7, 0x99, 0xd4, 0x70, 0x4e, 0xb9, 0xcb,
    0x5b, 0xbb, 0x4f, 0xd9, 0xa6, 0xf6, 0x51, 0x8b, 0x44, 0x5b, 0x9d, 0x68, 0x0b, 0x40, 0x2d, 0x11,
    0x18, 0xdc, 0xb6, 0x29, 0x73, 0xdb, 0x6a, 0x00, 0x12, 0xa0, 0x9f, 0xf4, 0xed, 0xeb, 0xa3, 0x4b,
    0x60, 0xdc, 0x51, 0xed, 0xbe, 0x6c, 0x70, 0x4b, 0x32, 0xda, 0xa0, 0x53, 0x15, 0xac, 0x5e, 0xfd,
    0x4d, 0x14, 0xd7, 0x75, 0xc8, 0x6f, 0x02, 0x85, 0x33, 0x95, 0xbe, 0x86, 0xee, 0x6d, 0x4d, 0x75,
    0x0f, 0x64, 0xfe, 0x9d, 0xa1, 0x3f, 0x53, 0x1b, 0xa1, 0xeb, 0x7b, 0xe6, 0xdd, 0xa1, 0x0a, 0x38,
    0xad, 0xce, 0xa3, 0x66, 0xda, 0x51, 0x38, 0xf3, 0x33, 0x3d, 0x96, 0x06, 0xa5, 0x0e, 0xa7, 0xfd,
    0xb2, 0x7b, 0xd5, 0x21, 0x1a, 0x35, 0x76, 0x25, 0x95, 0x97, 0xd6, 0xd2, 0xfe, 0xbd, 0x86, 0x22,
    0x05, 0xa3, 0x7d, 0x67, 0x60, 0x86, 0x04, 0xc3, 0xa5, 0xd3, 0xb7, 0x40, 0x0c, 0x31, 0x30, 0xc8,
    0x93, 0xb7, 0x61, 0xb3, 0x68, 0x90, 0x9d, 0xa0, 0x49, 0x79, 0x9b, 0xc1, 0x9c, 0x47, 0xa8, 0x81,
    0x02, 0x03, 0x01, 0x00, 0x01, 0xa3, 0x21, 0x30, 0x1f, 0x30, 0x1d, 0x06, 0x03, 0x55, 0x1d, 0x0e,
    0x04, 0x16, 0x04, 0x14, 0x71, 0x50, 0x13, 0x2c, 0x3e, 0xaa, 0xfc, 0x7e, 0x6d, 0x16, 0x18, 0xc0,
    0x6f, 0x32, 0x2e, 0xf0, 0xe1, 0x03, 0x46, 0x94, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
    0xf7, 0x0d, 0x01, 0x01, 0x0b, 0x05, 0x00, 0x03, 0x82, 0x01, 0x01, 0x00, 0x24, 0x98, 0xc6, 0xd6,
    0xab, 0xb3, 0x94, 0xa1, 0x5d, 0x50, 0x0a, 0x82, 0xf7, 0x1d, 0xf5, 0xdf, 0x93, 0xf2, 0xf2, 0xf2,
    0xe6, 0x2a, 0x28, 0x67, 0x06, 0x36, 0xf6, 0x1f, 0x8c, 0xa3, 0x41, 0x43, 0x98, 0xc4, 0x6a, 0xd0,
    0x14, 0x0b, 0x1b, 0x89, 0x75, 0xb1, 0xe5, 0x79, 0x2c, 0xe8, 0xfd, 0x6d, 0x77, 0x72, 0xaa, 0x06,
    0x15, 0xd3, 0xca, 0x95, 0xca, 0x7d, 0xd5, 0xce, 0xca, 0x5f, 0x88, 0xd2, 0x3c, 0x08, 0xd2, 0x83,
    0xed, 0x7a, 0x0d, 0x2f, 0x34, 0x37, 0x97, 0x75, 0xd1, 0x2c, 0xa6, 0x30, 0x68, 0x8e, 0x19, 0x23,
    0x3d, 0x22, 0x62, 0x73, 0x4e, 0xd5, 0x42, 0x09, 0x82, 0xb6, 0x06, 0x17, 0xb8, 0xb6, 0x08, 0x64,
    0x73, 0x93, 0x02, 0x87, 0xd4, 0xf6, 0xa6, 0xce, 0xad, 0xfd, 0xcc, 0x9f, 0x69, 0x8b, 0xa8, 0xb3,
    0x4a, 0x45, 0x9e, 0xad, 0xa7, 0xf2, 0xb5, 0x91, 0xc8, 0x61, 0x48, 0x95, 0x8b, 0x36, 0x3e, 0x2f,
    0x40, 0x80, 0x69, 0xab, 0x3d, 0x45, 0xe1, 0x60, 0x3a, 0xe8, 0x33, 0x06, 0x12, 0x1a, 0x7e, 0x6e,
    0x11, 0x01, 0xb9, 0x66, 0x1b, 0x61, 0xbf, 0x01, 0x6d, 0x1d, 0x33, 0x58, 0x9a, 0xdd, 0x12, 0xf8,
    0xc1, 0xa3, 0x71, 0x89, 0x72, 0xed, 0xf4, 0xb2, 0xf3, 0x39, 0xc3, 0xf1, 0xf1, 0xe3, 0xe1, 0x9b,
    0xce, 0xc7, 0x83, 0x80, 0x32, 0x76, 0x16, 0x8c, 0x95, 0x35, 0xc0, 0xe8, 0xae, 0x02, 0x1b, 0x05,
    0x21, 0x36, 0xed, 0x4a, 0x71, 0xe0, 0x18, 0x76, 0xaa, 0xb9, 0x98, 0x07, 0x35, 0x27, 0x9b, 0xf2,
    0x5d, 0xdc, 0x79, 0xe6, 0xaa, 0x4a, 0x01, 0x23, 0x7d, 0x6d, 0x21, 0xbd, 0x97, 0x1b, 0x41, 0x60,
    0x7c, 0xb7, 0xfa, 0x21, 0x48, 0x52, 0x22, 0x94, 0x2d, 0xb0, 0xef, 0x2d, 0xc3, 0xe2, 0xe6, 0x37,
    0x55, 0x9d, 0xd9, 0x4d, 0xdd, 0xdd, 0x25, 0x25, 0x6b, 0x13, 0xb6, 0xb0, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x08, 0x74, 0x65, 0x73, 0x74, 0x5f, 0x6b, 0x65, 0x79, 0x00, 0x00, 0x01, 0x77, 0x87, 0xc7,
    0x7b, 0x73, 0x00, 0x00, 0x02, 0xba, 0x30, 0x82, 0x02, 0xb6, 0x30, 0x0e, 0x06, 0x0a, 0x2b, 0x06,
    0x01, 0x04, 0x01, 0x2a, 0x02, 0x11, 0x01, 0x01, 0x05, 0x00, 0x04, 0x82, 0x02, 0xa2, 0x23, 0xce,
    0x04, 0x35, 0x63, 0x08, 0xa7, 0x0b, 0x42, 0x93, 0x53, 0x16, 0xa6, 0xbe, 0x54, 0xf2, 0xe4, 0x27,
    0x8d, 0xbb, 0x64, 0xe4, 0x23, 0xeb, 0x70, 0x6c, 0xd5, 0x28, 0xe7, 0x8b, 0x73, 0x68, 0xd0, 0x03,
    0xc5, 0x32, 0xfe, 0x4d, 0x80, 0xa5, 0xff, 0xcd, 0xf0, 0x5c, 0x31, 0xd1, 0xf0, 0xf1, 0xc7, 0x53,
    0xeb, 0xea, 0xa3, 0xb1, 0x07, 0xdc, 0x6b, 0x9a, 0xff, 0xcd, 0x36, 0x88, 0x83, 0x6c, 0x0a, 0xbf,
    0x85, 0x3a, 0x5d, 0xc4, 0x54, 0x0a, 0x63, 0xd6, 0xf1, 0x30, 0xa8, 0x18, 0x89, 0x6d, 0xba, 0x27,
    0x7f, 0xdc, 0xe1, 0x38, 0x6b, 0xa7, 0xc4, 0x2e, 0xdc, 0x21, 0x01, 0xf6, 0xdc, 0xc9, 0x36, 0x2a,
    0x6e, 0xb7, 0xbc, 0xdd, 0xe2, 0xd8, 0x44, 0x16, 0x9e, 0x28, 0x34, 0x9d, 0x59, 0x43, 0xc3, 0xe9,
    0x21, 0xb1, 0x46, 0x6b, 0x08, 0x81, 0x51, 0xa8, 0xa6, 0x84, 0xe1, 0xe3, 0x7d, 0x60, 0x6c, 0x3d,
    0xbc, 0x28, 0xea, 0xe7, 0x10, 0xd4, 0x07, 0xcc, 0x2e, 0xa4, 0xed, 0x66, 0xe6, 0xaa, 0xbf, 0xf5,
    0x95, 0xd9, 0xc9, 0xcd, 0x69, 0x44, 0xc6, 0x46, 0x66, 0xab, 0x99, 0xdb, 0x74, 0x9f, 0x7f, 0x4e,
    0x02, 0x37, 0x1e, 0x23, 0x52, 0x58, 0x10, 0x8c, 0x41, 0x6f, 0xe4, 0xc1, 0xca, 0x1e, 0xd0, 0xd3,
    0x8e, 0xd0, 0x36, 0xc6, 0xea, 0x61, 0x3d, 0x97, 0x35, 0x54, 0x81, 0xc4, 0x0e, 0x1a, 0x05, 0xa3,
    0x2b, 0x0b, 0x9e, 0xb2, 0x0d, 0xe9, 0xfc, 0x3a, 0xd9, 0x02, 0xce, 0x1b, 0x56, 0x92, 0x1a, 0x97,
    0x78, 0xda, 0xba, 0x40, 0x2c, 0x7c, 0x96, 0xe1, 0x94, 0x88, 0x1a, 0x7b, 0x47, 0x77, 0x59, 0xcf,
    0x98, 0x52, 0xb0, 0xfb, 0xcb, 0xb5, 0xf5, 0xe4, 0x16, 0x38, 0xb6, 0x05, 0x20, 0x5c, 0x36, 0x19,
    0xc5, 0xa9, 0x70, 0xe6, 0x89, 0x9f, 0x76, 0x3d, 0x88, 0x78, 0x56, 0xf2, 0x85, 0xff, 0x89, 0xc3,
    0xc5, 0x32, 0xd3, 0xb0, 0x8f, 0x1c, 0xc3, 0x23, 0xb4, 0x70, 0xd4, 0x8b, 0xd3, 0x6c, 0x27, 0xd1,
    0xc4, 0xe9, 0x0a, 0xaa, 0x06, 0x3a, 0xd3, 0xd6, 0x20, 0xe1, 0x08, 0x65, 0x10, 0x50, 0x45, 0x59,
    0xa5, 0xd4, 0xb2, 0xd5, 0xcb, 0x74, 0x52, 0x05, 0x95, 0x08, 0xe4, 0xb9, 0xe9, 0xc9, 0x7f, 0xbc,
    0x4b, 0x3f, 0xfa, 0x00, 0x5c, 0x20, 0xda, 0x8e, 0xb2, 0xe0, 0x4e, 0x51, 0x0e, 0xfe, 0x98, 0xd8,
    0xe9, 0xd5, 0x44, 0x0b, 0x1c, 0x1f, 0xe3, 0xa6, 0xc5, 0x03, 0xb1, 0x5e, 0x23, 0x7a, 0x0a, 0x1e,
    0xa1, 0x49, 0xaf, 0xea, 0xb8, 0xea, 0x74, 0x64, 0x05, 0xda, 0xad, 0xb3, 0x5f, 0x17, 0xa9, 0x9a,
    0x89, 0x16, 0x6d, 0xd2, 0xef, 0xa1, 0x35, 0x40, 0x43, 0x71, 0xee, 0x6c, 0x0c, 0x99, 0xbf, 0xcf,
    0xd5, 0xae, 0xad, 0x83, 0xeb, 0x60, 0x8d, 0x4e, 0xae, 0xe2, 0x01, 0xcb, 0xbe, 0x18, 0x94, 0x39,
    0xdf, 0xcb, 0xae, 0x47, 0xf7, 0x89, 0x9c, 0x37, 0x35, 0x43, 0x9b, 0xb4, 0x6c, 0xb9, 0x86, 0xc5,
    0xd6, 0x39, 0xd3, 0x47, 0x1f, 0x91, 0x8d, 0xe8, 0xd3, 0x13, 0xe7, 0xe2, 0x2c, 0x27, 0x36, 0xd9,
    0xc8, 0xf4, 0xc6, 0x25, 0x78, 0x02, 0x78, 0x31, 0x7f, 0x8a, 0xa1, 0x32, 0x50, 0x4d, 0xc1, 0x49,
    0x23, 0x8c, 0x72, 0x09, 0xc8, 0xe3, 0x7e, 0xa0, 0xdd, 0x1b, 0x96, 0x47, 0x24, 0xab, 0xb4, 0x14,
    0x6d, 0x07, 0x8e, 0x90, 0x29, 0x6c, 0xb2, 0x13, 0xe4, 0xe1, 0x69, 0x17, 0xfd, 0xb8, 0x9e, 0x52,
    0x90, 0x19, 0xbe, 0xf6, 0xd7, 0x60, 0x0e, 0x22, 0xb5, 0x01, 0x45, 0xab, 0xf5, 0xe4, 0x2e, 0x53,
    0x3f, 0xf0, 0x58, 0xbb, 0x2c, 0xa5, 0x31, 0x59, 0x4e, 0x4b, 0xf0, 0x3e, 0x36, 0x77, 0xe0, 0x05,
    0x38, 0x81, 0x07, 0xf6, 0x53, 0xf3, 0xff, 0x0c, 0x8d, 0x6d, 0xbc, 0xa9, 0x6f, 0x6a, 0x75, 0xef,
    0x99, 0x01, 0xc9, 0xd6, 0x4d, 0xa4, 0x9b, 0x35, 0x95, 0xe3, 0x20, 0xfd, 0x13, 0x51, 0x71, 0xbb,
    0xbd, 0x93, 0xc4, 0x8b, 0x98, 0x6c, 0x8c, 0x6a, 0x30, 0xea, 0x3e, 0xe7, 0x9b, 0x98, 0x10, 0xab,
    0x03, 0x3a, 0x90, 0xf4, 0x98, 0xf1, 0x30, 0xa5, 0xd6, 0x3a, 0x06, 0x62, 0xc0, 0x39, 0xf7, 0x36,
    0xa5, 0x66, 0xfd, 0x3d, 0x30, 0x51, 0x7a, 0x4d, 0x06, 0xf9, 0xfe, 0xa5, 0xda, 0xa8, 0x80, 0xaa,
    0x50, 0x5d, 0xff, 0xf2, 0x23, 0x6f, 0x1a, 0x7d, 0x63, 0xa6, 0x6a, 0x64, 0x5c, 0x2a, 0xeb, 0x83,
    0x42, 0x29, 0x5e, 0x26, 0x9d, 0x25, 0x0f, 0x58, 0xb6, 0x3b, 0x48, 0x66, 0xb0, 0x1f, 0x40, 0x07,
    0x85, 0xd4, 0xc3, 0x61, 0x7a, 0xa5, 0x6b, 0xa1, 0x61, 0x09, 0x78, 0x03, 0x58, 0xfa, 0x52, 0xde,
    0xb4, 0xf2, 0xc7, 0x40, 0x94, 0x7b, 0x6c, 0x4f, 0xec, 0x5f, 0x17, 0xdf, 0x97, 0xd2, 0x95, 0xa6,
    0x94, 0x8b, 0xb7, 0xcf, 0x05, 0x3d, 0x9d, 0xcc, 0x55, 0x1e, 0x83, 0x79, 0xf9, 0xe6, 0x22, 0x8e,
    0xdd, 0x20, 0x22, 0x87, 0x3b, 0xb6, 0x79, 0xc9, 0xcf, 0x4c, 0x8f, 0xbb, 0x4e, 0x1f, 0xd6, 0xa5,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x05, 0x58, 0x2e, 0x35, 0x30, 0x39, 0x00, 0x00, 0x02, 0x7a, 0x30,
    0x82, 0x02, 0x76, 0x30, 0x82, 0x01, 0xdf, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x04, 0x44, 0xbb,
    0xd2, 0x52, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x0b, 0x05,
    0x00, 0x30, 0x6d, 0x31, 0x0b, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53,
    0x31, 0x13, 0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x08, 0x13, 0x0a, 0x43, 0x61, 0x6c, 0x69, 0x66,
    0x6f, 0x72, 0x6e, 0x69, 0x61, 0x31, 0x16, 0x30, 0x14, 0x06, 0x03, 0x55, 0x04, 0x07, 0x13, 0x0d,
    0x4d, 0x6f, 0x75, 0x6e, 0x74, 0x61, 0x69, 0x6e, 0x20, 0x56, 0x69, 0x65, 0x77, 0x31, 0x10, 0x30,
    0x0e, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74, 0x65, 0x72, 0x31,
    0x10, 0x30, 0x0e, 0x06, 0x03, 0x55, 0x04, 0x0b, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74, 0x65,
    0x72, 0x31, 0x0d, 0x30, 0x0b, 0x06, 0x03, 0x55, 0x04, 0x03, 0x13, 0x04, 0x44, 0x61, 0x73, 0x68,
    0x30, 0x20, 0x17, 0x0d, 0x32, 0x31, 0x30, 0x32, 0x30, 0x39, 0x31, 0x37, 0x31, 0x32, 0x31, 0x30,
    0x5a, 0x18, 0x0f, 0x34, 0x37, 0x35, 0x39, 0x30, 0x31, 0x30, 0x37, 0x31, 0x37, 0x31, 0x32, 0x31,
    0x30, 0x5a, 0x30, 0x6d, 0x31, 0x0b, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55,
    0x53, 0x31, 0x13, 0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x08, 0x13, 0x0a, 0x43, 0x61, 0x6c, 0x69,
    0x66, 0x6f, 0x72, 0x6e, 0x69, 0x61, 0x31, 0x16, 0x30, 0x14, 0x06, 0x03, 0x55, 0x04, 0x07, 0x13,
    0x0d, 0x4d, 0x6f, 0x75, 0x6e, 0x74, 0x61, 0x69, 0x6e, 0x20, 0x56, 0x69, 0x65, 0x77, 0x31, 0x10,
    0x30, 0x0e, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74, 0x65, 0x72,
    0x31, 0x10, 0x30, 0x0e, 0x06, 0x03, 0x55, 0x04, 0x0b, 0x13, 0x07, 0x46, 0x6c, 0x75, 0x74, 0x74,
    0x65, 0x72, 0x31, 0x0d, 0x30, 0x0b, 0x06, 0x03, 0x55, 0x04, 0x03, 0x13, 0x04, 0x44, 0x61, 0x73,
    0x68, 0x30, 0x81, 0x9f, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
    0x01, 0x05, 0x00, 0x03, 0x81, 0x8d, 0x00, 0x30, 0x81, 0x89, 0x02, 0x81, 0x81, 0x00, 0xce, 0x0c,
    0xe2, 0x0c, 0xc5, 0xb8, 0x20, 0x93, 0xf7, 0x7a, 0x38, 0x3c, 0xb5, 0x52, 0x1c, 0x48, 0x1a, 0x44,
    0xba, 0xca, 0x88, 0xa0, 0xf0, 0xd6, 0xad, 0x91, 0x9e, 0x0c, 0x09, 0x64, 0xdd, 0x2d, 0x84, 0x0f,
    0x9e, 0xcb, 0xbb, 0xd9, 0x24, 0xd6, 0xd6, 0xaa, 0x63, 0x1c, 0xfa, 0xb6, 0x45, 0x88, 0xf4, 0x8e,
    0xb9, 0x2e, 0xe9, 0xa9, 0xed, 0x6b, 0xda, 0xc6, 0x6b, 0x91, 0x06, 0xf9, 0x0a, 0x71, 0x42, 0x2e,
    0x18, 0x97, 0x80, 0x0c, 0x84, 0xea, 0x69, 0x8f, 0xc0, 0xb0, 0xa8, 0x76, 0xfc, 0x31, 0x86, 0xf9,
    0x09, 0x7e, 0xa4, 0xff, 0x24, 0x94, 0x79, 0x29, 0xca, 0xd0, 0x9a, 0x07, 0xf3, 0x25, 0x21, 0xa7,
    0x61, 0x6e, 0x81, 0x1c, 0x13, 0x02, 0xc9, 0xec, 0xa4, 0x42, 0xcc, 0x6c, 0x95, 0x01, 0xe5, 0x51,
    0x8e, 0x4a, 0xb3, 0x0b, 0x29, 0xf1, 0x8a, 0x1c, 0xb5, 0xe1, 0x41, 0xb6, 0xe3, 0x3d, 0x02, 0x03,
    0x01, 0x00, 0x01, 0xa3, 0x21, 0x30, 0x1f, 0x30, 0x1d, 0x06, 0x03, 0x55, 0x1d, 0x0e, 0x04, 0x16,
    0x04, 0x14, 0x5f, 0xf5, 0x0a, 0x1f, 0xe7, 0xf5, 0xde, 0xbd, 0x7c, 0x59, 0xdd, 0x94, 0x26, 0x39,
    0xf5, 0xc9, 0x21, 0x88, 0xbf, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d,
    0x01, 0x01, 0x0b, 0x05, 0x00, 0x03, 0x81, 0x81, 0x00, 0x17, 0x3d, 0x26, 0x25, 0xfb, 0xd1, 0x5b,
    0x9b, 0xd5, 0xed, 0x84, 0x4f, 0x06, 0xa3, 0x4c, 0x17, 0x6d, 0x91, 0xa9, 0x19, 0xc8, 0xa2, 0x1a,
    0x65, 0x4f, 0xf3, 0x23, 0x28, 0x18, 0x46, 0xe3, 0x77, 0x78, 0xae, 0x2c, 0x5a, 0xfa, 0x1a, 0x01,
    0x3b, 0x92, 0xa6, 0x7c, 0xee, 0x3c, 0xa0, 0x4c, 0x9e, 0xb1, 0x26, 0xed, 0x9e, 0x1b, 0x81, 0x40,
    0xa5, 0xce, 0xa8, 0xad, 0x09, 0xdd, 0x7c, 0x83, 0xc8, 0x1d, 0x1e, 0x6a, 0x3e, 0x60, 0x2e, 0x95,
    0xc6, 0x17, 0x5b, 0x88, 0x0b, 0x54, 0x48, 0x80, 0x95, 0x77, 0x78, 0xcc, 0x5e, 0x09, 0x9e, 0x66,
    0xe5, 0x87, 0x64, 0x4d, 0x36, 0x12, 0x40, 0xc4, 0x67, 0x78, 0xce, 0x38, 0x60, 0x24, 0xdf, 0x3c,
    0xc0, 0xbb, 0xf7, 0x7d, 0x2f, 0x66, 0x56, 0xfb, 0xfa, 0x75, 0x2a, 0xe5, 0x23, 0x7a, 0xad, 0x5c,
    0xef, 0x2d, 0xa1, 0xb6, 0x7c, 0xbd, 0xfa, 0xb3, 0xdc, 0x68, 0x55, 0xd1, 0xa0, 0xac, 0x8c, 0x06,
    0x62, 0x21, 0xe9, 0x7d, 0x64, 0xd0, 0x60, 0xb3, 0x12, 0x2e, 0x6a, 0x50, 0xf4
  ];

  @override
  String get appManifest => r'''
  <manifest xmlns:android="http://schemas.android.com/apk/res/android"
      package="com.example.splitaot">
      <!-- io.flutter.app.FlutterApplication is an android.app.Application that
           calls FlutterMain.startInitialization(this); in its onCreate method.
           In most cases you can leave this as-is, but you if you want to provide
           additional functionality it is fine to subclass or reimplement
           FlutterApplication and put your custom class here. -->
      <application
          android:name="io.flutter.app.FlutterPlayStoreSplitApplication"
          android:label="splitaot"
          android:extractNativeLibs="false">
          <activity
              android:name=".MainActivity"
              android:launchMode="singleTop"
              android:theme="@style/LaunchTheme"
              android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
              android:hardwareAccelerated="true"
              android:windowSoftInputMode="adjustResize">
              <!-- Specifies an Android theme to apply to this Activity as soon as
                   the Android process has started. This theme is visible to the user
                   while the Flutter UI initializes. After that, this theme continues
                   to determine the Window background behind the Flutter UI. -->
              <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"
                />
              <!-- Displays an Android View that continues showing the launch screen
                   Drawable until Flutter paints its first frame, then this splash
                   screen fades out. A splash screen is useful to avoid any visual
                   gap between the end of Android's launch screen and the painting of
                   Flutter's first frame. -->
              <meta-data
                android:name="io.flutter.embedding.android.SplashScreenDrawable"
                android:resource="@drawable/launch_background"
                />
              <intent-filter>
                  <action android:name="android.intent.action.MAIN"/>
                  <category android:name="android.intent.category.LAUNCHER"/>
              </intent-filter>
          </activity>
          <!-- Don't delete the meta-data below.
               This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
          <meta-data
              android:name="flutterEmbedding"
              android:value="2" />
          <meta-data
              android:name="io.flutter.embedding.engine.deferredcomponents.DeferredComponentManager.loadingUnitMapping"
              android:value="2:component1" />
      </application>
  </manifest>
  ''';

  @override
  String get appStrings => r'''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="component1Name">component1</string>
</resources>
  ''';

  @override
  String get appStyles => r'''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting -->
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">@android:color/white</item>
    </style>
</resources>
  ''';

  @override
  String get appLaunchBackground => r'''
<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>
  ''';

  @override
  String get asset1 => r'''
asset 1 contents
  ''';

  @override
  String get asset2 => r'''
asset 2 contents
  ''';

  @override
  List<DeferredComponentModule> get deferredComponents => <DeferredComponentModule>[DeferredComponentModule('component1')];
}

/// Missing android dynamic feature module.
class NoAndroidDynamicFeatureModuleDeferredComponentsConfig extends BasicDeferredComponentsConfig {
  @override
  List<DeferredComponentModule> get deferredComponents => <DeferredComponentModule>[];
}

/// Missing golden
class NoGoldenDeferredComponentsConfig extends BasicDeferredComponentsConfig {
  @override
  String get deferredComponentsGolden => null;
}

/// Missing golden
class MismatchedGoldenDeferredComponentsConfig extends BasicDeferredComponentsConfig {
  @override
  String get deferredComponentsGolden => r'''
  loading-units:
    - id: 2
      libraries:
        - package:test/invalid_lib_name.dart
  ''';
}
