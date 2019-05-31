//
//  LocationInfo.m
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.latitude= [aDecoder decodeDoubleForKey:@"latitude"] ;
    self.longitude= [aDecoder decodeDoubleForKey:@"longitude"] ;
    self.cityName= [aDecoder decodeObjectForKey:@"cityName"] ;
    self.addres=[aDecoder decodeObjectForKey:@"addres"];
    
    self.streetNumber= [aDecoder decodeObjectForKey:@"streetNumber"] ;
    self.streetName= [aDecoder decodeObjectForKey:@"streetName"] ;
    self.district=[aDecoder decodeObjectForKey:@"district"];
    self.province=[aDecoder decodeObjectForKey:@"province"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.addres forKey:@"addres"];
    
    [aCoder encodeObject:self.streetNumber forKey:@"streetNumber"];
    [aCoder encodeObject:self.streetName forKey:@"streetName"];
    [aCoder encodeObject:self.district forKey:@"district"];
    [aCoder encodeObject:self.province forKey:@"province"];
}


@end
