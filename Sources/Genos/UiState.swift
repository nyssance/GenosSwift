// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

/// Screen state, the same vocabulary as Genos for Android.
public enum UiState<T> {
  case loading
  case success(T)
  case error(Error)
}
