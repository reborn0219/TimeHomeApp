//
//  CarListModel.m
//  YouLifeApp
//
//  Created by us on 15/10/23.
//  Copyright © 2015年 us. All rights reserved.
//

#import "CarListModel.h"

@implementation CarListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID":@"id"
             };
}


//计算
-(void)calculateCell_H{
    
    if(self.addr==nil)
    {
        self.cell_H=30;
        return;
    }
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[self addr] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr = [[NSAttributedString alloc] initWithData:[[attrStr string] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    CGRect  tv_frame = [[attrStr string]  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40,20000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.cell_H = tv_frame.size.height+30;
    
}
@end
