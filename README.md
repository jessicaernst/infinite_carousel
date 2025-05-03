# 📦 infinite_carousel

A customizable and beautiful infinite carousel widget for Flutter apps. Supports 3D-style scaling, shadow layering, active/inactive cards, and full infinite looping out of the box.

---

## ✨ Features

- 🔁 Infinite horizontal scrolling
- 🔳 Active/inactive card styling
- 🧩 Accepts custom card content via builder
- 🎨 Optional gradients, shadows, scaling, and size customization
- ⚙️ Highly configurable for flexible design integration

---

## 🚀 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  infinite_carousel:
    git:
      url: https://github.com/YOUR_USERNAME/infinite_carousel.git
```

Then run:

```bash
flutter pub get
```

---

## 🔧 Usage

### Basic Example

```dart
InfiniteCarousel<MyModel>(
  items: myItemList,
  cardWidth: 228,
  cardHeight: 347,
  inactiveScale: 0.9,
  itemBuilder: (context, isActive, item) {
    return isActive
        ? ActiveCarouselCardContainer(child: MyCardContent(item: item, isActive: true))
        : InactiveCarouselCardContainer(child: MyCardContent(item: item, isActive: false));
  },
),
```

---

## 🧩 Parameters

| Parameter        | Type                           | Description                                             |
|------------------|--------------------------------|---------------------------------------------------------|
| `items`          | `List<T>`                      | The list of data items to display in the carousel       |
| `itemBuilder`    | `(context, isActive, item) =>` | Function to build your card widget                      |
| `cardWidth`      | `double`                       | `228.0` | Width of each carousel card                   |
| `cardHeight`     | `double`                       | `347.0` | Height of each carousel card                  |
| `inactiveScale`  | `double`                       | `0.9`   | Scale factor for inactive cards               |
| `shadowColor`    | `Color?`                       | Optional override for inactive shadow                   |
| `useGradient`    | `bool`                         | Whether gradient is enabled (default: `true`)           |

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

### Example Card Content

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

## 🪪 License

MIT License. Use freely and responsibly.
