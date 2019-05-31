//
//  L_DatePickerViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_DatePickerViewController.h"

@interface L_DatePickerViewController ()
{
    NSString *titleMsg;
}
/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation L_DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _title_Label.text = [XYString IsNotNull:titleMsg];
    
    if (![XYString isBlankString:_minDate]) {
        _datePicker.minimumDate = [XYString NSStringToDate:_minDate withFormat:@"yyyy-MM-dd"];
    }
    
}

- (IBAction)allBtnsDidClick:(UIButton *)sender {
    //1.取消 2.确定
    NSLog(@"点击按钮");
    
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString * s1 = [df stringFromDate:_datePicker.date];
    
    if (self.selectButtonCallBack) {
        self.selectButtonCallBack(s1, nil, sender.tag);
    }
    [self dismissVC];
}

/**
 *  返回实例
 */
+ (L_DatePickerViewController *)getInstance {
    L_DatePickerViewController * givenPopVC = [[L_DatePickerViewController alloc] initWithNibName:@"L_DatePickerViewController" bundle:nil];
    return givenPopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withTitle:(NSString *)title cellEvent:(ViewsEventBlock)eventCallBack {
    
    self.selectButtonCallBack = eventCallBack;
    
    titleMsg = title;
    
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
