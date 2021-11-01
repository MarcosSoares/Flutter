// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_devicelab/framework/metrics_center.dart';
import 'package:metrics_center/metrics_center.dart';

import 'common.dart';

class FakeFlutterDestination implements FlutterDestination {
  /// Overrides the skia perf `update` function, which uploads new data to gcs if there
  /// doesn't exist the commit, otherwise updates existing data by appending new ones.
  @override
  Future<void> update(List<MetricPoint> points, DateTime commitTime, String taskName) async {
    lastUpdatedPoints = points;
    time = commitTime;
    name = taskName;
  }

  List<MetricPoint>? lastUpdatedPoints;
  DateTime? time;
  String? name;
}

void main() {
  group('Parse', () {
    test('duplicate entries for both builder name and test name', () {
      final Map<String, dynamic> results = <String, dynamic>{
        'CommitBranch': 'master',
        'CommitSha': 'abc',
        'BuilderName': 'Linux test',
        'ResultData': <String, dynamic>{
          'average_frame_build_time_millis': 0.4550425531914895,
        },
        'BenchmarkScoreKeys': <String>[
          'average_frame_build_time_millis',
        ],
      };
      final List<MetricPoint> metricPoints = parse(results, <String, String>{}, 'test');

      expect(metricPoints.length, 2);
      expect(metricPoints[0].value, equals(0.4550425531914895));
      expect(metricPoints[0].tags[kNameKey], 'Linux test');
      expect(metricPoints[1].value, equals(0.4550425531914895));
      expect(metricPoints[1].tags[kNameKey], 'test');
    });

    test('without additional benchmark tags', () {
      final Map<String, dynamic> results = <String, dynamic>{
        'CommitBranch': 'master',
        'CommitSha': 'abc',
        'BuilderName': 'test',
        'ResultData': <String, dynamic>{
          'average_frame_build_time_millis': 0.4550425531914895,
          '90th_percentile_frame_build_time_millis': 0.473,
        },
        'BenchmarkScoreKeys': <String>[
          'average_frame_build_time_millis',
          '90th_percentile_frame_build_time_millis',
        ],
      };
      final List<MetricPoint> metricPoints = parse(results, <String, String>{}, 'task abc');

      expect(metricPoints[0].value, equals(0.4550425531914895));
      expect(metricPoints[2].value, equals(0.473));
    });

    test('with additional benchmark tags', () {
      final Map<String, dynamic> results = <String, dynamic>{
        'CommitBranch': 'master',
        'CommitSha': 'abc',
        'BuilderName': 'test',
        'ResultData': <String, dynamic>{
          'average_frame_build_time_millis': 0.4550425531914895,
          '90th_percentile_frame_build_time_millis': 0.473,
        },
        'BenchmarkScoreKeys': <String>[
          'average_frame_build_time_millis',
          '90th_percentile_frame_build_time_millis',
        ],
      };
      final Map<String, dynamic> tags = <String, dynamic>{
        'arch': 'intel',
        'device_type': 'Moto G Play',
        'device_version': 'android-25',
        'host_type': 'linux',
        'host_version': 'debian-10.11'
      };
      final List<MetricPoint> metricPoints = parse(results, tags, 'task abc');

      expect(metricPoints[0].value, equals(0.4550425531914895));
      expect(metricPoints[0].tags.keys.contains('arch'), isTrue);
      expect(metricPoints[2].value, equals(0.473));
      expect(metricPoints[2].tags.keys.contains('device_type'), isTrue);
    });

    test('succeeds - null ResultData', () {
      final Map<String, dynamic> results = <String, dynamic>{
        'CommitBranch': 'master',
        'CommitSha': 'abc',
        'BuilderName': 'test',
        'ResultData': null,
        'BenchmarkScoreKeys': null,
      };
      final List<MetricPoint> metricPoints = parse(results, <String, String>{}, 'tetask abcst');

      expect(metricPoints.length, 0);
    });
  });

  group('Update', () {
    test('without taskName', () async {
      final Map<String, dynamic> results = <String, dynamic>{
        'CommitBranch': 'master',
        'CommitSha': 'abc',
        'BuilderName': 'test',
        'ResultData': <String, dynamic>{
          'average_frame_build_time_millis': 0.4550425531914895,
          '90th_percentile_frame_build_time_millis': 0.473,
        },
        'BenchmarkScoreKeys': <String>[
          'average_frame_build_time_millis',
          '90th_percentile_frame_build_time_millis',
        ],
      };
      final List<MetricPoint> metricPoints = parse(results, <String, String>{}, 'task abc');
      final FakeFlutterDestination flutterDestination = FakeFlutterDestination();
      const String taskName = 'default';
      const int commitTimeSinceEpoch = 1629220312;

      await upload(flutterDestination, metricPoints, commitTimeSinceEpoch, taskName);

      expect(flutterDestination.name, 'default');
    });

    test('with taskName', () async {
      final Map<String, dynamic> results = <String, dynamic>{
        'CommitBranch': 'master',
        'CommitSha': 'abc',
        'BuilderName': 'test',
        'ResultData': <String, dynamic>{
          'average_frame_build_time_millis': 0.4550425531914895,
          '90th_percentile_frame_build_time_millis': 0.473,
        },
        'BenchmarkScoreKeys': <String>[
          'average_frame_build_time_millis',
          '90th_percentile_frame_build_time_millis',
        ],
      };
      final List<MetricPoint> metricPoints = parse(results, <String, String>{}, 'task abc');
      final FakeFlutterDestination flutterDestination = FakeFlutterDestination();
      const String taskName = 'test';
      const int commitTimeSinceEpoch = 1629220312;

      await upload(flutterDestination, metricPoints, commitTimeSinceEpoch, taskName);

      expect(flutterDestination.name, taskName);
    });
  });
}
