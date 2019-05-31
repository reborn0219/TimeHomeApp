//
//  UINavigationController+Add.m
//  Fjguang
//
//  Created by ZHAO on 15/10/22.
//  Copyright © 2015年 LX. All rights reserved.
//

#import "UINavigationController+Add.h"
#import "WebViewVC.h"
@interface UINavigationController ()<UINavigationControllerDelegate>

//@property (nonatomic,copy) id popDelegate;

@end

@implementation UINavigationController (Add)

//这个方法是在手势将要激活前调用：返回YES允许侧滑手势的激活，返回NO不允许侧滑手势的激活
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    //首先在这确定是不是我们需要管理的侧滑返回手势
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
////        if (self.currentShowVC == self.topViewController) {
//            //如果 currentShowVC 存在说明堆栈内的控制器数量大于 1 ，允许激活侧滑手势
//            return YES;
////        }
//        //如果 currentShowVC 不存在，禁用侧滑手势。如果在根控制器中不禁用侧滑手势，而且不小心触发了侧滑手势，会导致存放控制器的堆栈混乱，直接的效果就是你发现你的应用假死了，点哪都没反应，感兴趣是神马效果的朋友可以自己试试 = =。
////        return NO;
//    }
//
//    //这里就是非侧滑手势调用的方法啦，统一允许激活
//    return NO;
//}


//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (IOS8_OR_LATER) viewController.automaticallyAdjustsScrollViewInsets = NO;
//
//    if (self.childViewControllers.count > 0) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, 25, 25);
//
//        [button setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
//
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    }
//    [super pushViewController:viewController animated:animated];
//}


//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //代理
//    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
//    self.delegate = self;
//}
//
//#pragma UINavigationControllerDelegate方法
//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    //实现滑动返回功能
//    //清空滑动返回手势的代理就能实现
//    self.interactivePopGestureRecognizer.delegate =  viewController == self.viewControllers[0]? self.popDelegate : nil;
//}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

//-(BOOL)shouldAutorotate {
//    return [[self.viewControllers lastObject] shouldAutorotate];
//}
//
//-(NSUInteger)supportedInterfaceOrientations {
//    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
////    self.navigationBar.translucent = NO;
////    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    // 获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//    
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:internalAction];
//    
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//    
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    
//    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//    
//}
//// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
//// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}
@end
