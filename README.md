#  ProgressMaskView for iOS

**Progress Mask View** is a view which covers entire screen.  User can aware that any interaction is disabled and he/she need to wait. Beautiful activity movement will turn the wait time to enjoyable one. And for you, a developer, this is easy to use.

![Screen shot](./10fps.gif)

This view has:
 - Circular activity view.
 - Circular progress view.
 - Label in center.
 - Dynamic Type capable.
 - Fit to all screen size.

Animation is implemented on CALayer. This view will not consume many CPU power for animation.

## Easy to Use

This view is available from code. Interface Builder is not required.

1. Make a `ProgressMaskView` instance
2. Pass your UIViewController to the `install(to:)` method.
3. Call the `showIn()` method to show a progress view.

4. Specify the `progress` property like a UIProgressView.

5. Call the `hideIn(second:uninstall)` at the end.

That's all. This view automatically decide acppropriate insert point in the view hierarchy and insert it, set up all constraint, and start animation. At the end, this view is removed from the tree so that it can be freed.

If you want, you can use Interface builder. But I suggest above code approach because it is easier.


## Customization
 - Change colors.
 - Change Radius and Thickness.
 - Change activity rotation speed.

## Installation

- Get all code.
- Add the ProgressMaskView.xcodeproj onto your project.
- Add ProgressMaskView.framework into the Embedded Binaries section at Project - Target - General.
- `import ProgressMaskView` will enable you to use ProgressMaskView.

## Sample Code

### Show

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
    maskView?.showIn(second: 1.0)
        
    startYourProcess()
}
```

### Progress

While processing, set progress value to ProgressMaskView to update display.

```Swift
maskView?.progress = value // 0.0 - 1.0
```

### Hide

At the end, call `hideIn` method to discard the view.

```Swift
maskView?.hideIn(second: 1.0, uninstall: true)
maskView = nil
```

If uninstall is fase, Progress Mask view remains. You can reuse it.

## License
MIT License

## Thanks
Any comments, requests, contributions are welcome.
