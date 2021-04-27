![AdaptiveCards for Flutter](https://github.com/neohelden/Flutter-AdaptiveCards/raw/master/doc/neohelden-flutter-adaptive-cards-lib.jpg?raw=true "Adaptive Cards for Flutter")

# Adaptive Cards for Flutter

We decided to build a Flutter implementation of Adaptive Cards because we believe in the future of both technologies. With Flutter, we found an exciting framework for ultra-fast and cross-platform UI development. And with Adaptive Cards, we can combine that with an industry standard for exchanging card content in a structured way. At Neohelden, we're building on both of these technologies with our AI-assistant for business – and you can learn more about why we built this in our [blog-post on the release of our Adaptive Cards in Flutter library](https://neohelden.com/blog/tech/using-adaptive-cards-in-flutter/).

### Installing

Add this to your package's pubspec.yaml file:

```yml
dependencies:
  flutter_adaptive_cards: ^0.1.2
```

```dart
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
```

## Using

Using Adaptive Cards in Flutter coudn't be simpler: All you need is the `AdaptiveCard` widget.

### :warning: Markdown support vs. ColumnSet content alignment

Due to [issue #171](https://github.com/flutter/flutter_markdown/issues/171) of the Flutter Markdown package, the flag `supportMarkdown` was introduced to all Adaptive Card contractors. The default value of this property is `true`, to stay compatible with older versions of this package, which didn't support content alignment in ColumnSets. If the value is set to `false` the content alignment in ColumnSets is working accordingly, but every TextBlock is displayed without Markdown rendering. As soon if the issue is resolved this flag will be removed.

### Loading an AdaptiveCard

There are several constructors which handle loading of the AC from different sources.
`AdaptiveCard.network` takes a url to download the payload and display it.
`AdaptiveCard.asset` takes an asset path to load the payload from the local data.
`AdaptiveCard.memory` takes a map (which can be obtained but decoding a string using the json class) and displays it.

### HostConfig

The `HostConfig` can be configured via two parameters of every constructor:

1. The parameter `hostConfigPath` takes a static HostConfig which can be stored as a local asset. In this case, the [HostConfig has to be added to the pubspec.yaml](https://flutter.dev/docs/development/ui/assets-and-images) of the project.
2. The parameter `hostConfig` takes a dynamic HostConfig as a String. This can be changed programmatically and can be used for switching between a light and a dark theme.

If both parameters are set the `hostConfig`parameter will be used.

### Example

```dart
AdaptiveCard.network(
  placeholder: Text("Loading, please wait"),
  url: "www.someUrlThatPoints.To/A.json",
  hostConfigPath: "assets/host_config.json",
  onSubmit: (map) {
    // Send to server or handle locally
  },
  onOpenUrl: (url) {
    // Open url using the browser or handle differently
  },
  // If this is set, a button will appear next to each adaptive card which when clicked shows the payload.
  // NOTE: this will only be shown in debug mode, this attribute does change nothing for realease builds.
  // This is very useful for debugging purposes
  showDebugJson: true,
);
```

## Example App

We try to show every possible configuration parameter supported by the AdaptiveCards components in the example app of this repository. If we missed any, please feel free to open an issue.

## Running the tests

```sh
flutter test
```

and to update the golden files run

```sh
flutter test --update-goldens test/sample_golden_test.dart
```

This updates the golden files for the sample cards. Depending on your operating system you might have issues with the font rendering. For the CI / CD setup you need to generate the golden files using a Docker container:

```
# run the following command in the root folder of this project
docker run -it -v `pwd`:/app cirrusci/flutter:stable bash

# and inside the container execute
cd app/
pub get
flutter test --update-goldens

# afterwards commit the freshly generated sample files (after checking them)
```

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

- **Norbert Kozsir** (@Norbert515) – _Initial work_, Former Head of Flutter development at Neohelden GmbH
- **Pascal Stech** (@Curvel) – _Maintainer_, Flutter Developer at Neohelden GmbH (NeoSEALs team)
- **Maik Hummel** (@Beevelop) – _Maintainer_, CTO at Neohelden GmbH (Daddy of the NeoSEALs team)

See also the list of [contributors](https://github.com/neohelden/flutter_adaptive_cards/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
