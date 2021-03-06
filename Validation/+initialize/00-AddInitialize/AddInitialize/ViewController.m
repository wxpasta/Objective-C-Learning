//
//  ViewController.m
//  AddLoad
//
//  Created by 巴糖 on 2021/3/5.
//

#import "ViewController.h"
#import "BJPerson.h"
#import "BJStudent.h"
#import "BJCat.h"
#import "BJDog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [BJPerson alloc];
    [BJStudent alloc];
    [BJPerson alloc];
    [BJStudent alloc];
    /*
     +initialize方法会在类第一次接收到消息时调用

     调用顺序
     先调用父类的+initialize，再调用子类的+initialize
     (先初始化父类，再初始化子类，每个类只会初始化1次)
     
     */
}


@end
