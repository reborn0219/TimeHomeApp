//
//  UserNoticeCountModel.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserNoticeCountModel.h"

@implementation UserNoticeCountModel

@synthesize usercount;
@synthesize usernotice;
@synthesize userallcount;
@synthesize userlasttime;
@synthesize picurl;
@synthesize subscript;
@synthesize title;
@synthesize type;
@synthesize istop;
@synthesize receiveID;

-(id)copyWithZone:(NSZone *)zone
{
    UserNoticeCountModel *model = [[UserNoticeCountModel allocWithZone:zone] init];
    model.userallcount = self.userallcount;
    model.usercount = self.usercount;
    model.usernotice = self.usernotice;
    model.userlasttime = self.userlasttime;
    model.istop = self.istop;
    model.title = self.title;
    model.subscript = self.subscript;
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.usercount forKey:@"usercount"];
    [aCoder encodeObject:self.usernotice forKey:@"usernotice"];
    [aCoder encodeObject:self.userallcount forKey:@"userallcount"];
    [aCoder encodeObject:self.userlasttime forKey:@"userlasttime"];
    [aCoder encodeObject:self.picurl forKey:@"picurl"];
    [aCoder encodeObject:self.subscript forKey:@"subscript"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.istop forKey:@"istop"];
    [aCoder encodeObject:self.receiveID forKey:@"receiveID"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.usercount = [aDecoder decodeObjectForKey:@"usercount"];
        self.usernotice = [aDecoder decodeObjectForKey:@"usernotice"];
        self.userallcount = [aDecoder decodeObjectForKey:@"userallcount"];
        self.userlasttime = [aDecoder decodeObjectForKey:@"userlasttime"];
        self.picurl = [aDecoder decodeObjectForKey:@"picurl"];
        self.subscript = [aDecoder decodeObjectForKey:@"subscript"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.istop = [aDecoder decodeObjectForKey:@"istop"];
        self.receiveID = [aDecoder decodeObjectForKey:@"receiveID"];


    }
    return self;
}

@end
