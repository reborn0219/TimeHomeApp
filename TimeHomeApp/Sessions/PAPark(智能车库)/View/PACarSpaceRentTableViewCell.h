//
//  PACarportRentTableViewCell.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CarportResponseType) {
    Default, // 默认模式,允许输入,编辑
    SelectTime,// 不允许输入,响应事件切换为弹出时间框
    SelectAddressBook, // 允许输入, 按钮时间为选择联系人
    UnableEdit // 不可输入
};

@interface PACarSpaceRentTableViewCell : UITableViewCell

@property (nonatomic, strong)CellEventBlock addressBlock;
@property (nonatomic, strong)NSString * titleString;
@property (nonatomic, strong)NSString * placeString;
@property (nonatomic, strong)NSString * contentString;
@property (nonatomic, assign)CarportResponseType responseType;

@property (nonatomic, strong)NSString * maxPickerDate;

//@property (nonatomic, copy)CellEventBlock selectAddressBlock;

- (void)showAddreBook:(BOOL)show;



@end
