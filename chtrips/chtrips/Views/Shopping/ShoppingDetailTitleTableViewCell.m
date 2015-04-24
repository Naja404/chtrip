//
//  ShoppingDetailTitleTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/4/22.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDetailTitleTableViewCell.h"
#define CONTENT_VIEW_WIDTH self.contentView.frame.size.width

@implementation ShoppingDetailTitleTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupLabelStyle];
    }
    
    return self;
}

- (void) setupLabelStyle {
    self.titleZHLB = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleZHLB.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
//    _titleZHLB.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_titleZHLB];
    
    self.titleJPLB = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleJPLB.font = [UIFont fontWithName:@"ArialMT" size:18];
    _titleJPLB.textColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
//    _titleJPLB.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_titleJPLB];
    
    self.summaryLB = [[UILabel alloc] initWithFrame:CGRectZero];
    _summaryLB.font = [UIFont fontWithName:@"Georgia-Italic" size:20];
    _summaryLB.textColor = [UIColor redColor];
//    _summaryLB.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_summaryLB];
}


- (void) setupLabelStyleBAK {
    self.titleZHLB = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_titleZHLB];
    
    [_titleZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
    [_titleZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
    [_titleZHLB autoSetDimensionsToSize:CGSizeMake(CONTENT_VIEW_WIDTH, 30)];
    _titleZHLB.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
//    _titleZHLB.backgroundColor = [UIColor grayColor];
    
    self.titleJPLB = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_titleJPLB];
    
    [_titleJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleZHLB withOffset:2.0];
    [_titleJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
    [_titleJPLB autoSetDimensionsToSize:CGSizeMake(CONTENT_VIEW_WIDTH, 30)];
    _titleJPLB.font = [UIFont fontWithName:@"ArialMT" size:18];
    _titleJPLB.textColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
//    _titleJPLB.backgroundColor = [UIColor grayColor];
    
    self.summaryLB = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_summaryLB];
    
    [_summaryLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:2.0];
    [_summaryLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
    [_summaryLB autoSetDimensionsToSize:CGSizeMake(CONTENT_VIEW_WIDTH, 40)];
    _summaryLB.font = [UIFont fontWithName:@"Georgia-Italic" size:20];
    _summaryLB.textColor = [UIColor redColor];
//    _summaryLB.backgroundColor = [UIColor blackColor];
}

- (CGFloat) setTextWithHeight:(NSString *)titleZH titleJP:(NSString *)titleJP summary:(NSString *)summary {
    
    CGRect contentFrame = [self.contentView frame];
    
    float titleZHLBHeight = [self setupTitleZHText:titleZH];
    
    float titleJPLBHeight = [self setupTitleJPText:titleJP ofViewY:titleZHLBHeight];
    
    float summaryHeight = [self setupSummaryLBText:summary ofViewY:(titleZHLBHeight + titleJPLBHeight)];
    
    contentFrame.size.height = titleZHLBHeight + titleJPLBHeight + summaryHeight;
    
    self.contentView.frame = contentFrame;
    
    return contentFrame.size.height;
}

- (float) setupTitleZHText:(NSString *) text {
    self.titleZHLB.text = text;
    self.titleZHLB.numberOfLines = 0;
    self.titleZHLB.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize titleZHLBSize = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(CONTENT_VIEW_WIDTH, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];

    self.titleZHLB.frame = CGRectMake(0, 0, CONTENT_VIEW_WIDTH, titleZHLBSize.height);
    
    return titleZHLBSize.height;
}

- (float) setupTitleJPText:(NSString *) text ofViewY:(float)ofViewY {
    self.titleJPLB.text = text;
    self.titleJPLB.numberOfLines = 0;
    self.titleJPLB.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize titleJPLBSize = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(CONTENT_VIEW_WIDTH, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    self.titleJPLB.frame = CGRectMake(0, ofViewY, CONTENT_VIEW_WIDTH, titleJPLBSize.height);
    
    return titleJPLBSize.height;
}

- (float) setupSummaryLBText:(NSString *) text ofViewY:(float)ofViewY{
    self.summaryLB.text = text;
    self.summaryLB.numberOfLines = 0;
    self.summaryLB.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize summaryLBSize = [text sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(CONTENT_VIEW_WIDTH, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    self.summaryLB.frame = CGRectMake(0, ofViewY, CONTENT_VIEW_WIDTH, summaryLBSize.height);
    
    return summaryLBSize.height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
