//
//  THNickNameTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THNickNameTVC.h"


@implementation THNickNameTVC 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    UIView *view = [[UIView alloc]init];
    [self.contentView addSubview:view];
    
    view.layer.borderColor = LINE_COLOR.CGColor;
    view.layer.borderWidth = 1.f;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthSpace(30.f));
        make.right.equalTo(self.contentView).offset(-WidthSpace(30.f));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@35);
    }];
    
    _nickNameTF = [[CustomTextFIeld alloc]init];
    _nickNameTF.font = DEFAULT_FONT(15);
    _nickNameTF.enablesReturnKeyAutomatically = YES;
    _nickNameTF.textColor = TEXT_COLOR;
    _nickNameTF.clearButtonMode = UITextFieldViewModeAlways;
    [_nickNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:_nickNameTF];
    
    [_nickNameTF mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(view).offset(10.f);
        make.right.equalTo(view).offset(-10);

        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
}

- (void) textFieldDidChange:(CustomTextFIeld *) TextField{
    
    if (TextField == _nickNameTF) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(TextField.text.length >= 10)
            {
                TextField.text=[TextField.text substringToIndex:10];
            }
        }
    }
    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//{
//    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
//    if ([string isEqualToString:@"\n"])  //按会车可以改变
//    {
//        return YES;
//    }
//    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    
//    if (_nickNameTF == textField)  //判断是否时我们想要限定的那个输入框
//    {
//        if ([toBeString length] > 10) { //如果输入框内容大于10则弹出警告
//            textField.text = [toBeString substringToIndex:10];
//            return NO;
//        }
//    }
//    return YES;
//}


@end
