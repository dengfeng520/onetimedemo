
 单例模式,由于其简单好用容易理解、同时在出问题时也容易定位的特点，在开发中经常用到的一个设计模式，本文主要分享我在自己的代码中是如何使用单例模式的。

###1、什么是单例模式

>单例模式的定义

简单的来说，一个单例类，在整个程序中只有一个实例，并且提供一个类方法供全局调用，在编译时初始化这个类，然后一直保存在内存中，到程序（APP）退出时由系统自动释放这部分内存。

 >系统为我们提供的单例类有哪些？
```
UIApplication(应用程序实例类)
NSNotificationCenter(消息中心类)
NSFileManager(文件管理类)
NSUserDefaults(应用程序设置)
NSURLCache(请求缓存类)
NSHTTPCookieStorage(应用程序cookies池)
```

>在哪些地方会用到单例模式

一般在我的程序中，经常调用的类，如工具类、公共跳转类等，我都会采用单例模式；

>重复初始化单例类会怎样？

请看下面的例子，我在我的工程中，初始化一次`UIApplication`,
```
  [[UIApplication alloc]init];
```
最后运行的结果是，程序直接崩溃，并报了下面的错，
```
Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'There can only be one UIApplication instance.'
```
![初始化](http://upload-images.jianshu.io/upload_images/1214383-3cbc81671394f78d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
所以，由此可以确定，一个单例类只能初始化一次。

###2、单例类的生命周期

>单例实例在存储器的中位置

请看下面的表格展示了程序中中不同的变量在手机存储器中的存储位置；

| 位置  | 存放的变量 |
| :-------------: | :-------------: |
| 栈  | 临时变量（由编译器管理自动创建/分配/释放的，栈中的内存被调用时处于存储空间中，调用完毕后由系统系统自动释放内存） |
| 堆  | 通过alloc、calloc、malloc或new申请内存，由开发者手动在调用之后通过free或delete释放内存。动态内存的生存期可以由我们决定，如果我们不释放内存，程序将在最后才释放掉动态内存，在ARC模式下，由系统自动管理。|
| 全局区域  |  静态变量（编译时分配，APP结束时由系统释放）  |
| 常量  |  常量（编译时分配，APP结束时由系统释放）  |
| 代码区  |   存放代码 |

在程序中，一个单例类在程序中只能初始化一次，为了保证在使用中始终都是存在的，所以单例是在存储器的`全局区域`，在编译时分配内存，只要程序还在运行就会一直占用内存，在APP结束后由系统释放这部分内存内存。

###3、新建一个单例类

######（1）、单例模式的创建方式；
       
```
同步锁 ：NSLock
```
  
```
@synchronized(self) {}
```    
```
信号量控制并发：dispatch_semaphore_t 
```
```
条件锁：NSConditionLock
```   
```
dispatch_once_t
```
考虑数据和线程问题，苹果官方推荐开发者使用`dispatch_once_t`来创建单例，那么我就采用`dispatch_once_t`方法来创建一个单例，类名为`OneTimeClass`。
```
static OneTimeClass *__onetimeClass;
+(OneTimeClass *)sharedOneTimeClass
{
static dispatch_once_t oneToken;

    dispatch_once(&oneToken, ^{

        __onetimeClass = [[OneTimeClass alloc]init];

    });
    
    return __onetimeClass;
}
```

###4、单例模式的优缺点

>先说优点：

（1）、在整个程序中只会实例化一次，所以在程序如果出了问题，可以快速的定位问题所在；
（2）、由于在整个程序中只存在一个对象，节省了系统内存资源，提高了程序的运行效率；


>再说缺点

（1）、不能被继承，不能有子类；

（2）、不易被重写或扩展（可以使用分类）；

（3）、同时，由于单例对象只要程序在运行中就会一直占用系统内存，该对象在闲置时并不能销毁，在闲置时也消耗了系统内存资源；

###5、单例模式详解


######（1）、重写单例类的`alloc`方法保证这个类只会被初始化一次

我在`viewDidLoad`方法中调用单例类的`alloc`和`init`方法：
```
[[OneTimeClass alloc]init];
```
此时只是报黄点，但是并没有报错，`Run`程序也可以成功，这样的话，就不符合我们最开始使用单例模式的初衷来，这个类也可以随便初始化类，为什么呢？因为我们并没有获取`OneTimeClass`类的使用实例，改进代码：
```
[OneTimeClass sharedOneTimeClass];
 [[OneTimeClass alloc]init];
```
这是改进后的，但是在多人开发时，还是没办法保证，我们会先调用`alloc`方法，这样我们就没办法控制了，但是我们控制`OneTimeClass`类，此时我们可以重写`OneTimeClass`类的`alloc`方法,此处在重写`alloc`方法的处理可以采用断言或者系统为开发者提供的NSException类来告诉其他的同事这个类是单例类，不能多次初始化。
```
//断言
+ (instancetype)alloc{
  NSCAssert(!__onetimeClass, @"OneTimeClass类只能初始化一次");
  return [super alloc];
}
```
```
//NSException
+ (instancetype)alloc{
   //如果已经初始化了
    if(__onetimeClass){
      NSException *exception = [NSException exceptionWithName:@"提示" reason:@"OneTimeClass类只能初始化一次" userInfo:nil];
      [exception raise];
   }
 return [super alloc];
}
```
此时在run一次，可以看到程序直接崩到main函数上了，并按照我之前给的提示报错。
![初始化](http://upload-images.jianshu.io/upload_images/1214383-806bda8100281b9b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 '报错')


但是，如果我们的程序直接就崩溃了，这样的做法与开发者开发APP的初衷是不是又相悖了，作为一个程序员的目的要给用户一个交互友好的APP，而不是一点小问题就崩溃，当然咯，如果想和测试的妹纸多交流交流，那就。。。。。
对于这种情况，可以用到`NSObect`类提供的`load`方法和`initialize`方法来控制，
这两个方法的调用时机：
 > `load`方法是在整个文件被加载到运行时，在main函数调用之前调用；


>`initialize`方法是在该类第一次调用该类时调用；


为了验证`load`方法和`initialize`方法的调用时机，我在  `Main`函数中打印：
```
printf("\n\n\n\nmain()");
```
在`OneTimeClass`类的`load`方法中打印：
```
+(void)load
{
    printf("\n\nOneTimeClass load()");
}
```
在`OneTimeClass`类的`initialize`方法中打印：
```
+(void)initialize
{
    printf("\n\nOneTimeClass initialize()");
}
```
运行程序，最后的结果是，`load`方法先打印出来，所以可以确定的是`load`的确是在在main函数调用之前调用的。
![load和initialize](http://upload-images.jianshu.io/upload_images/1214383-ff93ec02f822d162.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样的话，如果我在单例类的`load`方法或者`initialize`方法中初始化这个类，是不是就保证了这个类在整个程序中调用一次呢？

  ```
+(void)load
{
    printf("\n\nOneTimeClass load()");
}
+(void)initialize
{
    printf("\nOneTimeClass initialize()\n\n\n");
    [OneTimeClass sharedOneTimeClass];
}
```
这样就可以保证`sharedOneTimeClass`方法是最早调用的。同时，再次对`alloc`方法修改，无论在何时调用`OneTimeClass`已经初始化了，如果再次调用`alloc`可直接返回`__onetimeClass`实例。
```
+ (instancetype)alloc
{
 if(__onetimeClass)
    {
        return  __onetimeClass;
    }
 return [super alloc];
}
```
最后在`ViewController`中打印调用`OneTimeClass`的`sharedOneTimeClass`和`alloc`方法，可以看到Log出来的内存地址是相同的，这就说明此时我的`OneTimeClass`类就只初始化了一次。
![内存地址](http://upload-images.jianshu.io/upload_images/1214383-af5f1f77b742a68b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######（2）、对`new`、`copy`、`mutableCopy`的处理

> 方案一：重写这几个方法，当调用时提示或者返回`OneTimeClass`类实例，请参考`alloc`方法的处理；

>方案二：直接禁用这个方法，禁止调用这几个方法，否则就报错，编译不过；

```
+(instancetype) new __attribute__((unavailable("OneTimeClass类只能初始化一次")));
-(instancetype) copy __attribute__((unavailable("OneTimeClass类只能初始化一次")));
-(instancetype) mutableCopy  __attribute__((unavailable("OneTimeClass类只能初始化一次")));
```
此时我在`viewDidLoad`中调用`new`，然后`Build`,编译器会直接给出错误警告，如下图：
![OneTimeClass类只能初始化一次](http://upload-images.jianshu.io/upload_images/1214383-171efdbc04927d65.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样就解决了单例类被多次初始化的问题；

######（3）、分类`Category`的使用

如果在程序中某个模块的业务逻辑比较多，此时可以选择分类` Category`的方式，这样做的好处是：
（1）、减少`Controller`代码行数，使代码逻辑更清晰；
（2）、把同一个功能业务区分开，利于后期的维护；
（3）、遇到`BUG`能快速定位到相关代码；
原则上分类` Category`只能增加和实现方法，而不能增加属性，此处请参考[美团技术团队的博客:深入理解Objective-C：Category](https://tech.meituan.com/tag/Category)

例如，在我们的[APP](itms-apps://itunes.apple.com/cn/app/com.gnetop.catchU/id1436463146?mt=8)中，用到了`Socket`技术，我在客户端`Socket`部分的代码使用了单例模式。由于和服务器的交互比较多，此时采用分类`Category`的方式，把`Socket`异常处理，给服务器发送的协议，和接受到服务器的协议 用三个分类`Category`来实现。在以后的维护中如果业务复杂度增加，或者加了新的业务或功能，可继续新建一个分类。这样既不影响之前的代码，同时又可以保证新的代码逻辑清晰。



以上是我在单例模式使用上的一些总结，如果有错误的地方，请指出。


本文demo：[戳这里](https://github.com/dengfeng520/onetimedemo.git)
本文参考：[细说@synchronized和dispatch_once](https://www.jianshu.com/p/ef3f77c8b320)
 
