//
//  UserInfoModel.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserInfoModel.h"
@implementation UserInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID":@"id"};
}
-(void)setTaglist:(NSArray *)taglist
{
    _taglist = taglist;
    NSMutableArray * tempArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i<taglist.count;i++) {
        NSDictionary * tagDic = [taglist objectAtIndex:i];
        [tempArr addObject:[tagDic objectForKey:@"name"]];
    }
    _tags = tempArr;
    NSString * s = [_tags componentsJoinedByString:@" "];
    CGFloat h = [XYString HeightForText:s withSizeOfLabelFont:13.0f withWidthOfContent:SCREEN_WIDTH-100];
    _tagV_H = h*2+70;
    
}
@end
