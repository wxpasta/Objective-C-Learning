# +load
> 注意：文件编译顺序



#### 001-AddLoad(Log)

- BJPerson继承NSObject
- BJStudent继承BJPerson



#### 002-AddLoad(Log)

- BJPerson继承NSObject
- BJStudent继承BJPerson
- BJCat继承NSObject
- BJDog继承NSObject



## 结论

+load方法会在runtime加载<font color='red'>类</font>、<font color='red'>分类</font>时调用

每个类、分类的+load，在程序运行过程中只调用一次

调用顺序

1. 先调用类的+load
   - 按照编译先后顺序调用（先编译，先调用）
   - 调用子类的+load之前会先调用父类的+load

2. 再调用分类的+load
   - 按照编译先后顺序调用（先编译，先调用）



## 源码分析

 objc4源码解读过程：objc-os.mm

- _objc_init

- load_images

- prepare_load_methods
  - schedule_class_load
  - add_class_to_loadable_list
  - add_category_to_loadable_list

- call_load_methods
  - call_class_loads
  - call_category_loads
  - <font color='red'>(*load_method)(cls, SEL_load)</font>

+load方法是根据方法地址直接调用，并不是经过objc_msgSend函数调用





## 面试题

#### Q：+load方法是什么时候调用的？

A：pload方法在runtime加载类、分类的时候调用



#### Q：+load 方法能继承吗？

A：+load方法可以继承，但是一般情况下不会主动去调用load方法，都是让系统自动调用