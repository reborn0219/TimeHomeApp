//
//  BMKPoiInfo+AddModels.h
//  YouLifeApp
//
//  Created by us on 15/10/29.
//  Copyright © 2015年 us. All rights reserved.
//

///地图中用到地计算地址高度
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface BMKPoiInfo (AddModels)

@property(nonatomic,retain) NSString * addr_disStr;//地址距离电话
@property(nonatomic) CGFloat cell_H;//高度
-(void)calculateCell_H;

@end
