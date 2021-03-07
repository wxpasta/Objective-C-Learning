//
//  ViewController.m
//  AddLoad
//
//  Created by 巴糖 on 2021/3/5.
//

#import "ViewController.h"
#import "BJPerson.h"
#import "BJStudent.h"
#import "BJTeacher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [BJStudent alloc];
    [BJTeacher alloc];
    /*
     +initialize方法会在类第一次接收到消息时调用

     调用顺序
     先调用父类的+initialize，再调用子类的+initialize
     (先初始化父类，再初始化子类，每个类只会初始化1次)
     
     内部实现流程
     1.判断子类未初始化
        1.1 判断父类未初始化
            1.1.1 初始化父类
        1.2初始化子类
     
     */
}


@end
