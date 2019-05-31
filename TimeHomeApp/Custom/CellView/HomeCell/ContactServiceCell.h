//
//  ContactServiceCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  联系物业列表Cell
 */
#import <UIKit/UIKit.h>
#import "L_ContactPropertyModel.h"

@interface ContactServiceCell : UITableViewCell
/**
 *  联系人名称
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
/**
 *  手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Phone;
/**
 *  所在索引
 */
@property(strong,nonatomic) NSIndexPath * indexPath;

/**
 电话图标按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

/**
 物业名称
 */
@property (weak, nonatomic) IBOutlet UILabel *property_Label;

@property (weak, nonatomic) IBOutlet UIView *propertyBgView;


@property (nonatomic, strong) L_ContactPropertyModel *model;

@end
