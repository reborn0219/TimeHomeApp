//
//  RaiN_AddLabelCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_AddLabelCell.h"
@interface RaiN_AddLabelCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation RaiN_AddLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.backgroundColor = kNewRedColor;
    _addButton.titleLabel.font = DEFAULT_BOLDFONT(15);
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.contentView addSubview:_addButton];
    [_addButton addTarget:self action:@selector(addTagsClick) forControlEvents:UIControlEventTouchUpInside];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-WidthSpace(24));
        make.width.equalTo(@(WidthSpace(164)));
        make.height.equalTo(@(WidthSpace(54)));
    }];
    
    UIView *view = [[UIView alloc]init];
    [self.contentView addSubview:view];
    
    view.layer.borderColor = LINE_COLOR.CGColor;
    view.layer.borderWidth = 1.f;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthSpace(30.f));
        make.right.equalTo(_addButton.mas_left).offset(-WidthSpace(30.f));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@35);
    }];
    
    _addtagTF = [[CustomTextFIeld alloc]init];
    _addtagTF.font = DEFAULT_FONT(12);
    _addtagTF.enablesReturnKeyAutomatically = YES;
    _addtagTF.placeholder = @"在此创建自己的标签（5字以内）";
    _addtagTF.clearButtonMode = UITextFieldViewModeAlways;
    _addtagTF.delegate = self;
    [_addtagTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:_addtagTF];
    
    [_addtagTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10.f);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    
    
}
- (void) textFieldDidChange:(CustomTextFIeld *) TextField{
    
    if (TextField == _addtagTF) {
        UITextRange * selectedRange = TextField.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(TextField.text.length >= 6)
            {
                TextField.text=[TextField.text substringToIndex:6];
            }
        }
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.nextResponder) {
        
    }
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    
    return YES;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
//    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
//    if ([string isEqualToString:@"\n"])  //按会车可以改变
//    {
//        return YES;
//    }
//
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//
//    if (_addtagTF == textField)  //判断是否时我们想要限定的那个输入框
//    {
//        if ([toBeString length] > 6) { //如果输入框内容大于6
//            textField.text = [toBeString substringToIndex:6];
//            return NO;
//        }
//    }
    return YES;
}
- (void)addTagsClick {
    
    if (self.addTagsCallBack) {
        self.addTagsCallBack();
    }
}


@end
