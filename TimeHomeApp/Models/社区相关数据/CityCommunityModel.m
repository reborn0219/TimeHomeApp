//
//  CityCommunityModel.m
//  TimeHomeApp
//
//  Created by us on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CityCommunityModel.h"

@implementation CityCommunityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID":@"id"
             };
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.ID= [aDecoder decodeObjectForKey:@"ID"] ;
    self.name= [aDecoder decodeObjectForKey:@"name"] ;
    self.address=[aDecoder decodeObjectForKey:@"address"];
    
    self.usercount= [aDecoder decodeObjectForKey:@"usercount"] ;
    self.firstletter= [aDecoder decodeObjectForKey:@"firstletter"] ;
    self.areacode=[aDecoder decodeObjectForKey:@"areacode"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
    
    [aCoder encodeObject:self.usercount forKey:@"usercount"];
    [aCoder encodeObject:self.firstletter forKey:@"firstletter"];
    [aCoder encodeObject:self.areacode forKey:@"areacode"];
}
@end
