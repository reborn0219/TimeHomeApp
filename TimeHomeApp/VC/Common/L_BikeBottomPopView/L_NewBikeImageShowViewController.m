//
//  L_NewBikeImageShowViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeImageShowViewController.h"
#import "SDCycleScrollView.h"

@interface L_NewBikeImageShowViewController ()<SDCycleScrollViewDelegate>

/**
 滑动视图背景view
 */
@property (weak, nonatomic) IBOutlet UIView *scrollBgView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *middleBgView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation L_NewBikeImageShowViewController

//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    
//    [self.view layoutIfNeeded];
//    [self.bgView layoutIfNeeded];
//    [self.bottomButton layoutIfNeeded];
//    [self.topLabel layoutIfNeeded];
//    [self.middleBgView layoutIfNeeded];
//    [self.scrollBgView layoutIfNeeded];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    NSArray *images = @[
                        @"添加二轮车-展示图片1@3x.png",
                        @"添加二轮车-展示图片2@3x.png",
                        @"添加二轮车-展示图片3@3x.png"
                        ];
    
    CGFloat width = SCREEN_WIDTH - 65 * 2;
    CGFloat height = width / 468 * 316.;
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, height) imageNamesGroup:images];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    cycleScrollView.autoScrollTimeInterval = 4.0;
    [_scrollBgView addSubview:cycleScrollView];
    cycleScrollView.scrollViewPageCallBack = ^(NSInteger index){
        _pageControl.currentPage = index;
    };
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
//    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
}
#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if ([touch.view isDescendantOfView:self.bgView]) {
//        return NO;
//    }
//    return YES;
//}

/**
 知道了
 */
- (IBAction)button_okDidTouchBlock:(UIButton *)sender {
    
    if (self.completeCallBack) {
        self.completeCallBack();
    }
    
    [self dismissVC];
}
/**
 *  返回实例
 */
+ (L_NewBikeImageShowViewController *)getInstance {
    L_NewBikeImageShowViewController * garageTimePopVC= [[L_NewBikeImageShowViewController alloc] initWithNibName:@"L_NewBikeImageShowViewController" bundle:nil];
    return garageTimePopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withCallBack:(CompleteCallBack)callBack {
    
    self.completeCallBack = callBack;
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:NO completion:^{
        
    }];
}
#pragma mark - 隐藏显示
-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
