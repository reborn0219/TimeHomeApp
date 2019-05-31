//
//  PANewSuggestView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/22.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewSuggestView.h"
#import "PASuggestPhotoView.h"

@interface PANewSuggestView ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UILabel *communityLabel;
@property (nonatomic, strong)UILabel *communityNameLabel;
@property (nonatomic, strong)UITextView *inputView;
@property (nonatomic, strong)PASuggestPhotoView * photoView;
@property (nonatomic, strong)UITextField *phoneTextField;
@property (nonatomic, strong)UIButton * submitButton;
@property (nonatomic, strong)UILabel * maxCountLabel;
@end

@implementation PANewSuggestView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = UIColorHex(0xF5F5F5);
        [self createSubviews];
        [self updateViewSetting];
    }
    return self;
}

- (void)createSubviews{
    [self addSubview:self.communityLabel];
    [self addSubview:self.communityNameLabel];
    [self addSubview:self.inputView];
    [self addSubview:self.photoView];
    [self addSubview:self.phoneTextField];
    [self addSubview:self.submitButton];
    [self.communityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(13);
        make.top.equalTo(self).with.offset(10);
    }];
    [self.communityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.communityLabel);
        make.left.equalTo(self.communityLabel.mas_right).with.offset(15);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.communityLabel.mas_bottom).with.offset(10);
        make.height.equalTo(@198);
    }];
    
    [self addSubview:self.maxCountLabel];
    
    [self.maxCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputView).with.offset(-13);
        make.bottom.equalTo(self.inputView).with.offset(-16);
    }];
    
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@143);
        make.top.equalTo(self.inputView.mas_bottom).with.offset(16);
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.photoView.mas_bottom).with.offset(16);
        make.height.equalTo(@50);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).with.offset(13);
        make.right.equalTo(self).with.offset(-13);
        make.height.equalTo(@44);
        make.top.equalTo(self.phoneTextField.mas_bottom).with.offset(40);
    }];
    [self.photoView showChoosePhotos];
}

#pragma mark - Lazyload

- (UILabel *)communityLabel{
    if (!_communityLabel) {
        _communityLabel = [[UILabel alloc]init];
        _communityLabel.text = @"社区名称:";
        _communityLabel.textColor = UIColorHex(0x4A4A4A);
        _communityLabel.font = [UIFont systemFontOfSize:14];
    }
    return _communityLabel;
}

- (UILabel *)communityNameLabel{
    if (!_communityNameLabel) {
        _communityNameLabel = [[UILabel alloc]init];
        AppDelegate * appDelegate = GetAppDelegates;
        _communityNameLabel.text = appDelegate.userData.communityname;
        _communityNameLabel.textColor = UIColorHex(0x4A4A4A);
        _communityNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _communityNameLabel;
}

- (UITextView *)inputView{
    if (!_inputView) {
        _inputView = [[UITextView alloc]init];
        _inputView.textColor =UIColorHex(0x4A4A4A);
        _inputView.font = [UIFont systemFontOfSize:16];
        _inputView.delegate = self;
    }
    return _inputView;
}

- (PASuggestPhotoView *)photoView{
    if (!_photoView) {
        _photoView = [[PASuggestPhotoView alloc]init];
        _photoView.maxCount = 4;
    }
    return _photoView;
}

- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.textColor = UIColorHex(0x4A4A4A);
        _phoneTextField.font = [UIFont systemFontOfSize:16];
        _phoneTextField.placeholder = @"请输入手机号(选填)";
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.textAlignment = NSTextAlignmentRight;
        _phoneTextField.delegate = self;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneTextField;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _submitButton.backgroundColor = UIColorHex(0x2D82E3);
        _submitButton.layer.cornerRadius = 3;
        [_submitButton addTarget:self action:@selector(submitSuggestAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (UILabel *)maxCountLabel{
    if (!_maxCountLabel) {
        _maxCountLabel = [[UILabel alloc]init];
        _maxCountLabel.font = [UIFont systemFontOfSize:16];
        _maxCountLabel.textColor = UIColorHex(0x9B9B9B);
        _maxCountLabel.text = @"0/240";
    }
    return _maxCountLabel;
}
#pragma mark - Actions

/**
 页面刷新设置 1.input输入区域 2.placeholder 3.限制输入数字
 */
- (void)updateViewSetting{
    self.inputView.textContainerInset = UIEdgeInsetsMake(16, 9, 33, 13);
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请补充详细建议（字数240字以内）";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = UIColorHex(0x9B9B9B);
    [placeHolderLabel sizeToFit];
    [self.inputView addSubview:placeHolderLabel];
    placeHolderLabel.font = [UIFont systemFontOfSize:16.f];
    [self.inputView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 17, 200, 16)];
    leftLabel.text = @"联系手机号";
    leftLabel.font = [UIFont systemFontOfSize:16];
    leftLabel.textColor = UIColorHex(0x9B9B9B);
    [leftView addSubview:leftLabel];
    self.phoneTextField.leftView = leftView;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 13, 50)];
    self.phoneTextField.rightView =rightView;
    self.phoneTextField.rightViewMode =UITextFieldViewModeAlways;
    [self photoViewChoosePhotoAction];
}

- (void)submitSuggestAction{
    if (self.inputView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入要提交的投诉或建议"];
        [SVProgressHUD dismissWithDelay:1.75];
        return;
    }
    if (self.inputView.text.length<6) {
        [SVProgressHUD showInfoWithStatus:@"输入的文字不少于5个字"];
        [SVProgressHUD dismissWithDelay:1.75];
        return;
    }
    NSMutableArray * photos = self.photoView.photoArray.mutableCopy;
    [photos removeLastObject];
    
    AppDelegate * appdelegate = GetAppDelegates;
    NSString * mobile = self.phoneTextField.text.length>10?self.phoneTextField.text:appdelegate.userData.phone;
    [self.delegate submitSuggestWithMobile:mobile suggestInfo:self.inputView.text photoArray:photos];
}

- (void)photoViewChoosePhotoAction{
    @weakify(self);
    self.photoView.choosePhotoBlock = ^(id  _Nullable data, ResultCode resultCode) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(choosePhotoAction)]) {
            [weak_self.delegate choosePhotoAction];
        }
    };
    self.photoView.deletePhotoBlock = ^(id  _Nullable data, ResultCode resultCode) {
        NSNumber *index = data;
        if (self.delegate && [self.delegate respondsToSelector:@selector(deletePhotoWithIndex:)]) {
            [weak_self.delegate deletePhotoWithIndex:index.integerValue];
        }
    };
}

- (void)addPhotoImage:(UIImage *)image{
    [self.photoView addPhoto:image];
}

- (void)resetSuggestView{
    self.photoView.photoArray = @[].mutableCopy;
    [self.photoView showChoosePhotos];
    self.inputView.text = @"";
    self.phoneTextField.text = @"";
    self.maxCountLabel.text = @"0/240";
}

#pragma mark -TextViewDelegate

- (BOOL)textView:(UITextView *)atextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *new = [self.inputView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 240-[new length];
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [self.inputView setText:[self.inputView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    self.maxCountLabel.text = [NSString stringWithFormat:@"%ld/240",textView.text.length];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([self validateNumber:string]) {
        //文字长度限制
        if ([aString length] > 11) {
            textField.text = [aString substringToIndex:11];
            return NO;
        }
    } else {
        return NO;
    }
    return YES;
}
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end
