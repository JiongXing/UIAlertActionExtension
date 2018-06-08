# [iOS][Swift]获取类属性及设置UIAlertAction字体颜色

# 摘要

- iOS Swift 获取一个类的所有属性
- UIAlertController UIAlertAction 设置字体颜色

# 实现

苹果并没有公开UIAlertAction的一些关键属性，比如字体颜色，估计苹果是希望所有运行在iOS上的应用都有统一的风格，就像他希望ActionSheet就应该是白底蓝字的样子。然而只有我们iOS程序员会喊苹果爸爸，设计师们可不管那么多，各种五颜六色都会丢过来。
既要用系统的ActionSheet，又要配合设计图颜色的话，那可以尝试一下给UIAlertAction的私有属性赋值。

如果直接使用`setValue(color, forKey: "key")`的方法对私有属性赋值，会有crash的风险。
即便你知道了设置颜色的属性是`_titleTextColor`，那只能保证在写这些代码的时候，当时的iOS系统恰好支持让你这么赋值，不能保证苹果爸爸以后在系统更新时会不会把这属性干掉了，然后强行setValue就导致闪退了，这锅背不得。

在setValue之前，先确认下所set的属性存在，会保险一些。
顺便我们可以扩展UIAlertAction，取出它的所有属性：
```swift
extension UIAlertAction {
    /// 取属性列表
    static var propertyNames: [String] {
        var outCount: UInt32 = 0
        guard let ivars = class_copyIvarList(self, &outCount) else {
            return []
        }
        var result = [String]()
        let count = Int(outCount)
        for i in 0..<count {
            guard let pro: Ivar = ivars[i] else {
                continue
            }
            guard let name = String(utf8String: ivar_getName(pro)) else {
                continue
            }
            result.append(name)
        }
        return result
    }
}
```

测试一下：
```swift
dump(UIAlertAction.propertyNames)
```
发现了19个属性：
```
▿ 19 elements
  - "_title"
  - "_titleTextAlignment"
  - "_enabled"
  - "_checked"
  - "_isPreferred"
  - "_imageTintColor"
  - "_titleTextColor"
  - "_style"
  - "_handler"
  - "_simpleHandler"
  - "_image"
  - "_shouldDismissHandler"
  - "__descriptiveText"
  - "_contentViewController"
  - "_keyCommandInput"
  - "_keyCommandModifierFlags"
  - "__representer"
  - "__interfaceActionRepresentation"
  - "__alertController"
```

其中的`_titleTextColor`是我们需要赋值的目标。

给UIAlertAction添加个方法，用来检测是否存在某个属性：
```swift
extension UIAlertAction {
    /// 是否存在某个属性
    func isPropertyExisted(_ propertyName: String) -> Bool {
        for name in self.propertyNames {
            if name == propertyName {
                return true
            }
        }
        return false
    }
}
```

现在可以赋值对_titleTextColor赋值了，也写个方法给外界调用吧：
```swift
extension UIAlertAction {
    /// 设置文字颜色
    func setTextColor(_ color: UIColor) {
        let key = "_titleTextColor"
        guard isPropertyExisted(key) else {
            return
        }
        self.setValue(color, forKey: key)
    }
}
```

# 应用

弹个ActionSheet看看效果吧：

```swift
let cameraAction = UIAlertAction(title: "拍摄", style: .default) { (action) in
    print("拍摄")
}
let photoAction = UIAlertAction(title: "相册", style: .default) { (action) in
    print("相册")
}
let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

// 设置颜色
cameraAction.setTextColor(UIColor.darkText)
photoAction.setTextColor(UIColor.darkText)
cancelAction.setTextColor(UIColor.darkText)
        
let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
sheet.addAction(cameraAction)
sheet.addAction(photoAction)
sheet.addAction(cancelAction)
self.present(sheet, animated: true, completion: nil)
```

![蓝->黑.png](http://upload-images.jianshu.io/upload_images/2419179-2cbfbc7a4c48b794.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

顺利把蓝字改成了黑字。
