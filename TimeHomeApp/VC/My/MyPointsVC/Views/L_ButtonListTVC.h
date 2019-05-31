//
//  L_ButtonListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonDidBlock)();
@interface L_ButtonListTVC : UITableViewCell

@property (nonatomic, copy) ButtonDidBlock buttonDidBlock;

@end
