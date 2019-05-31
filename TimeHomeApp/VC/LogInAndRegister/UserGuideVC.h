//
//  UserGuideVC.h
//  YouLifeApp
//
//  Created by us on 15/9/6.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BaseViewController.h"

@interface UserGuideVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *sv_Guides;//引导页滚动视图
@property (weak, nonatomic) IBOutlet UIPageControl *pc_PageControls;//引导页指示器

@end
