# 面试题：RunLoop



#### Q：讲讲 RunLoop，项目中有用到吗？

控制线程生命周期（线程保活）

解决NSTimer在滑动时停止工作的问题

监控应用卡顿

性能优化



#### Q：runloop内部实现逻辑？



#### Q：runloop和线程的关系？

每条线程都有唯一的一个与之对应的RunLoop对象

RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value

线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建

RunLoop会在线程结束时销毁

主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop



#### Q：timer 与 runloop 的关系？



#### Q：程序中添加每3秒响应一次的NSTimer，当拖动tableview时timer可能无法响应要怎么解决？



#### Q：runloop 是怎么响应用户操作的， 具体流程是什么样的？



#### Q：说说runLoop的几种状态



#### Q：runloop的mode作用是什么？



#### Q：Q：runloop系统应用范畴

- 定时器（Timer）、PerformSelector
- GCD Async Main Queue
- 事件响应、手势识别、界面刷新
- 网络请求
- AutoreleasePool