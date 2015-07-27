//
//  HScrollView.m
//  HHZScrollView
//
//  Created by 黄含章 on 15/7/27.
//  Copyright (c) 2015年 HHZ. All rights reserved.
//

#import "HScrollView.h"
#import "UIView+Extension.h"

@interface HScrollView()

@property(nonatomic,assign) int picture;

@property(nonatomic,assign) int page;

@property(nonatomic,strong) UISwipeGestureRecognizer *leftSwipeGestureRecpgnizer;

@property(nonatomic,strong) UISwipeGestureRecognizer *rightSwipeGestureRecpgnizer;

@property(nonatomic,strong)NSTimer *timer;

@property(nonnull,strong)NSArray *pictureArray;
@end

@implementation HScrollView

-(instancetype)initWithFrame:(CGRect)frame WithPictures:(NSArray *)pictureArray {
    if (self = [super initWithFrame:frame]) {
        
        //初始化数据
        self.picture = 1;
        self.page = 0;
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
        self.pictureArray = pictureArray;
        
        //设置图片数组，如果是网络图片请自行添加加载图片库改为url数组
        [self setImageWithPicArray:pictureArray];
        
        //添加定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(automatic) userInfo:nil repeats:YES];
        [_timer fire];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        
        //添加两个手势
        [self setSwipGesture];
        
        //添加pageControl
        [self setupPageControl];
        
        //消除BUG
        [self handleSwipes:_rightSwipeGestureRecpgnizer];
    }
    return self;
}

-(void)automatic {
    [self handleSwipes:_leftSwipeGestureRecpgnizer];
}

-(void)dealloc {
    [_timer invalidate];
}

//添加两个手势
-(void)setSwipGesture
{
    self.leftSwipeGestureRecpgnizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecpgnizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecpgnizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecpgnizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:self.leftSwipeGestureRecpgnizer];
    [self addGestureRecognizer:self.rightSwipeGestureRecpgnizer];
}

//设置图片数组，如果是网络图片请自行添加加载图片库改为url数组
-(void)setImageWithPicArray:(NSArray *)pictureArray {
    for (int i = 0; i < 3; i++) {
        NSString *str = [NSString  stringWithFormat:@"%d.jpg",i];
        UIImage *image1 = [UIImage imageNamed:str];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image1];
        imageView.frame = CGRectMake(self.frame.size.width * (i - 1), 0, self.frame.size.width, self.frame.size.height);
        imageView.tag = i;
        [self addSubview:imageView];
    }
}

//添加pageControl
-(void)setupPageControl
{
    //1.添加
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = 5;
    _pageControl.centerX = self.frame.size.width / 2;
    _pageControl.centerY = self.frame.size.height - 60;
    
    //设置圆点的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.pageIndicatorTintColor = [UIColor cyanColor];
    
}

#pragma mark - 添加手势的action

-(void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.page++;
        self.picture++;
        if (self.picture > 4) {
            self.picture = 0;
        }
        if (self.page > 2) {
            self.page = 0;
        }
        self.pageControl.currentPage = self.picture;
        NSString *picStr = [NSString  stringWithFormat:@"%d.jpg",self.picture];
        UIImageView *view = self.subviews[self.page];
        view.userInteractionEnabled = YES;
        view.image = [UIImage imageNamed:picStr];
        view.frame = CGRectMake(self.contentOffset.x + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self insertSubview:view atIndex:self.page];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        btn.tag = self.picture;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];

        [self setContentOffset:CGPointMake(self.contentOffset.x + self.frame.size.width, 0) animated:YES];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        self.page--;
        self.picture--;
        if (self.picture < 0) {
            self.picture = 4;
        }
        if (self.page < 0) {
            self.page = 2;
        }
        self.pageControl.currentPage = self.picture;
        NSString *picStr = [NSString  stringWithFormat:@"%d.jpg",self.picture];
        UIImageView *view = self.subviews[self.page];
        view.userInteractionEnabled = YES;
        view.image = [UIImage imageNamed:picStr];
        view.frame = CGRectMake(self.contentOffset.x - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self insertSubview:view atIndex:self.page];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        btn.tag = self.picture;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [self setContentOffset:CGPointMake(self.contentOffset.x - self.frame.size.width, 0) animated:YES];
    }
}

-(void)btnClicked:(UIButton *)button {
    if (_Hdelegate && [_Hdelegate respondsToSelector:@selector(HScrollViewClickedAtPic:)]) {
        [_Hdelegate HScrollViewClickedAtPic:button.tag];
    }
}
@end
