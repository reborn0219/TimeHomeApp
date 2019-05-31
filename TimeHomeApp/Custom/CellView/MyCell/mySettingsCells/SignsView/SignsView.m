//
//  SignsView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SignsView.h"

@interface SignsView ()


@end

@implementation SignsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(WidthSpace(30), (self.frame.size.height-WidthSpace(216))/2.f, self.frame.size.width-2*WidthSpace(30), WidthSpace(216))];
        lineView.layer.borderColor = LINE_COLOR.CGColor;
        lineView.layer.borderWidth = 1;
        [self addSubview:lineView];
        
        _signTextView = [[THPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 5, lineView.frame.size.width-20, lineView.frame.size.height-10)];
//        _signTextView.delegate = self;
        _signTextView.textColor = TITLE_TEXT_COLOR;
        _signTextView.font = DEFAULT_FONT(15);
        [lineView addSubview:_signTextView];
        _signTextView.enablesReturnKeyAutomatically = YES;
        
        
        _countsLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.frame.size.width-80-10, lineView.frame.size.height-20-10, 80, 20)];
        _countsLabel.textAlignment = NSTextAlignmentRight;
        _countsLabel.font = DEFAULT_FONT(13);
        _countsLabel.textColor = TEXT_COLOR;
        [lineView addSubview:_countsLabel];
        
        _cancel_Button = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel_Button.hidden = YES;
//        _cancel_Button.backgroundColor = [UIColor redColor];
//        [_cancel_Button setBackgroundImage:[UIImage imageNamed:@"我的_个人资料_一键清除已填写信息"] forState:UIControlStateNormal];
        [_cancel_Button setImage:[UIImage imageNamed:@"我的_个人资料_一键清除已填写信息"] forState:UIControlStateNormal];
        [self addSubview:_cancel_Button];
        [_cancel_Button addTarget:self action:@selector(cancelInfo) forControlEvents:UIControlEventTouchUpInside];
        [_cancel_Button mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(_countsLabel.mas_right).offset(5);
            make.top.equalTo(_signTextView.mas_top).offset(0);

            make.width.height.equalTo(@25);
            
        }];
    }
    return self;
}
- (void)cancelInfo {
    [_signTextView resignFirstResponder];
    if (self.callBack) {
        self.callBack();
    }
}
//- (void)setMasLimitCount:(NSInteger)masLimitCount {
//    _masLimitCount = masLimitCount;
//    _countsLabel.text = [NSString stringWithFormat:@"0/%ld",_masLimitCount];
//
//}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//
//{    if (![text isEqualToString:@""]){
//    
//    _signTextView.placeHolder.hidden = YES;
//    
//     } if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
//        
//        _signTextView.placeHolder.hidden = NO;
//    }
//    
//    if (range.location >= _masLimitCount)
//    {
//        return  NO;
//    }
//    else
//    {
//        return YES;
//    }
//    
//}




@end
