//
//  PushMsgModel.m
//  TimeHomeApp
//
//  Created by us on 16/4/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PushMsgModel.h"

@implementation PushMsgModel
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.type= [aDecoder decodeObjectForKey:@"type"] ;
    self.content=[aDecoder decodeObjectForKey:@"content"];
    self.countMsg= [aDecoder decodeObjectForKey:@"countMsg"] ;
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.countMsg forKey:@"countMsg"];
}
@end
