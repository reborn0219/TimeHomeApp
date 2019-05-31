//
//  TwoBtnTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "TwoBtnTVC.h"
#import "MyJFButton.h"
//#import "MySmallButton.h"

@interface TwoBtnTVC ()

@property (nonatomic, strong) MyJFButton *leftButton;
@property (nonatomic, strong) MyJFButton *rightButton;

@end

@implementation TwoBtnTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUp];
        
    }
    return self;
}
- (void)setUp {

    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    bgView.sd_layout.leftSpaceToView(self.contentView,7).rightSpaceToView(self.contentView,7).topEqualToView(self.contentView).bottomEqualToView(self.contentView);
    
    _leftButton = [MyJFButton buttonWithType:UIButtonTypeCustom];
    _leftButton.tag = 1;
    _leftButton.imageType = 0;
    [bgView addSubview:_leftButton];
    _leftButton.sd_layout.leftEqualToView(bgView).topEqualToView(bgView).bottomEqualToView(bgView).widthIs((SCREEN_WIDTH-15)/2.f);
    [_leftButton addTarget:self action:@selector(myMoneyAndJFClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0XD4D4D4);
    [bgView addSubview:line1];
    line1.sd_layout.heightIs(WidthSpace(52.f)).widthIs(2).centerXEqualToView(bgView).centerYEqualToView(bgView);
    
    _rightButton = [MyJFButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:_rightButton];
    _rightButton.tag = 2;
    _rightButton.imageType = 1;
    _rightButton.sd_layout.rightEqualToView(bgView).topEqualToView(bgView).bottomEqualToView(bgView).widthIs((SCREEN_WIDTH-15)/2.f);
    [_rightButton addTarget:self action:@selector(myMoneyAndJFClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //-----------------------------------------------
//    NSArray *titles = @[@"余额",@"积分",@"收藏",@"订单"];
//    NSArray *images = @[@"余额",@"积分",@"收藏",@"订单"];
//
//    
//    float width = SCREEN_WIDTH/4.f;
//    
//    for (int i = 0; i < 4; i++) {
//        
//        MySmallButton *button = [MySmallButton buttonWithType:UIButtonTypeCustom];
//        [self.contentView addSubview:button];
//        button.frame = CGRectMake(width*i, 0, width, 70);
//        button.tag = i+1;
//        button.bottom_Image.image = [UIImage imageNamed:images[i]];
//        button.bottom_Label.text = titles[i];
//        [button addTarget:self action:@selector(myMoneyAndJFClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
    
}
- (void)myMoneyAndJFClick:(UIButton *)button {
    
    if (self.twoButtonClickCallBack) {
        self.twoButtonClickCallBack(button.tag);
    }
    
}
/**
 *  收藏
 */
//- (void)setCollectionNumber:(NSString *)collectionNumber {
//    _collectionNumber = collectionNumber;
//    
//    MySmallButton *button = [self.contentView viewWithTag:3];
//    button.top_Label.text = collectionNumber;
//    button.top_Label.textColor = UIColorFromRGB(0X63B6FC);
//}
/**
 *  订单
 */
//- (void)setOrderNumber:(NSString *)orderNumber {
//    _orderNumber = orderNumber;
//    
//    MySmallButton *button = [self.contentView viewWithTag:4];
//    button.top_Label.text = orderNumber;
//    button.top_Label.textColor = UIColorFromRGB(0X63B6FC);
//}
/**
 *  积分
 */
- (void)setJfCountString:(NSString *)jfCountString {
    
    _jfCountString = jfCountString;

//    MySmallButton *button = [self.contentView viewWithTag:2];
//    button.top_Label.text = jfCountString;
//    button.top_Label.textColor = UIColorFromRGB(0X63B6FC);
    
    _rightButton.jfCountString = jfCountString;
    
}
/**
 *  余额
 */
- (void)setPriceString:(NSString *)priceString {
    
    _priceString = priceString;
    
//    MySmallButton *button = [self.contentView viewWithTag:1];
//    button.top_Label.text = [NSString stringWithFormat:@"￥ %@",priceString];
//    button.top_Label.textColor = UIColorFromRGB(0XFE5B5E);
    
    _leftButton.jfCountString = [NSString stringWithFormat:@"￥%@",priceString];
//    _leftButton.jfCountString = [NSString stringWithFormat:@"￥10000.00"];

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
