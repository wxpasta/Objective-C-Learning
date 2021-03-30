# Block面试题



#### Q：block的原理是怎样的？本质是什么？

封装了函数调用以及调用环境的OC对象

```c++
struct __block_impl {
  // isa指针，所以说Block是对象
  void *isa;
  int Flags;
  int Reserved;
  // 函数指针
  void *FuncPtr;
};
```



#### Q：block的变量捕获（capture）？

| 变量类型 |关键词 | 捕获到block内部 | 访问方式 |
| -------- |-------- | --------------- | -------- |
| 局部变量 |auto | √ | 值传递 |
| 局部变量 |static | √ | 指针传递 |
| 全局变量 | | × | 直接访问 |
| 静态全局变量 |static | × | 直接访问 |



#### Q：block几种类型类型？

3种

| block类型         | 环境                  |内存区域  |
| ----------------- | -------------------------- |-------------------------- |
| __ NSGlobalBlock__ | 没有访问auto变量           |程序数据区 |
| __ NSStackBlock__ | 访问了auto变量             |栈 |
| __ NSMallocBlock__ | __NSStackBlock__调用了copy |堆  |



#### Q：每一种类型的block调用copy后的结果

| block类型         | 内存区域    |copy结果|
| ----------------- | ---------- |---------- |
| __ NSGlobalBlock__ | 程序数据区 |什么也不做|
| __ NSStackBlock__ | 栈         |堆|
| __ NSMallocBlock__ | 堆         |引用计数器加1|





#### Q：__block的作用是什么？有什么使用注意点？

block的属性修饰词为什么是copy？使用block有哪些使用注意？

block一旦没有进行copy操作，就不会在堆上

使用注意：循环引用问题



#### Q：block解决循环引用问题

##### ARC解决方案

用__ weak、__ unsafe_unretained解决

用__block解决（必须要调用block）

##### MRC解决方案

用__unsafe_unretained解决

用__block解决（必须要调用block）



> 注意：
> __ weak：不会产生强引用，指向的对象销毁时，会自动让指针置为nil。
> __ unsafe_unretained：不会产生强引用，不安全，指向的对象销毁时，指针存储的地址值不变。



#### Q：block在修改SMutableArray，需不需要添加__block？

不需要