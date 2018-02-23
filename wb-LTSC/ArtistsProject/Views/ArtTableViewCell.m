//
//  ArtTableViewCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@implementation ArtTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame{
    if (self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.frame = frame;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addContentViews];
    }
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addContentViews];
    }
    return self;
}
-(void)addContentViews{
    
}
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{

}
-(void)setArtTableViewCellArrValue:(NSArray *)arr{

}
@end
