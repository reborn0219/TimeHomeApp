//
//  ChangCityHreadCell.h
//  TimeHomeApp
//
//  Created by us on 16/3/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangCityHreadCell : UITableViewCell
///热门城市1
@property (weak, nonatomic) IBOutlet UIButton *btn_One;
///热门城市2
@property (weak, nonatomic) IBOutlet UIButton *btn_Two;
///热门城市3
@property (weak, nonatomic) IBOutlet UIButton *btn_Three;
///热门城市4
@property (weak, nonatomic) IBOutlet UIButton *btn_Four;
///事件回调
@property(nonatomic,copy) ViewsEventBlock eventBlock;
@end
