//
//  ZSY_AddressSuperviseCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_AddressSuperviseCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabelBig;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //隐藏不用
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
//地址
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;
//设为默认
@property (weak, nonatomic) IBOutlet UIButton *defaultAddressButton;
//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *editorButton;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *bottonLineView;

///地址距上高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTop;
///地址图标距上高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressImagetop;

@property (nonatomic,copy)CellEventBlock block;
@property (nonatomic,copy)ViewsEventBlock block2;
@property (nonatomic,assign)BOOL isDefault;
@end
