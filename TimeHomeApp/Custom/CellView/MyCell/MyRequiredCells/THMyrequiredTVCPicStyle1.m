//
//  THMyrequiredTVCPicStyle1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/5/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyrequiredTVCPicStyle1.h"
#import "SDPhotoBrowser.h"

@interface THMyrequiredTVCPicStyle1 () <SDPhotoBrowserDelegate>
{
    NSMutableArray *picArray;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *imageView4;
}

@end

@implementation THMyrequiredTVCPicStyle1


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"详细描述";
    _titleLabel.font = DEFAULT_FONT(16);
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).heightIs(20).rightSpaceToView(self.contentView,15);
    
    _describeLabel = [[UILabel alloc]init];
    _describeLabel.font = DEFAULT_FONT(16);
    _describeLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:_describeLabel];
    _describeLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(_titleLabel,15).rightSpaceToView(self.contentView,15).autoHeightRatio(0);
    

    imageView1 = [[UIImageView alloc]init];
    imageView1.userInteractionEnabled = YES;
    [self.contentView addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc]init];
    imageView2.userInteractionEnabled = YES;
    [self.contentView addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc]init];
    imageView3.userInteractionEnabled = YES;
    [self.contentView addSubview:imageView3];
    
    imageView4 = [[UIImageView alloc]init];
    imageView4.userInteractionEnabled = YES;
    [self.contentView addSubview:imageView4];
    
    imageView1.tag = 0;
    imageView2.tag = 1;
    imageView3.tag = 2;
    imageView4.tag = 3;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkOutForLook:)];
    [imageView1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkOutForLook:)];
    [imageView2 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkOutForLook:)];
    [imageView3 addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkOutForLook:)];
    [imageView4 addGestureRecognizer:tap4];

    imageView1.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(_describeLabel,15).widthIs((SCREEN_WIDTH-14-30)*0.4).heightEqualToWidth();
    imageView2.sd_layout.leftSpaceToView(imageView1,15).topSpaceToView(_describeLabel,15).widthIs((SCREEN_WIDTH-14-30)*0.4).heightEqualToWidth();
    imageView3.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(imageView1,15).widthIs((SCREEN_WIDTH-14-30)*0.4).heightEqualToWidth();
    imageView4.sd_layout.leftSpaceToView(imageView3,15).topSpaceToView(imageView1,15).widthIs((SCREEN_WIDTH-14-30)*0.4).heightEqualToWidth();
    
//    [self setupAutoHeightWithBottomViewsArray:@[_describeLabel,firstImageView,secondImageView,thirdImageView,forthImageView] bottomMargin:15];
//    [self setupAutoHeightWithBottomViewsArray:@[_describeLabel,imageView1] bottomMargin:15];

}

- (void)checkOutForLook:(UITapGestureRecognizer *)tap {

    UIImageView *tapImageView = (UIImageView *)tap.view;

    NSInteger count = picArray.count;
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i < count; i++) {
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:picArray[i]];
//        photo.srcImageView = tapImageView; // 来源于哪个UIImageView
//        [photos addObject:photo];
//    }
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = tapImageView.tag; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    //    browser.delegate = self;
//    [browser show];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = tapImageView;
    browser.imageCount = count;
    browser.currentImageIndex = tapImageView.tag;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
    
}
// 返回临时占位图片（即原来的小图）

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {

    switch (index) {
        case 0:
        {
            return imageView1.image;
        }
            break;
        case 1:
        {
            return imageView2.image;
        }
            break;
        case 2:
        {
            return imageView3.image;
        }
            break;
        case 3:
        {
            return imageView4.image;
        }
            break;
        default:
        {
            return PLACEHOLDER_IMAGE;
        }
            break;
    }
}

// 返回高质量图片的url

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:picArray[index]];
}
- (void)setUserInfo:(UserReserveInfo *)userInfo {
    
    _userInfo = userInfo;
    
    _describeLabel.text = userInfo.feedback;

    picArray = [[NSMutableArray alloc]init];

    for (UserReservePic *pic in userInfo.piclist) {
        [picArray addObject:pic.fileurl];
    }
    /**
     *  图片数组
     */
    switch (picArray.count) {
        case 0:
        {
            imageView1.hidden = YES;
            imageView2.hidden = YES;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            [self setupAutoHeightWithBottomViewsArray:@[_describeLabel] bottomMargin:15];
        }
            break;
        case 1:
        {
            
            imageView1.hidden = NO;
            imageView2.hidden = YES;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [self setupAutoHeightWithBottomViewsArray:@[imageView1] bottomMargin:15];

        }
            break;
        case 2:
        {

            imageView1.hidden = NO;
            imageView2.hidden = NO;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:picArray[1]] placeholderImage:PLACEHOLDER_IMAGE];
            [self setupAutoHeightWithBottomViewsArray:@[imageView1,imageView2] bottomMargin:15];
            
        }
            break;
        case 3:
        {

            imageView1.hidden = NO;
            imageView2.hidden = NO;
            imageView3.hidden = NO;
            imageView4.hidden = YES;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:picArray[1]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView3 sd_setImageWithURL:[NSURL URLWithString:picArray[2]] placeholderImage:PLACEHOLDER_IMAGE];

            [self setupAutoHeightWithBottomViewsArray:@[imageView3] bottomMargin:15];
            
        }
            break;
        case 4:
        {

            imageView1.hidden = NO;
            imageView2.hidden = NO;
            imageView3.hidden = NO;
            imageView4.hidden = NO;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:picArray[1]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView3 sd_setImageWithURL:[NSURL URLWithString:picArray[2]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView4 sd_setImageWithURL:[NSURL URLWithString:picArray[3]] placeholderImage:PLACEHOLDER_IMAGE];

            [self setupAutoHeightWithBottomViewsArray:@[imageView3] bottomMargin:15];
            
        }
            break;
        default:
            break;
    }
    [self updateLayout];

}
- (void)setUserComplaint2:(UserComplaint *)userComplaint2 {
    _userComplaint2 = userComplaint2;
    _describeLabel.text = userComplaint2.content;
    
    picArray = [[NSMutableArray alloc]init];

    for (UserReservePic *pic in userComplaint2.piclist) {
        [picArray addObject:pic.fileurl];
    }
    /**
     *  图片数组
     */
    switch (picArray.count) {
        case 0:
        {
            imageView1.hidden = YES;
            imageView2.hidden = YES;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            [self setupAutoHeightWithBottomViewsArray:@[_describeLabel] bottomMargin:15];
        }
            break;
        case 1:
        {
            
            imageView1.hidden = NO;
            imageView2.hidden = YES;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [self setupAutoHeightWithBottomViewsArray:@[imageView1] bottomMargin:15];
        }
            break;
        case 2:
        {
            imageView1.hidden = NO;
            imageView2.hidden = NO;
            imageView3.hidden = YES;
            imageView4.hidden = YES;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:picArray[1]] placeholderImage:PLACEHOLDER_IMAGE];
            [self setupAutoHeightWithBottomViewsArray:@[imageView1,imageView2] bottomMargin:15];
        }
            break;
        case 3:
        {
            imageView1.hidden = NO;
            imageView2.hidden = NO;
            imageView3.hidden = NO;
            imageView4.hidden = YES;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:picArray[1]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView3 sd_setImageWithURL:[NSURL URLWithString:picArray[2]] placeholderImage:PLACEHOLDER_IMAGE];
            
            [self setupAutoHeightWithBottomViewsArray:@[imageView3] bottomMargin:15];
        }
            break;
        case 4:
        {
            imageView1.hidden = NO;
            imageView2.hidden = NO;
            imageView3.hidden = NO;
            imageView4.hidden = NO;
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:picArray[0]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:picArray[1]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView3 sd_setImageWithURL:[NSURL URLWithString:picArray[2]] placeholderImage:PLACEHOLDER_IMAGE];
            [imageView4 sd_setImageWithURL:[NSURL URLWithString:picArray[3]] placeholderImage:PLACEHOLDER_IMAGE];
            
            [self setupAutoHeightWithBottomViewsArray:@[imageView3] bottomMargin:15];
            
        }
            break;
        default:
            break;
    }
    [self updateLayout];
    
}


@end
