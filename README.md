# 📦 infinite_carousel

A customizable and beautiful infinite carousel widget for Flutter apps. Supports 3D-style scaling, shadow layering, active/inactive cards, and full infinite looping out of the box.

---

## ✨ Features

- 🔁 Infinite horizontal scrolling
- 🔳 Active/inactive card styling
- 🧩 Accepts custom card content via builder
- 🎨 Optional gradients, shadows, scaling, and size customization
- 🧱 Customize card container with `activeCardBuilder` & `inactiveCardBuilder`
- ⚙️ Highly configurable for flexible design integration
- 🧭 **Custom scroll physics support via `physics` parameter**
- ⏱️ **Configurable animation duration and curve for snapping**
- 🎯 **Optional `initialItem` to specify the starting item**
- 📢 **Optional `onActiveItemChanged` callback for active item changes**

---

## 🚀 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  infinite_carousel:
    git:
      url: https://github.com/jessicaernst/infinite_carousel.git # Replace with your repo URL if different
      ref: v1.1.5 # Or your specific tag/branch
```

Then run:

```bash
flutter pub get
```

---

## 🔧 Usage

### Basic Example

```dart
InfiniteCarousel(
  items: myItems.map((item) => InfiniteCarouselItem(content: MyCardContent(item: item))).toList(),
)
```

### Advanced Example with custom wrappers

```dart
InfiniteCarousel(
  items: myItems.map((item) => InfiniteCarouselItem(content: MyCardContent(item: item))).toList(),
  cardWidth: 228,
  cardHeight: 347,
  inactiveScale: 0.9,
+  activeCardBuilder: (child) => ActiveNewsCarouselCard(content: child), // Your custom active card wrapper
+  inactiveCardBuilder: (child) => InactiveNewsCarouselCard(content: child), // Your custom inactive card wrapper
+)
+```
+
+### Example with `initialItem` and `onActiveItemChanged`
+
+```dart
+InfiniteCarousel(
+  items: myItems.map((item) => InfiniteCarouselItem(content: MyCardContent(item: item))).toList(),
+  initialItem: 2, // Start with the 3rd item (index 2) centered
+  onActiveItemChanged: (index) {
+    print('Active item changed to index: $index');
+    // You can use this to update your app's state, e.g., with Riverpod:
+    // ref.read(activeCarouselIndexProvider.notifier).update(index);
+  },
  activeCardBuilder: (child) => ActiveNewsCarouselCard(content: child),
  inactiveCardBuilder: (child) => InactiveNewsCarouselCard(content: child),
)
@@ -55,13 +74,17 @@

## 🧩 Parameters

-| Parameter              | Type                              | Default   | Description                                               |
-|------------------------|-----------------------------------|-----------|-----------------------------------------------------------|
-| `items`                | `List<InfiniteCarouselItem>`      | required  | The items to display in the carousel                      |
-| `cardWidth`            | `double`                          | `228.0`   | Width of each carousel card                               |
-| `cardHeight`           | `double`                          | `347.0`   | Height of each carousel card                              |
-| `inactiveScale`        | `double`                          | `0.9`     | Scale factor for inactive cards                           |
-| `activeCardBuilder`    | `Widget Function(Widget child)?`  | optional  | Custom wrapper for the active card                        |
-| `inactiveCardBuilder`  | `Widget Function(Widget child)?`  | optional  | Custom wrapper for the inactive cards                     |
+| Parameter              | Type                                  | Default                          | Description                                                                 |
+|------------------------|---------------------------------------|----------------------------------|-----------------------------------------------------------------------------|
+| `items`                | `List<InfiniteCarouselItem>`          | required                         | The items to display in the carousel                                        |
+| `cardWidth`            | `double`                              | `228.0`                          | Width of each carousel card                                                 |
+| `cardHeight`           | `double`                              | `347.0`                          | Height of each carousel card                                                |
+| `inactiveScale`        | `double`                              | `0.9`                            | Scale factor for inactive cards                                             |
+| `activeCardBuilder`    | `Widget Function(Widget child)?`      | optional                         | Custom wrapper for the active card                                          |
+| `inactiveCardBuilder`  | `Widget Function(Widget child)?`      | optional                         | Custom wrapper for the inactive cards                                       |
+| `physics`              | `ScrollPhysics`                       | `BouncingScrollPhysics()`        | Scroll physics for the carousel                                             |
+| `animationDuration`    | `Duration`                            | `Duration(milliseconds: 300)`    | Duration of the snapping animation                                          |
+| `animationCurve`       | `Curve`                               | `Curves.easeOut`                 | Curve for the snapping animation                                            |
+| `initialItem`          | `int?`                                | `null`                           | Index of the item to be initially displayed in the center                   |
+| `onActiveItemChanged`  | `void Function(int index)?`           | `null`                           | Callback when the active (center) item changes                              |

---

## 🧪 Example App

### Preview:

```bash
cd example
flutter run
```

Make sure you’ve added assets:

```yaml
flutter:
  assets:
    - assets/images/
```

---

### 🖼️ Example Card Content

You are free to implement your own content widget. Example:

```dart
class MyCardContent extends StatelessWidget {
  final MyModel item;
  final bool isActive;

  const MyCardContent({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isActive ? 14.5 : 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(item.imageAsset),
          Text(item.title),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Tap for more'),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📷 Screenshot

![Carousel Preview](assets/screenshot.png)

---

## 🛠 Maintainers

- Jessica Ernst `@jessicaernst`  
- Contributions welcome!

---

## 📄 Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history and version notes.

---

## 🪪 License

MIT License. Use freely and responsibly.
