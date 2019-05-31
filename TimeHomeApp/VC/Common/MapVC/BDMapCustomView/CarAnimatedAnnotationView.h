//
//  MyAnimatedAnnotationView.h
//  YouLifeApp
//
//  Created by us on 15/10/24.
//  Copyright © 2015年 us. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CustomCalloutView.h"

@interface CarAnimatedAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CustomCalloutView *calloutView;
@end
