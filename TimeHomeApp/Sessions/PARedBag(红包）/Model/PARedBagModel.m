//
//  PARedBagModel.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PARedBagModel.h"

@implementation PARedBagModel

+(PARedBagModel*)redBagWithDetail:(PARedBagDetailModel *)redBagDetail{
    
    PARedBagModel *redBag = [[PARedBagModel alloc]init];
    
    redBag.type = redBagDetail.type;
    redBag.userticketid = redBagDetail.userticketid;
    redBag.logo = redBagDetail.unpackpic;
    redBag.state = redBagDetail.state;
    redBag.orderid = redBagDetail.orderid;
    
    return redBag;
}

-(NSString *)userticketid{
        
    if (self.list) {
        NSMutableString *userticketIds = [NSMutableString string];
        
        for (NSDictionary *dic in self.list) {
            
            NSString *userticketId = [dic objectForKey:@"userticketid"];
            
            [userticketIds appendFormat:@"%@",userticketId];
            
            if (NO == [dic isEqual:self.list.lastObject]) {
                [userticketIds appendString:@","];
            }
        }
         return userticketIds;
    }else{
        return _userticketid;
    }    
}

+(PARedBagModel *)redBagWithUserticketids:(NSString*)userticketids{
    
    if (!userticketids) {
        return nil;
    }
    
    PARedBagModel *redBag = [[PARedBagModel alloc]init];
    
    NSArray *tickidArray = [userticketids componentsSeparatedByString:@","];
    
    NSMutableArray *usertickDicArray = [NSMutableArray array];
    
    for (NSString *tickId in tickidArray) {
        [usertickDicArray addObject:@{@"userticketid":tickId}];
    }
    
    redBag.list = usertickDicArray;
    
    return redBag;
}

@end
