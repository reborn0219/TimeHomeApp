//
//  AnimatedAnnotation.h
//  Category_demo2D
//
//  Created by 刘博 on 13-11-8.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AnimatedAnnotation : BMKShape

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//@property (nonatomic, strong) NSString *title;
//@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) NSMutableArray *animatedImages;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
