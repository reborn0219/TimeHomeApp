//
//  L_GivenPopVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GivenPopVC.h"

@interface L_GivenPopVC ()

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 留言输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *messageTF;

/**
 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/**
 发送按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

/**
 输入框下方适配间隔
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFBottomLayoutConstraint;

@property (nonatomic, strong) NSDictionary *infoDict;

@end

@implementation L_GivenPopVC

- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    //1.取消 2.发送
    [_messageTF resignFirstResponder];
    
    if (self.selectButtonCallBack) {
        self.selectButtonCallBack(sender.tag,_messageTF.text);
    }
    if (sender.tag == 1) {
        [self dismissVC];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    if (SCREEN_WIDTH == 320) {
        _TFBottomLayoutConstraint.constant = 15;
    }else {
        _TFBottomLayoutConstraint.constant = 25;
    }
    
    _cancelButton.layer.borderColor = kNewRedColor.CGColor;
    _cancelButton.layer.borderWidth = 1;
    
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.cornerRadius = 22.f;
    
    _messageTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"留言 : 说点什么吧！" attributes:@{NSForegroundColorAttributeName:TITLE_TEXT_COLOR}];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_infoDict[@"picurl"]] placeholderImage:kHeaderPlaceHolder];
    _nickNameLabel.text = [XYString IsNotNull:_infoDict[@"nickname"]];
    
    [_messageTF addTarget:self action:@selector(messageTF_ChangeEvent:) forControlEvents:UIControlEventEditingChanged];
}
- (void)messageTF_ChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>=20)
        {
            sender.text=[sender.text substringToIndex:20];
        }
    }
}

/**
 *  返回实例
 */
+ (L_GivenPopVC *)getInstance {
    L_GivenPopVC * givenPopVC = [[L_GivenPopVC alloc] initWithNibName:@"L_GivenPopVC" bundle:nil];
    return givenPopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withInfoDict:(NSDictionary *)dict cellEvent:(SelectButtonCallBack)eventCallBack {
    
    self.selectButtonCallBack = eventCallBack;
//@{@"picurl":model.userpicurl,@"nickname":model.nickname}
    _infoDict = [dict copy];
    
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
