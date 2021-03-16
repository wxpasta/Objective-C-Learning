# +initialize

+initialize方法会在<font color="red">类</font>第一次接收到消息时调用

调用顺序

- 先调用父类的+initialize，再调用子类的+initialize

- (先初始化父类，再初始化子类，每个类只会初始化1次)





## objc4源码解读过程



objc-msg-arm64.s

- objc_msgSend



objc-runtime-new.mm

- class_getInstanceMethod

- lookUpImpOrNil

- lookUpImpOrForward

- _class_initialize

- callInitialize

- objc_msgSend(cls, SEL_initialize)



### +initialize是通过objc_msgSend进行调用的，所以有以下特点

- 如果子类没有实现+initialize，会调用父类的+initialize（所以父类的+initialize可能会被调用多次）

- 如果分类实现了+initialize，就覆盖类本身的+initialize调用



## 面试题

#### Q：load、initialize方法的区别什么？
1.调用方式
1> load是根据函数地址直接调用
2> initialize是通过objc_msgSend调用

2.调用时刻
1> load是runtime加载类、分类的时候调用（只会调用1次）
2> initialize是类第一次接收到消息的时候调用，每一个类只会initialize一次（父类的initialize方法可能会被调用多次）

#### Q：load、initialize的调用顺序？
1.load
1> 先调用类的load
a) 先编译的类，优先调用load
b) 调用子类的load之前，会先调用父类的load

2> 再调用分类的load
a) 先编译的分类，优先调用load

2.initialize
1> 先初始化父类
2> 再初始化子类（可能最终调用的是父类的initialize方法）

