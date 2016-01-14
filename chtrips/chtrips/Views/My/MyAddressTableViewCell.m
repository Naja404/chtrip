//
//  MyAddressTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/1/5.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyAddressTableViewCell.h"

@implementation MyAddressTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.nameLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_nameLB];
        
        [_nameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10];
        [_nameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
        [_nameLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 2 - 20, 20)];
        _nameLB.font = FONT_SIZE_16;
        _nameLB.textColor = BLACK_FONT_COLOR;
        
        self.mobileLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_mobileLB];
        
        [_mobileLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_nameLB];
        [_mobileLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_nameLB];
        [_mobileLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 2 - 20, 20)];
        _mobileLB.textAlignment = NSTextAlignmentRight;
        _mobileLB.font = FONT_SIZE_16;
        _mobileLB.textColor = BLACK_FONT_COLOR;
        
        self.addressLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_addressLB];
        
        [_addressLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLB];
        [_addressLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_nameLB];
        [_addressLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 40, 20)];
        _addressLB.font = FONT_SIZE_14;
        _addressLB.textColor = GRAY_FONT_COLOR;
        
        self.lineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_lineLB];
        
        [_lineLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentView withOffset:-1];
        [_lineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_lineLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 1)];
        _lineLB.backgroundColor = GRAY_FONT_COLOR;
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
