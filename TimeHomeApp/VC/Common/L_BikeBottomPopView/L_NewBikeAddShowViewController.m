//
//  L_NewBikeAddShowViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeAddShowViewController.h"
#import "RegularUtils.h"

@interface L_NewBikeAddShowViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *sharedPeopleNameTF;
@property (weak, nonatomic) IBOutlet UITextField *sharedPeoplePhoneTF;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation L_NewBikeAddShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
//    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
    
    [_sharedPeopleNameTF addTarget:self action:@selector(sharedPeopleNameTFEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [_sharedPeoplePhoneTF addTarget:self action:@selector(sharedPeopleNameTFEditingChanged:) forControlEvents:UIControlEventEditingChanged];

}

- (void)sharedPeopleNameTFEditingChanged:(UITextField *)sender {
    
    if (sender == _sharedPeopleNameTF) {
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 4)
            {
                sender.text = [sender.text substringToIndex:4];
            }
        }
    }
    
    if (sender == _sharedPeoplePhoneTF) {
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 11)
            {
                sender.text = [sender.text substringToIndex:11];
            }
        }
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.bgView]) {
        return NO;
    }
    return YES;
}
- (IBAction)twoButtonsDidTouch:(UIButton *)sender {
    
    [_sharedPeopleNameTF resignFirstResponder];
    [_sharedPeoplePhoneTF resignFirstResponder];
    
    //1.取消 2.发送权限
    if (sender.tag == 1) {
        [self dismissVC];
    }
    if (sender.tag == 2) {
        
        NSString *sharename = [_sharedPeopleNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([XYString isBlankString:sharename]) {
            [self showToastMsg:@"您还没有填写共享人的姓名" Duration:3.0];
            return;
        }
        if (sharename.length > 0) {
            if (sharename.length < 2 || sharename.length > 4) {
                [self showToastMsg:@"共享人的姓名应为2-4字" Duration:3.0];
                return;
            }
        }
        
        if ([XYString isBlankString:_sharedPeoplePhoneTF.text]) {
            [self showToastMsg:@"您还没有填写共享人的手机号" Duration:3.0];
            return;
        }
        if (![RegularUtils isPhoneNum:_sharedPeoplePhoneTF.text]) {
            [self showToastMsg:@"手机号码格式不正确" Duration:3.0];
            return;
        }
        
        if (self.sendButtonDidTouchBlock) {
            self.sendButtonDidTouchBlock(_sharedPeopleNameTF.text, _sharedPeoplePhoneTF.text);
        }
        [self dismissVC];
    }
    
}

/**
 *  返回实例
 */
+ (L_NewBikeAddShowViewController *)getInstance {
    L_NewBikeAddShowViewController * garageTimePopVC= [[L_NewBikeAddShowViewController alloc] initWithNibName:@"L_NewBikeAddShowViewController" bundle:nil];
    return garageTimePopVC;
}
/**
 显示
 */
- (void)showVC:(UIViewController *)parent cellEvent:(SendButtonDidTouchBlock)eventCallBack{
    
    self.sendButtonDidTouchBlock = eventCallBack;
    
    
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
