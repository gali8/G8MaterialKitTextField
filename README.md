# G8MaterialKitTextField
The MKTextField Validation [BETA]

Features:
-----
Automatic MKTextField validation, using a regex pattern.
Fully @IBInspectable

Based on the MKTextField in the [MKMaterialKit] (https://github.com/nghialv/MaterialKit)

How To Use:
-----
```
git clone https://github.com/gali8/G8MaterialKitTextField
cd G8MaterialKitTextField
git submodule update --init --recursive
```

All G8MaterialKitTextField properties are @IBInspectable so you can configure them directly in the Storyboard.

```
- regexPattern: the regex to respect! Note: when you set the regexPattern from the Storyboard, chars like \ will be automatically translated in \\.
- invalidBottomBorderColor (it updates the MKTextField bottomBorderColor property)
- invalidCircleLayerColor (it updates the MKTextField circleLayerColor property)
- invalidTintColor (it updates the MKTextField tintColor property)
- validBottomBorderColor
- validCircleLayerColor
- validTintColor
```

#### MKTextField
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTextField.gif" width="365" height="568">
</p>
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTextField_bottomborder.gif" width="365" height="111">
</p>


License
=================

Tesseract OCR iOS and TesseractOCR.framework are distributed under the MIT
license (see LICENSE.md).

Contributors
=================

Daniele Galiotto (founder) - iOS Freelance Developer -
**[www.g8production.com](http://www.g8production.com)**
