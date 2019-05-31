//
//  L_AddFamilysViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_AddFamilysViewController.h"

@interface L_AddFamilysViewController ()

/**
 内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayoutConstraint;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView1;

@end

@implementation L_AddFamilysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameTF.placeholder = @"家人姓名";
    _phoneNumTF.placeholder = @"家人手机号";
    _contentViewHeightLayoutConstraint.constant = SCREEN_HEIGHT - 16 - 64;
    
    _bgView1.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView1.layer.borderWidth = 1;
    _bgView2.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView2.layer.borderWidth = 1;
    
}
// MARK: - 添加按钮点击
- (IBAction)addButtonDidTouch:(UIButton *)sender {
    
    
}

- (IBAction)allTFEditingChanged:(UITextField *)sender {
    
    if (sender == _nameTF) {
        
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 6)
            {
                sender.text=[sender.text substringToIndex:6];
            }
        }
        
    }else if (sender == _phoneNumTF) {
        
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
