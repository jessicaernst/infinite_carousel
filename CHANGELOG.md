# 📓 Changelog

All notable changes to the `infinite_carousel` package will be documented in this file.

---

## 1.1.2

- **FEAT**: Made scroll physics configurable via the `physics` parameter.
- **FEAT**: Changed default scroll physics to `BouncingScrollPhysics` for a smoother, less rigid feel.

---

## 1.1.1

## [1.1.1] – 2025-05-03
### Fixed
- 🛠 Inactive cards are now vertically centered correctly (matches previous manual layout).
- 🧪 Improved test reliability and fixed scaling validation in widget tests.

---

## [1.1.0] – 2025-05-03
### Added
- ✨ Support for `activeCardBuilder` and `inactiveCardBuilder` for full visual design control.
- 📐 All card sizes (`cardWidth`, `cardHeight`) are now fully configurable.
- 🧪 Comprehensive widget test coverage added.
- 📷 Added preview screenshot and usage examples to `README.md`.

### Changed
- 🧼 Internal structure cleanup for package use.
- ♻️ Replaced hooks with standard stateful widgets to reduce external dependencies.

---

## [1.0.0] – 2025-05-03
### Initial release
- 🎉 Infinite horizontal carousel with overlapping scaling layout.
- 🌓 Active/inactive card display.
- 🔁 Full infinite looping using virtual item rendering.