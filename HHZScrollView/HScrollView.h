//
//  HScrollView.h
//  HHZScrollView
//
//  Created by 黄含章 on 15/7/27.
//  Copyright (c) 2015年 HHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HScrollViewClickedDelegate <NSObject>

@optional

-(void)HScrollViewClickedAtPic:(NSUInteger)picIndex;

@end

@interface HScrollView : UIScrollView

-(instancetype)initWithFrame:(CGRect)frame WithPictures:(NSArray *)pictureArray;

@property (nonatomic,strong) UIPageControl *pageControl;

@property(nonatomic,weak)id<HScrollViewClickedDelegate> Hdelegate;

@end
