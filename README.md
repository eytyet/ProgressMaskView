#  ProgressMaskView for iOS

**Progress Mask View** is a view which covers the entire screen to disable any user interaction including Tab bar items and navigation bar buttons. It shows an activity indicator and a progress bar. User can aware that any interaction is disabled and he/she has to wait. Activity movement and color change are beautiful.

Basically, you should not use this. Disabling user interaction is not a good idea as a recent modern app.
However, in some case, it is necessary. I created this view to use on a backup function and a restore function since it is not possible to change any data while it is backing up or restoring from the backup data. This view has no cancel button.
You should use this at very limited case.

## Screenshots
![Screen shot 1](./10fps.gif)
![Screen shot 2](./10fps-2.gif)
![Screen shot 3](./10fps-3.gif)

## Features
This view has:
 - Circular activity view.
 - Circular progress view.
 - Label in center.
 - Transparent black effect covers all screen.
 
This is:
 - Light.
 - Dynamic Type capable.
 - Fit to all screen size.
 - Easy to use.

Animation is implemented at CALayer.

## How to Use

You can use ProgressMaskView on Interface Builder or from code.

### Interface Builder
Put a UIView and change its class to ProgressMaskView.


**Notes:**
- If you want to cover whole screen, you have to add a ProgressMaskView onto the UITabBarController or UINavigationBarController when you use it. 
- You should set `false` to  `uninstall:` argument at `hide` function to avoid removing it from the view hierarchy. It is `true` by default.

### Code
I suggest this way.
Just pass the current view controller to the install(to:) function. This view will automatically insert itself into the appropriate position of the view hierarchy. If you use UITabBarController or UINavigationController, it will find these root view controller.
At the end, this view will remove itself when `hide` is called. 

Refer to the sample code below.

## Customization
 - Change colors.
 - Change Radius and Thickness.
 - Change activity rotation speed.

## Installation

### CocoaPod
Add one line to your Podfile.

```podfile
    pod 'ProgressMaskView'
```
Close Xcode, open Terminal, go to the folder contains the Pod file, and run `pod install`.

### Manually
- Get all code.
- Add the ProgressMaskView.xcodeproj onto your project.
- Add ProgressMaskView.framework into the Embedded Binaries section at Project - Target - General.
- `import ProgressMaskView` will enable you to use ProgressMaskView.

## Sample Code

### Start

In your view controller;

```Swift

import ProgressMaskView

...

private var maskView: ProgressMaskView?
    
...

@IBAction func onButtonTap(_ sender: Any) {
    guard maskView == nil else { return }

    maskView = ProgressMaskView()
    maskView?.title = "Processing..."
    maskView?.install(to: self)
    maskView?.show(in: 1.0)
        
    startYourProcess()
}
```

### Set Progress

While processing, set progress value to ProgressMaskView to update display.

```Swift
maskView?.progress = progressValue // 0.0 - 1.0
```

### End

At the end, call `hide` method to discard the view.

```Swift
maskView?.hide(in: 1.0, uninstall: true) {
    self.maskView = nil
}
```

If `uninstall:` argumate is `false`, The Progress Mask View become hidden but remains in the view hierarchy. You can reuse it by calling `show(in:)` method.

## License
MIT License

## Thanks
Any comments, requests, contributions are welcome.
