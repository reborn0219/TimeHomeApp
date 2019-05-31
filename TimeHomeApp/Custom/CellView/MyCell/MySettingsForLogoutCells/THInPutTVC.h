//
//  THInPutTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在房产授权和车位授权中使用过，主要样子为label+输入框+按钮（可隐藏）
 *
 *  @param NSInteger
 *  @param ViewType
 *
 *  @return
 */
#import "THABaseTableViewCell.h"
#import "THAuthoritySelectButton.h"
#import "CustomTextFIeld.h"


typedef NS_ENUM(NSInteger, ViewType) {
    ViewTypeTextField = 0,
    ViewTypeButton = 1,
};//右边控件类型

typedef NS_ENUM(NSInteger, RightViewLength) {
    RightViewLengthDefault = 0,//默认是短的
    RightViewLengthLongToCellBorder = 1,//长的，到达cell右边框
};//右边控件长度

typedef void (^ TextFieldCallBack)(NSString *string);

typedef void (^ DateButtonClickCallBack)(BOOL buttonSelected);

typedef void (^ PeopleInfosCallBack)(void);

@interface THInPutTVC : THABaseTableViewCell
/**
 *  右边控件长度
 */
@property (nonatomic, assign) RightViewLength rightViewLength;
/**
 *  左边标题
 */
@property (nonatomic, strong) UILabel *leftTitleLabel;
/**
 *  右边通讯录按钮
 */
@property (nonatomic, strong) THAuthoritySelectButton *rightButton;
/**
 *  输入框,默认隐藏
 */
@property (nonatomic, strong) CustomTextFIeld *phoneTF;
/**
 *  选择日期label
 */
@property (nonatomic, strong) UILabel *buttonTitleLabel;
/**
 *  限制字数,默认100字
 */
//@property (nonatomic, assign) NSInteger lengthLimited;
/**
 *  类型：按钮或输入框
 */
@property (nonatomic, assign) ViewType viewType;
/**
 *  返回输入框的值
 */
@property (nonatomic, copy) TextFieldCallBack textFieldCallBack;
/**
 *  选择日期回调
 */
@property (nonatomic, copy) DateButtonClickCallBack dateButtonClickCallBack;
/**
 *  时间选择按钮,默认隐藏
 */
@property (nonatomic, strong) UIButton *dateSelectButton;
/**
 *  通讯录按钮回调
 */
@property (nonatomic, copy) PeopleInfosCallBack peopleInfosCallBack;


@end
