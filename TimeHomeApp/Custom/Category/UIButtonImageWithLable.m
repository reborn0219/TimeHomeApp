//
//  UIButtonImageWithLable.m
//  YouLifeApp
//
//  Created by 王好雷 on 15/8/7.
//  Copyright © 2015年 us. All rights reserved.
//

#import "UIButtonImageWithLable.h"
#import "MacroDefinition.h"

@implementation UIButton (UIButtonImageWithLable)


-(UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
/**
 *  设置Button图片在上文字在下
 *
 *  @param image     图片
 *  @param title     文字
 *  @param font      字体
 *  @param stateType 点击状态
 */
- (void) setTopImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    [self.imageView setContentMode:UIViewContentModeCenter];
    //UIImage *imagenew =[self imageWithImage:image scaledToSize:CGSizeMake(50*WDPI,50*WDPI)];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(-(self.frame.size.height-imagenew.size.height
//    UIImage *imagenew =[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width*WDPI, image.size.height*WDPI)];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(-(self.frame.size.height-image.size.height
//                                                )/2,
//                                              -1.0,
//                                              0.0,
//                                              -titleSize.width)];
//    [self setImage:image forState:stateType];
//    
//    [self.titleLabel setContentMode:UIViewContentModeCenter];
//    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height+5,
//                                              -image.size.width ,
//                                              0.0,
//                                              0.0)];
//    [self setTitle:title forState:stateType];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-self.frame.size.height/4,
                                              -1.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              -image.size.width,
                                              -self.frame.size.height/1.7,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

/**
 *  设置Button图片在右文字在左
 *
 *  @param image     图片
 *  @param title     文字
 *  @param font      字体
 *  @param stateType 点击状态
 */
- (void) setrightImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType
{
    [self setTitle:title forState:stateType];
    [self setImage:image forState:stateType];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    NSLog(@"titlesize:==%lf imgsize:==%lf",titleSize.width,image.size.width);

    self.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [self.imageView setContentMode:UIViewContentModeCenter];
//   UIImage *imagenew =[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width*WDPI, image.size.height*WDPI)];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
//                                              1.9*tmpRect.size.width*WDPI,
//                                              0.0,
//                                              0.0)];
//
// 
//    [self.titleLabel setContentMode:UIViewContentModeCenter];
//    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
//                                              -image.size.width,
//                                              0.0,
//                                              0.0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];

//    [self setContentEdgeInsets:UIEdgeInsetsMake(0.0,(self.frame.size.width-titleSize.width-image.size.width-5)/2,0.0,0.0)];

}





@end
