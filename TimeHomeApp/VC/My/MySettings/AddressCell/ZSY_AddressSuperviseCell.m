//
//  ZSY_AddressSuperviseCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_AddressSuperviseCell.h"
#import "MySettingAndOtherLogin.h"
@implementation ZSY_AddressSuperviseCell


- (void)awakeFromNib {
    [super awakeFromNib];

    _bottonLineView.layer.cornerRadius = 3.0f;
    _addressTextView.editable = NO;
    _addressTextView.scrollEnabled = NO;
    _addressTextView.delegate = self;
    _nameTF.enabled = NO;
    _phoneNumberTF.enabled = NO;
    _isDefault = YES;
    _phoneNumberTF.keyboardType = UIKeyboardTypePhonePad;
    
}
- (void)setIsDefault:(BOOL)isDefault {
    _isDefault = isDefault;
    if (_isDefault) {
        self.contentView.backgroundColor = kNewRedColor;
        self.lineView.backgroundColor = PURPLE_COLOR;
        self.addressImageView.image = [UIImage imageNamed:@"个人设置-地址图标-白"];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabelBig.textColor = [UIColor whiteColor];
        self.phoneNumberLabel.textColor = [UIColor whiteColor];
        self.addressTextView.textColor = [UIColor whiteColor];
        [self.defaultAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.defaultAddressButton setImage:[UIImage imageNamed:@"个人设置-地址管理-默认图标-选中"] forState:UIControlStateNormal];
        [self.editorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.bottonLineView.backgroundColor = PURPLE_COLOR;
    }else {
        self.lineView.backgroundColor = LINE_COLOR;
        self.addressImageView.image = [UIImage imageNamed:@"个人设置-地址图标-红"];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = TITLE_TEXT_COLOR;
        self.nameLabelBig.textColor = TITLE_TEXT_COLOR;
        self.phoneNumberLabel.textColor = TITLE_TEXT_COLOR;
        self.addressTextView.textColor = TITLE_TEXT_COLOR;
        [self.defaultAddressButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        [self.defaultAddressButton setImage:[UIImage imageNamed:@"个人设置-地址管理-默认图标-未选中"] forState:UIControlStateNormal];
        [self.editorButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        self.bottonLineView.backgroundColor = LINE_COLOR;
    }

}
//编辑
- (IBAction)editorClick:(id)sender {
    if(self.block2)
    {
        self.block2(nil,nil,1);
    }

}
//删除
- (IBAction)deleteClick:(id)sender {
    if(self.block2)
    {
        self.block2(nil,nil,2);
    }
}
//默认地址
- (IBAction)defaultAddressClcik:(id)sender {
    
    self.block2(nil,nil,3);
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _addressTextView.editable = NO;
    
//    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
//    [MySettingAndOtherLogin saveMyAddressWithID:@"" AndProvinceid:@"" AndCityid:@"" AndAreaid:@"" AndAddress:@"" AndLinkMan:@"" AndLinkPhone:@"" AndIsDefault:@"" AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
//        
//        @WeakObj(self)
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
//            
//            if (resultCode == SucceedCode) {
//                
//                
//            }else {
//                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
//            }
//        });
//    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
