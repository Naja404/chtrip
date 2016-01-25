//
//  MyCheckOutTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/1/11.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyCheckOutTableViewCell.h"


@implementation MyCheckOutTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:@"myAddressCell"]) {
            self.titleLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_titleLB];
            
            [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
            [_titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView withOffset:20];
            [_titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 40, 30)];
            
            self.shippingLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_shippingLB];
            
            [_shippingLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLB];
            [_shippingLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLB];
            [_shippingLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 40, 50)];
            _shippingLB.numberOfLines = 0;
            _shippingLB.textColor = GRAY_FONT_COLOR;
            
        }else if ([reuseIdentifier isEqualToString:@"myShippingCell"]) {
            self.titleLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_titleLB];
            
            [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
            [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
            [_titleLB autoSetDimensionsToSize:CGSizeMake(100, 40)];
            
            self.priceLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_priceLB];
            
            [_priceLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_titleLB];
            [_priceLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_titleLB];
            [_priceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_titleLB];
            [_priceLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-20];
            _priceLB.textAlignment = NSTextAlignmentRight;
            
            self.shippingLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_shippingLB];
            
            [_shippingLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLB];
            [_shippingLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
            [_shippingLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLB];
            [_shippingLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
            _shippingLB.font = FONT_SIZE_14;
            _shippingLB.textColor = GRAY_FONT_COLOR;
            
        }else if ([reuseIdentifier isEqualToString:@"myShippingSelectCell"]){
            self.selectImg = [UIImageView newAutoLayoutView];
            [self.contentView addSubview:_selectImg];
            
            [_selectImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
            [_selectImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
            [_selectImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
            _selectImg.image = [UIImage imageNamed:@"checkboxUncheck"];
            
            self.titleLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_titleLB];
            
            [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
            [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_selectImg withOffset:10];
            [_titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 100, 30)];
            
            self.priceLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_priceLB];
            
            [_priceLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
            [_priceLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-20];
            [_priceLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 100, 30)];
            _priceLB.textAlignment = NSTextAlignmentRight;
            
            self.shippingLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_shippingLB];
            
            [_shippingLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLB];
            [_shippingLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLB];
            [_shippingLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 100, 30)];
            _shippingLB.textColor = GRAY_FONT_COLOR;
            _shippingLB.font = FONT_SIZE_14;
        }else if ([reuseIdentifier isEqualToString:@"myPaymentCell"]){
            
            NSArray *tmpArr = @[@"logoWeChat", @"logoAlipay"];
            NSArray *tmpTitle = @[@"微信支付", @"支付宝"];
            
            _controlArr = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < 2; i++) {
                UIControl *bgView = [[UIControl alloc] initWithFrame:CGRectMake(ScreenWidth / 2 * i, 0, ScreenWidth / 2, 80)];
                bgView.tag = i + 1;
                
                UIImageView *logoImg = [UIImageView newAutoLayoutView];
                [bgView addSubview:logoImg];
                
                [logoImg autoAlignAxis:ALAxisVertical toSameAxisOfView:bgView];
                [logoImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:bgView];
                [logoImg autoSetDimensionsToSize:CGSizeMake(35, 35)];
                logoImg.image = [UIImage imageNamed:[tmpArr objectAtIndex:i]];
                
                if (i == 0) {
                    bgView.backgroundColor = RED_COLOR_BG;
                }else{
                    bgView.backgroundColor = [UIColor whiteColor];
                }
                
                UILabel *titleLB = [UILabel newAutoLayoutView];
                [bgView addSubview:titleLB];
                
                [titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:logoImg];
                [titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:bgView];
                [titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 2 - 20, 20)];
                titleLB.text = [tmpTitle objectAtIndex:i];
                titleLB.textAlignment = NSTextAlignmentCenter;
                
                [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchUpInside];
                
                [_controlArr addObject:bgView];
                
                [self.contentView addSubview:bgView];
            }
            
        }else if ([reuseIdentifier isEqualToString:@"myUserNeedCell"]){
            self.titleLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_titleLB];
            
            [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
            [_titleLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
            [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
            [_titleLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
            _titleLB.numberOfLines = 0;
            _titleLB.font = FONT_SIZE_14;
            
        }else{
            self.titleLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_titleLB];
            
            [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
            [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
            [_titleLB autoSetDimensionsToSize:CGSizeMake(150, 30)];
            
            self.priceLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_priceLB];
            
            [_priceLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
            [_priceLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
            [_priceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_titleLB];
            [_priceLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-20];
            _priceLB.textAlignment = NSTextAlignmentRight;
        }
    }
    
    return self;
}

- (void) tapBgView:(UIControl *) control {
    [_controlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj tag] == control.tag) {
            [obj setBackgroundColor:RED_COLOR_BG];
        }else{
            [obj setBackgroundColor:[UIColor whiteColor]];
        }
    }];
    _tapPayAction(control.tag);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
