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

---

## 🚀 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  infinite_carousel:
    git:
      url: https://github.com/jessicaernst/infinite_carousel.git
      ref: v1.1.3
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
  activeCardBuilder: (child) => ActiveNewsCarouselCard(content: child),
  inactiveCardBuilder: (child) => InactiveNewsCarouselCard(content: child),
)
```

---

## 🧩 Parameters

| Parameter              | Type                              | Default   | Description                                               |
|------------------------|-----------------------------------|-----------|-----------------------------------------------------------|
| `items`                | `List<InfiniteCarouselItem>`      | required  | The items to display in the carousel                      |
| `cardWidth`            | `double`                          | `228.0`   | Width of each carousel card                               |
| `cardHeight`           | `double`                          | `347.0`   | Height of each carousel card                              |
| `inactiveScale`        | `double`                          | `0.9`     | Scale factor for inactive cards                           |
| `activeCardBuilder`    | `Widget Function(Widget child)?`  | optional  | Custom wrapper for the active card                        |
| `inactiveCardBuilder`  | `Widget Function(Widget child)?`  | optional  | Custom wrapper for the inactive cards                     |

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
