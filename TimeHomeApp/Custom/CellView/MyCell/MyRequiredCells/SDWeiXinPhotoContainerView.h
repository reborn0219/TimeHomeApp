//
//  SDWeiXinPhotoContainerView.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

/**
 *  图片控制器，可点击放大，收藏相册中
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"

@interface SDWeiXinPhotoContainerView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;

@end
