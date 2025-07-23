// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V.
// or its affiliates is strictly prohibited.

/// A task handler is a reference to a task that is currently running or has been scheduled to run.
/// It can be used to cancel the task.
///
/// {@category Core}
abstract class TaskHandler {}

/// @nodoc
///
/// {@category Core}
class TaskHandlerImpl extends TaskHandler {
  TaskHandlerImpl(this._id);
  final dynamic _id;

  dynamic get id => _id;
}
