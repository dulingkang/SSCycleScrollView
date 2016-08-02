### swift首页轮播 轻量级 超级缓存

> 轮播终结者，用swift完成，易于集成使用，下载图片使用了SDWebImage
> 自己动手用swift写了一个，欢迎试用！

### 网上找了一些首页轮播，写的或多或少有一些问题，用着不舒服，自己用swift写了一个轮播控件，有如下特点：
> * 下载图片使用了SDWebImage，性能高
> * 轮播图上需要点击链接，只需要调用一个block便可加上点击，易于集成

### 使用方法
- 1.把SSCycleScroll文件夹拖入到工程中：![QQ20151124-0.png](http://upload-images.jianshu.io/upload_images/844885-ca63a0b6e3e461ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- 2. 在Podfile加入以下：
```
use_frameworks!
pod 'SSCycleScrollView'
```
下面可参考Demo中：
> * defaultBackground.jpg换成自己的背景，当没有网络时，会用本地的这一张图轮播，imageDownload.plist请也要带着，初始化时会用到，如果不用网络图片，只用SSCycleScrollView.swift这一个文件就可以了;

> * 初始化一个SSCycleScrollView:
```
self.mainScrollView = SSCycleScrollView.init(frame: currentRect, animationDuration: 3, inputImageArray: self.scrollImageArray)
self.view.addSubview(self.mainScrollView!)
```
> * 只需要要传入一个image array就可以了，有网络下载的，等下载完，更新SSCycleScrollView中的allImageArray就可以了；
> * 可以这样请求：
```
SSDownloadManager.sharedInstance.request(kMainScrollURL) { (finished, error) -> Void in
if finished {
/********** 所有图片都下载完成后，reloadCycleScroll中的array **********/                
self.reloadScrollImageArray()
print("download image finished")
}
}
self.addMainScrollView()
```
下载完图片后，reloadScrollImageArray：
```
func reloadScrollImageArray() {
let imageModel = SSImageDownloadModel.sharedInstance
let imageCount = imageModel.imageList.count
self.scrollImageArray.removeAll()
if imageCount > 0 {
for item in imageModel.imageList {
if let imageUrl = item.imageCachePath {
if imageUrl.characters.count > 0 {
if let image = UIImage(contentsOfFile: imageUrl) {
self.scrollImageArray.append(image)
}
}
}
}
}
if self.scrollImageArray.count > 0 {
self.mainScrollView?.allImageArray = self.scrollImageArray
}
}
```
### 注意点
使用前根据自己服务器中json格式，配置好本地的imageDown.plist, 和SSImageDownModel的SSImageDownloadItem，不要忘记info.plist中的App Transport Security Settings，以允许http连接。

### 原理详解
如果愿意看，下面还能写一点东西。就算你觉得这种下载方式或者是轮播控件不好用，对于对plist存储不熟悉的人来说，这一篇也能学到plist的存储，后期还会用更好的方式去存储。
> * 请求json时，会把服务器上最新的json文件拿下来，写到本地plist中去；
> * 对plist存储读写时，是用md5值做这条数据的唯一标识；
> * 对于每条数据，缓存的路径为/tmp/imageCache/md5.jpg, 如果在缓存中没有发现这个图片，才会去网络请求图片；
> * SSNetworking中，请求方法用的URLSession, 请求 json  时用的ephemeralSessionConfiguration 配置请求，每次请求，没用缓存，如果用default，服务器中 son 修改后，可能请求不回来最新的。

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

