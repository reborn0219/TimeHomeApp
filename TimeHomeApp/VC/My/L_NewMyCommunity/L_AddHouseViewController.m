//
//  L_AddHouseViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_AddHouseViewController.h"
#import "L_VertifyStateViewController.h"

@interface L_AddHouseViewController ()
{
    AppDelegate *appDlgt;
}
/**
 楼栋名
 */
@property (weak, nonatomic) IBOutlet UITextField *tf1;

/**
 单元名
 */
@property (weak, nonatomic) IBOutlet UITextField *tf2;

/**
 房间号
 */
@property (weak, nonatomic) IBOutlet UITextField *tf3;

/**
 姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *tf4;

/**
 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *tf5;

/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *tf6;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;

/**
 内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightlayoutConstraint;

@end

@implementation L_AddHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDlgt = GetAppDelegates;
    
    _tf5.text = [XYString IsNotNull:appDlgt.userData.phone];
    
    _tf1.placeholder = @"楼栋名称";
    _tf2.placeholder = @"单元名称";
    _tf3.placeholder = @"房间号";
    _tf4.placeholder = @"业主姓名";
    _tf5.placeholder = @"业主手机号";
    _tf6.placeholder = @"验证码";
    
    if (SCREEN_WIDTH == 320) {
        _contentViewHeightlayoutConstraint.constant = 550;

    }else {
        _contentViewHeightlayoutConstraint.constant = SCREEN_HEIGHT - 16 - 64;
    }

    _bgView1.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView1.layer.borderWidth = 1;
    _bgView2.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView2.layer.borderWidth = 1;
    _bgView3.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView3.layer.borderWidth = 1;
    _bgView4.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView4.layer.borderWidth = 1;
    _bgView5.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView5.layer.borderWidth = 1;
    _bgView6.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView6.layer.borderWidth = 1;
}
// MARK: - 按钮点击
- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    //tag 1.发送验证码 2.提交
    
    if (sender.tag == 1) {
        
    }else if (sender.tag == 2) {
        
        L_VertifyStateViewController *stateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_VertifyStateViewController"];
        stateVC.state = 5;
        [self.navigationController pushViewController:stateVC animated:YES];
    }
    
}

// MARK: - 输入框字数限制
- (IBAction)allTFEditingChanged:(UITextField *)sender {
    
    if (sender == _tf1) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 20)
            {
                sender.text=[sender.text substringToIndex:20];
            }
        }
        
    }else if (sender == _tf2) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 20)
            {
                sender.text=[sender.text substringToIndex:20];
            }
        }
        
    }else if (sender == _tf3) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 20)
            {
                sender.text=[sender.text substringToIndex:20];
            }
        }
        
    }else if (sender == _tf4) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 6)
            {
                sender.text=[sender.text substringToIndex:6];
            }
        }
        
    }else if (sender ==_tf5) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 11)
            {
                sender.text=[sender.text substringToIndex:11];
            }
        }
        
    }
    
}

@end
