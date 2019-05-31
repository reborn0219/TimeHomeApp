//
//  RentalAndSalesCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  求租、求售列表cell展示
 */
#import <UIKit/UIKit.h>

@interface RentalAndSalesCell : UITableViewCell
///标题
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
///室，小区， 二手
@property (weak, nonatomic) IBOutlet UILabel *lab_RoomCommunity;
///价格
@property (weak, nonatomic) IBOutlet UILabel *lab_Price;
@property (weak, nonatomic) IBOutlet UILabel *lab_Date;

@end
