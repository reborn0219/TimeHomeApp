//
//  OBDShowAlertVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "OBDShowAlertVC.h"
#import "UIButtonImageWithLable.h"
@interface OBDShowAlertVC ()
{
    
    NSString *firstTitles;
    NSString *secondTitles;
    NSString *detailText;
}

@end

@implementation OBDShowAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _topTitleLabel.text = firstTitles;
    _topSecondLabel.text = secondTitles;
    _showDetailLabel.text = detailText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//单例初始化
+(instancetype)shareOBDShowAlert {
    
    static OBDShowAlertVC * obdShow = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        obdShow = [[self alloc] initWithNibName:@"OBDShowAlertVC" bundle:nil];
        
    });
    
    return obdShow;
}

/**
 *  获取实例
 *
 *  @return return value description
 */
+(OBDShowAlertVC *)getInstance{
    OBDShowAlertVC * obdShow= [[OBDShowAlertVC alloc] initWithNibName:@"OBDShowAlertVC" bundle:nil];
    return obdShow;
}

-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andSecondTitle:(NSString *)secondTitle andShowDetailLabelText:(NSString *)showDetailLabelText {
    
    firstTitles=title;
    secondTitles = secondTitle;
    NSLog(@"%@",_showDetailLabel.text);
    detailText=showDetailLabelText;
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    
    if (SCREEN_WIDTH <= 320) {
        _bgView.frame = CGRectMake(10, SCREEN_HEIGHT / 2 + 150, SCREEN_WIDTH - 20, 300);
//        _bgView.sd_layout.heightIs(SCREEN_HEIGHT / 5 * 2).leftSpaceToView(self.view,8).rightSpaceToView(self.view,8).centerYEqualToView(self.view);
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
//        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    
    
    [VC presentViewController:self animated:YES completion:^{
    
    }];

    
    
}
///点击半透明区域结束
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}


-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark -- 按钮点击

/**
 *返回按钮
 **/
- (IBAction)backButtonClick:(id)sender {
    
    [self dismiss];
}

/**
 *上一个
 **/
- (IBAction)lastButtonClcik:(id)sender {
    if(self.block)
    {
        self.block(nil,nil,1);
    }
    
//    [self dismiss];
    
}

/**
 *下一个
 **/
- (IBAction)nextButtonClcik:(id)sender {
    
    if(self.block)
    {
        self.block(nil,nil,2);
    }
    
//    [self dismiss];
}

@end
