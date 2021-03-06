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