//
//  MyInfoNormalTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/11/3.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoNormalTableViewCell.h"

@implementation MyInfoNormalTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.textLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_textLB];
        
        [_textLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_textLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10];
        [_textLB autoSetDimensionsToSize:CGSizeMake(100, 30)];
        _textLB.font = [UIFont systemFontOfSize:16.0];
        _textLB.textColor = HIGHLIGHT_BLACK_COLOR;
        _textLB.textAlignment = NSTextAlignmentLeft;
        _textLB.backgroundColor = [UIColor clearColor];
        
        self.valLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_valLB];
        
        [_valLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_valLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_textLB withOffset:ScreenWidth * 0.05 + 10];
        [_valLB autoSetDimensionsToSize:CGSizeMake(150, 30)];
        _valLB.font = [UIFont systemFontOfSize:16.0];
        _valLB.textColor = GRAY_FONT_COLOR;
        _valLB.textAlignment = NSTextAlignmentRight;
        _valLB.backgroundColor = [UIColor clearColor];
        
        self.cutLineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_cutLineLB];
        
        [_cutLineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5];
        [_cutLineLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        [_cutLineLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 5, 0.5)];
        _cutLineLB.backgroundColor = GRAY_COLOR_CELL_LINE;
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
