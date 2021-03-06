// Copyright 2017 Google Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:pageloader/utils.dart';
import 'package:test/test.dart';

// Test failures only; successes are tested in matchers_test.dart
void main() {
  final utilsError = throwsA(new isInstanceOf<PageLoaderArgumentError>());
  final foo = 'foo';

  test('exists fails', () {
    expect(() => exists(foo), utilsError);
  });

  test('notExists fails', () {
    expect(() => notExists(foo), utilsError);
  });

  test('hasClass fails', () {
    expect(() => hasClass(foo, 'bar'), utilsError);
  });

  test('innerText fails', () {
    expect(() => getInnerText(foo), utilsError);
  });

  test('isDisplayed fails', () {
    expect(() => isDisplayed(foo), utilsError);
  });

  test('isNotDisplayed fails', () {
    expect(() => isNotDisplayed(foo), utilsError);
  });

  test('isHidden fails', () {
    expect(() => isHidden(foo), utilsError);
  });

  test('isNotHidden fails', () {
    expect(() => isNotHidden(foo), utilsError);
  });

  test('isFocused fails', () {
    expect(() => isFocused(foo), utilsError);
  });

  test('isNotFocused fails', () {
    expect(() => isNotFocused(foo), utilsError);
  });

  test('rootElementOf fails', () {
    expect(() => rootElementOf(foo), utilsError);
  });
}
