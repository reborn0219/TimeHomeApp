//
//  LS_VistorSCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVisitor.h"

@interface LS_VistorSCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

-(void)assignmentWithModel:(UserVisitor *)UV;

@end
