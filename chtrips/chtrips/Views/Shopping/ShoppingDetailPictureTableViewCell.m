//
//  ShoppingDetailPictureTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/4/22.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDetailPictureTableViewCell.h"


#define CONTENT_VIEW_WIDTH self.contentView.frame.size.width

@implementation ShoppingDetailPictureTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
//        [self setupImgScrollView];
    }
    
    return self;
}

- (void) setupImgScrollView {
    self.imgScrollView = [UIScrollView newAutoLayoutView];
    [self.contentView addSubview:_imgScrollView];
    
//    self.imgArr = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    
    [_imgScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
    [_imgScrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
    [_imgScrollView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
    [_imgScrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
    _imgScrollView.contentSize = CGSizeMake(CONTENT_VIEW_WIDTH * self.imgArr.count, _imgScrollView.frame.size.height);
    _imgScrollView.delegate = self;
    _imgScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置分页
    _imgScrollView.pagingEnabled = YES;
    
    for (int i = 0; i < [self.imgArr count]; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(CONTENT_VIEW_WIDTH * i + (CONTENT_VIEW_WIDTH - 200) / 2, 0, 200, 200);
        NSURL *imageUrl = [NSURL URLWithString:[self.imgArr objectAtIndex:i]];
        [imgView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"productDemo3"]];
        
        [_imgScrollView addSubview:imgView];
    }
    
    self.pageControl = [[UIPageControl alloc] init];
    
    _pageControl.center = CGPointMake(CONTENT_VIEW_WIDTH / 2, 180);
    _pageControl.bounds = CGRectMake(0, 0, 16*(self.imgArr.count-1)+16, 16);
    _pageControl.numberOfPages = self.imgArr.count;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.enabled = NO;
    
    [self.contentView addSubview:_pageControl];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
