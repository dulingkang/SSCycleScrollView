### swift首页轮播 轻量级 超级缓存

> 轮播终结者，用swift完成，易于集成使用，下载图片使用了SDWebImage
> 自己动手用swift写了一个，欢迎试用！

### 网上找了一些首页轮播，写的或多或少有一些问题，用着不舒服，自己用swift写了一个轮播控件，有如下特点：
> * 下载图片使用了SDWebImage，性能高
> * 轮播图上需要点击链接，只需要调用一个block便可加上点击，易于集成
> * 支持webp格式图片

### 使用方法
- 1. 在Podfile加入以下：
```
use_frameworks!
pod 'SSCycleScrollView'
```
- 2. 这个库中支持了webp格式图片，引入了SDWebImage库。
下面可参考Demo中：
> * 初始化时，传一个url的array，可以传本地的图片名字，也可以传网络图片;

> * 初始化一个SSCycleScrollView:
```
        self.mainScrollView = SSCycleScrollView.init(frame: currentRect, animationDuration: 3, inputImageUrls: self.scrollImageUrls)
        self.mainScrollView?.tapBlock = {index in
            print("tapped page\(index)")
        }

```

### 原理详解


#### SSCycScrollView
> 初始化后会启动一个定时器，repeat调用一个timerFired方法，方法中每次对scrollview加一个自己宽度的offset:
```
func timerFired() {
let xOffset = Int(self.contentOffset.x/kScreenWidth)
let xOffsetFloat = CGFloat(xOffset) * kScreenWidth
let newOffset = CGPointMake(xOffsetFloat + CGRectGetWidth(self.frame), self.contentOffset.y)
self.setContentOffset(newOffset, animated: true)
}
```
没有直接加xOffset, 而是对其做了一个换算，确保每次加的offset是自己宽度的整数倍。
> 在scrollViewDidScroll方法，每次计算前一个，当前，后一个index，确保index范围为index >= 0 && index < allImageArray.count, 每次滚动后都会三个imageView中的image做重新赋值：
```
self.previousDisplayView?.image = self.allImageArray[previousArrayIndex]
self.currentDisplayView?.image = self.allImageArray[self.currentArrayIndex]
self.lastDisplayView?.image = self.allImageArray[lastArrayIndex]
self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0)
```
> 上面最后一行设置contenOffset非常重要，每次把scrollView的位置重置为1个自身宽度的offset。

### 小结

> 如果你觉得有不好的地方，可以提出来，大家一块研究一下，欢迎常来我的[仓库](https://github.com/dulingkang/)，别忘记给个star！

