//
//  UserMsgModel.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserMsgModel.h"

@implementation UserMsgModel

-(void)setMsgcontent:(NSString *)msgcontent
{
    _msgcontent = msgcontent;
    self.cellHight = [XYString HeightForText:_msgcontent withSizeOfLabelFont:13.0f withWidthOfContent:SCREEN_WIDTH-160];

}
@end
