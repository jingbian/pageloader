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

import 'src/api/annotation_interfaces.dart';
import 'src/api/exceptions.dart' show PageLoaderException;
import 'src/api/page_loader_element_interface.dart';
import 'src/api/page_object_list_interface.dart';

/// Collection of functions that can be used in PageObjects to do simple
/// common functions on PageLoaderElements or PageObjects without requiring
/// a passthrough for those properties.
///
/// These functions should not be used in expect calls or where a matcher can be
/// used. Their corresponding matchers should be used instead.
///
/// Example:
///    @ByTagName('material-button')
///    MaterialButtonPO get submitButton;
///
///    // Only click on the button if it exists
///    Future submit() => exists(submitButton) ? submitButton.click() : null;
///

/// A matcher that checks if a PageLoaderElement/PageObject exists.
/// If used on a List annotated by a Pageloader annotation, checks to see
/// if not empty.
bool exists(item) {
  if (item is PageObjectList) {
    return item.isNotEmpty;
  }
  try {
    return rootElementOf(item).exists;
  } on PageLoaderException {
    rethrow;
  } on PageLoaderArgumentError {
    rethrow;
  } catch (_) {
    throw new PageLoaderArgumentError.onWrongType('exists/notExists');
  }
}

/// A matcher that checks if a PageLoaderElement/PageObject does not exist.
bool notExists(item) => !exists(item);

/// Checks if a PageLoaderElement/PageObject contains given class.
bool hasClass(item, String className) =>
    _rootElementOfAndCheck(item, 'hasClass').classes.contains(className);

/// Checks if a PageLoaderElement/PageObject is displayed based on "display"
/// style.
bool isDisplayed(item) =>
    _rootElementOfAndCheck(item, 'isDisplayed/isNotDisplayed').displayed;

/// Checks if a PageLoaderElement/PageObject is not displayed based on
/// "display" style.
bool isNotDisplayed(item) => !isDisplayed(item);

const _hidden = const ['hidden', 'collapse'];

/// Checks if a PageLoaderElement/PageObject is hidden based on "visibility"
/// style.
///
/// A PageLoaderElement/PageObject is considered hidden if its `visibility`
/// style is either `hidden` or `collapse`.
bool isHidden(item) =>
    _hidden.contains(_rootElementOfAndCheck(item, 'isHidden/isNotHidden')
        .computedStyle['visibility']);

/// Checks if PageLoaderElement/PageObject is not hidden based on "visibility"
/// style.
bool isNotHidden(item) => !isHidden(item);

/// Checks if PageLoaderElement/PageObject is focused.
bool isFocused(item) =>
    _rootElementOfAndCheck(item, 'isFocused/isNotFocused').isFocused;

/// Checks if PageLoaderElement/PageObject is not focused.
bool isNotFocused(item) => !isFocused(item);

/// Gets the innerText of a PageLoaderElement/PageObject.
String getInnerText(item) =>
    _rootElementOfAndCheck(item, 'getInnerText').innerText;

/// Function for PageObject constructor. Typically in form:
///   (c) => new SomePO.create(c)
typedef T POFactory<T>(PageLoaderElement context);

/// Generates PO of type T using [source] as context. If [finder] is provided,
/// creates a new PO using context plus [finder].
///
/// Example:
///   final myPO = createPO<MyPO>(someElement, (c) => new MyPO.create(c),
///       finder: const ByCss('some-tag'));
T createPO<T>(PageLoaderElement source, POFactory<T> poFactory,
    {Finder finder}) {
  final element =
      finder == null ? source : source.createElement(finder, [], []);
  return poFactory(element);
}

/// Grabs the root element of a PageObject. Same as getting a '@root' annotated
/// getter within the PageObject. If a PageLoaderElement is passed, returns it
/// back.
PageLoaderElement rootElementOf(item) {
  if (item is PageLoaderElement) {
    return item;
  }
  try {
    return item.$root;
  } catch (_) {
    throw new PageLoaderArgumentError.onWrongType('rootElementOf');
  }
}

/// First checks to see if 'item' is either PageLoaderElement or PageObject.
/// If neither, throws an error.
/// Then checks to see if 'item' exists. If it doesn't exist, throws an error.
/// Returns 'item' as PageLoaderElement.
PageLoaderElement _rootElementOfAndCheck(item, String f) {
  PageLoaderElement _root;
  try {
    _root = rootElementOf(item);
  } catch (_) {
    throw new PageLoaderArgumentError.onWrongType(f);
  }
  if (!_root.exists) {
    throw new PageLoaderArgumentError.onNonExisting(f);
  }
  return _root;
}

class PageLoaderArgumentError extends ArgumentError {
  PageLoaderArgumentError._(String message) : super(message);

  factory PageLoaderArgumentError.onWrongType(String f) =>
      new PageLoaderArgumentError._("'$f' may only be called on PageObjects "
          "or PageLoaderElements");

  factory PageLoaderArgumentError.onNonExisting(String f) =>
      new PageLoaderArgumentError._("'$f' is being called on a non-existent "
          "PageObject or PageLoaderElement. If this "
          "is intentional, use 'exists' instead.");
}
