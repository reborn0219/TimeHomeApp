//
//  UserNoticeModel.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserNoticeModel.h"

@implementation UserNoticeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"theID":@"id"
             };
}

///设置内容
-(void)setContent:(NSString *)content
{
    _content=content;
    self.contentHeight = [XYString HeightForText:_content withSizeOfLabelFont:12.0f withWidthOfContent:SCREEN_WIDTH-71];
}

-(void)setJsondata:(NSString *)jsondata
{
    _jsondata= [NullPointerUtils toDealWithNullPointer: [jsondata mj_JSONObject]];
}

@end
