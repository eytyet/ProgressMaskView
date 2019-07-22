#  ProgressMaskView

Progress Mask VIew is a view wich masks all screen to show progress.

This has following parts.
 - Beautiful circule shape activity view
 - Progress bar in circle shape.
 - Label is placed in center of the circles.

Dynamic Type capable.
Fit to all screen size.

Animation is all layer base and it will not consume too many processing power.

![Screen shot](./10fps.gif)

## Usage


### Install
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




