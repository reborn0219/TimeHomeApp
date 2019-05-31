//
//  LS_VistorBaseCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVisitor.h"

@interface LS_VistorBaseCell : UITableViewCell

-(void)assignmentWithModel:(UserVisitor *)UV;
-(void)assignment:(id)object;

@end
