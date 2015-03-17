G8MaterialKitTextField
===========
***The MKTextField Validator v. 1.0 - Totally @IBInspectable***

Features:
-----
Automatic MKTextField validation, using regex patterns.

Based on the MKTextField of the [MKMaterialKit] (https://github.com/nghialv/MaterialKit)

Project installation:
-----
```
git clone https://github.com/gali8/G8MaterialKitTextField
cd G8MaterialKitTextField
git submodule update --init --recursive
```

How to use:
-----
- NO CODE REQUIRED
- The G8MaterialKitTextField properties are **@IBInspectable** so you can configure them directly in the Storyboard.
- Open the Storyboard, drag the **UITextField** in a UIViewController and set the UITextField class to **G8MKTextField**.
- That's all! See the Storyboard in the Example project to start the validation. All customizable properties are listed below.

```
- regexPatternCustom: the custom regex to use! Note: when you set the regexPatternCustom from the Storyboard, chars like \ will be automatically translated in \\.
- regexPatternEnum: use regex patterns already in the G8MaterialKitTextField. Use 0 for Custom or None else look at the list below.

- borderColor: (it updates the layer of the control)

- defaultTextColor: (it updates and override the MKTextField textColor property)
- defaultBottomBorderColor: (it updates the MKTextField bottomBorderColor property)
- defaultCircleLayerColor: (it updates the MKTextField circleLayerColor property)
- defaultTintColor: (it updates and override the MKTextField tintColor property)

- invalidTextColor:
- invalidBottomBorderColor:
- invalidCircleLayerColor:
- invalidTintColor:

- validTextColor:
- validBottomBorderColor:
- validCircleLayerColor:
- validTintColor:

- placeholder: (sets the placeholder dircetly from the storyboard to the MKTextField control)

- leftImage: (add left image in the UITextField)
- leftImageLeftPadding, leftImageTopPadding, leftImageRightPadding, leftImageBottomPadding

- rightImage: (add right image in the UITextField)
- rightImageLeftPadding, rightImageTopPadding, rightImageRightPadding, rightImageBottomPadding
```

#### Regex Pattern Types
***set the number in the regexPatternEnum property. NOTE: regexPatternEnum will ovverride the regexPatternCustom property, set regexPatternEnum to 0 for disable it or use custom regex patterns***
``` swift
    case CustomOrNone = "" //0
    case ZeroOrMoreChars = "^.*$" //1
    case OneOrMoreChars = "^.+$" //2
    case OneChar = "^.$" //3
    case Bool = "^[0-1]?$" //4
    case ZeroOrMoreNumbers = "^[0-9]*$" //5
    case OneOrMoreNumbers = "^[0-9]+$" //6
    case OneNumber = "^[0-9]$" //7
    case Name = "^[a-zA-Z\\s]+$" //8
    case Email = "^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$" //9
    case USBirthDate = "^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$" //10 MM/dd/yyyy
    case Year = "^\\d{4}$" //11
    case YearFrom1900To2099 = "^(19|20)\\d{2}$" //12
    case InternationalPhoneNumber = "^([0]{2}|[+])\\d{1,4} ?\\d{3} ?\\d{10}$" //13 es. +0000 000 0000000000 +00 000 0000000000 ....
    case InternationalPhoneNumber11 = "^([0]{2}|[+])\\d{2} ?\\d{3} ?\\d{6,8}$" //14 es. +00 000 0000000 ....
    case InternationalEPPPhoneNumber = "^\\+[0-9]{1,3}\\.[0-9]{4,14}(?:x.+)?$" //15
    case USPhoneNumber = "1?\\W*([2-9][0-8][0-9])\\W*([2-9][0-9]{2})\\W*([0-9]{4})(\\se?x?t?(\\d*))?" //16
    case EasyPassword = "(.{4,30})" //17 es. abcd
    case ComplexPassword = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{4,30})" //18 es. 1num1CHAR1char
```

#### Class Functions
``` swift
class func areValid(textFields: [G8MKTextField]) -> Bool ... //to check if any G8MKTextField is valid
```

#### Instance Functions
``` swift
func isValid() -> Bool ... //to check if self is valid
```

#### G8MKTextField
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/s/8hho89scxc2r1wh/G8MaterialKitTextField.gif" width="268" height="480">
</p>

#### MKTextField
<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/MKTextField.gif" width="365" height="568">
</p>


License
=================

G8MaterialKitTextField is distributed under the MIT
license (see LICENSE.md).

Contributors
=================

***Daniele Galiotto*** (founder) - iOS Freelance Developer -
**[www.g8production.com](http://www.g8production.com)**
