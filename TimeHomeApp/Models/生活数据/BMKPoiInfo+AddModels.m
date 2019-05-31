//
//  BMKPoiInfo+AddModels.m
//  YouLifeApp
//
//  Created by us on 15/10/29.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BMKPoiInfo+AddModels.h"

@implementation BMKPoiInfo (AddModels)

@dynamic addr_disStr;
@dynamic cell_H;


SYNTHESIZE_CATEGORY_OBJ_PROPERTY(addr_disStr, setAddr_disStr:)
SYNTHESIZE_CATEGORY_VALUE_PROPERTY(CGFloat, cell_H, setCell_H:)
//计算
-(void)calculateCell_H{
    
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[self addr_disStr] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr = [[NSAttributedString alloc] initWithData:[[attrStr string] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    CGRect  tv_frame = [[attrStr string]  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100*WDPI,20000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.cell_H = tv_frame.size.height;
    
}

@end
