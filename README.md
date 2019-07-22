#  ProgressMaskView

**Progress Mask View** is a view wich masks all screen to show a progress and an activity.
Easy to use.

![Screen shot](./10fps.gif)

This view has:
 - Beautiful circule shape activity view. You can change radius, thickness, speed and colors.
 - Progress bar in circle shape. You can change radius, thickness and colors.
 - Label is placed in center of the circles.
 - Dynamic Type capable.
 - Fit to all screen size.

Animation is implemented on CALayer. Lightweight.


## Easy to Use

1. Make a ProgressMaskView instance
2. Pass your UIViewController to the `install(to:)` method.
3. Call `showIn()` to start.

4. Set `progress` property like UIProgressView.

5. Call `hideIn(second:uninstall)` to complete.

## Customize
 - 


### Install
Get all code and buid it on Xcode to create ProgressMaskView.framework.

Select ProgressMaskView.framework to the Embedded Binaries on Project General.


### Show the mask view on a button.

```Swift
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

### Set progress

```Swift
maskView?.progress = value // 0.0 - 1.0
```

### Hide the mask view

```Swift
maskView?.hideIn(second: 1.0, uninstall: true)
maskView = nil
```




