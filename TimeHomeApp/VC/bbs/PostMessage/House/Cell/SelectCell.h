//
//  SelectCell.h
//  Bessel
//
//  Created by 赵思雨 on 2016/11/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;
@property (assign, nonatomic)BOOL isSelected;
@end
