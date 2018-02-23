//
//  CirclesImageCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/16.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "CirclesImageCell.h"
#define img_ScreenW (SCREEN_WIDTH-30)

@interface CirclesImageCell ()
{
CGFloat cellImageHeight;
}
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)NSMutableArray* imgArr;
@end

@implementation CirclesImageCell

-(void)addContentViews{
    _baseImage = [[UIImageView alloc]init];
    _baseImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_baseImage];
    [_baseImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(9);
        make.bottom.mas_equalTo(self.contentView);
    }];
    

    for (int i=0; i<9; i++) {
        UIImageView* img = [[UIImageView alloc]init];
         img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.tag = 100+i;
        [_baseImage addSubview:img];

    }
    _imgArr = [[NSMutableArray alloc]init];
}

-(CGFloat)setCirclesImagesCellDicValue:(NSDictionary *)dic{
    
    for (UIImageView* view in _baseImage.subviews) {
        view.hidden = YES;
    }
    [_imgArr removeAllObjects];
    CGFloat height = 0;
    cellImageHeight = 1;
    

    id arr = dic[@"photoscbk"];
    if ([arr isKindOfClass:[NSArray class]]){
        NSArray* imgArr = dic[@"photoscbk"];
        [_imgArr addObjectsFromArray:imgArr];
        if (imgArr.count>0){
            height+=9;
            NSInteger j = (imgArr.count-1);

            switch (j) {
                case 0:
                {
                    UIImageView* img = [_baseImage viewWithTag:100+j];
                    img.hidden = NO;
                    
                    [img mas_remakeConstraints:^(MASConstraintMaker* make) {
                        make.left.equalTo(_baseImage);
                        make.top.equalTo(_baseImage);
                        CGFloat widthF = [imgArr[j][@"cbk"] floatValue];
                        if (widthF<1) {
                        [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",imgArr[0][@"photo"]] tempTmage:@"icon_Default_Product"];
                            make.width.mas_equalTo((img_ScreenW - cellImageHeight) / 3*2*widthF);
                            make.height.mas_equalTo((img_ScreenW - cellImageHeight) / 3*2);
                        }else{
                            [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",imgArr[0][@"photo"]] tempTmage:@"icon_Default_Product"];
                            make.width.mas_equalTo(img_ScreenW);
                            make.height.mas_equalTo(img_ScreenW*2/3);
                        }
                        
                    }];
                    height+=img_ScreenW*2/3;
                }
                    break;
                case 1:
                    
                {

                    UIImageView* img = [_baseImage viewWithTag:100];
                    img.hidden = NO;
                    [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[0][@"photo"]] tempTmage:@"icon_Default_Product"];
                    [img mas_remakeConstraints:^(MASConstraintMaker* make) {
                        make.left.equalTo(_baseImage);
                        make.top.equalTo(_baseImage);
                        make.width.mas_equalTo((img_ScreenW - cellImageHeight) / 2);
                        make.height.mas_equalTo((img_ScreenW - cellImageHeight) / 2);
                        
                    }];
                    
                    UIImageView* img2 = [_baseImage viewWithTag:101];
                    img2.hidden = NO;
                    [img2 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[1][@"photo"]] tempTmage:@"icon_Default_Product"];
                    [img2 mas_remakeConstraints:^(MASConstraintMaker* make) {
                        make.left.equalTo(img.mas_right).offset(cellImageHeight);
                        make.top.equalTo(_baseImage);
                        
                        make.width.mas_equalTo((img_ScreenW - cellImageHeight) / 2);
                        make.height.mas_equalTo((img_ScreenW - cellImageHeight) / 2);

                    }];
                    height+=(img_ScreenW - cellImageHeight) / 2;

                }
                    break;
                    case 2:
                {
                    UIImageView* imgLast = nil;
                    
                    UIImageView* img = [_baseImage viewWithTag:100];
                    img.hidden = NO;
                    
                    [img mas_remakeConstraints:^(MASConstraintMaker* make) {
                        make.left.equalTo(_baseImage);
                        make.top.equalTo(_baseImage);
                        [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[0][@"photo"]] tempTmage:@"icon_Default_Product"];
                        make.width.mas_equalTo((img_ScreenW - cellImageHeight) / 3);
                        make.height.mas_equalTo((img_ScreenW - cellImageHeight) / 3*2);
                        
                    }];
                    
                    UIImageView* img2 = [_baseImage viewWithTag:101];
                    img2.hidden = NO;
                    [img2 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[1][@"photo"]] tempTmage:@"icon_Default_Product"];
                    [img2 mas_remakeConstraints:^(MASConstraintMaker* make) {
                        make.left.equalTo(img.mas_right).offset(cellImageHeight);
                        make.top.equalTo(_baseImage);
                        
                        make.width.mas_equalTo((img_ScreenW - cellImageHeight) / 3*2);
                        make.height.mas_equalTo((img_ScreenW - cellImageHeight) / 3);
                        
                    }];
                    
                    UIImageView* img3 = [_baseImage viewWithTag:102];
                    img3.hidden = NO;
                    [img3 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[2][@"photo"]] tempTmage:@"icon_Default_Product"];
                    [img3 mas_remakeConstraints:^(MASConstraintMaker* make) {
                        make.left.equalTo(img.mas_right).offset(cellImageHeight);
                        make.top.equalTo(img2.mas_bottom).offset(cellImageHeight);
                        
                        make.width.mas_equalTo((img_ScreenW - cellImageHeight) / 3*2);
                        make.height.mas_equalTo((img_ScreenW - cellImageHeight) / 3);
                        
                    }];
                    imgLast = img3;

                    height+=img_ScreenW*2/3;

                }
                    break;
                case 3:
                {
                    
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                case 5:
                {
                     UIImageView* imgLast = nil;
                    for (int i=0; i<_imgArr.count; i++){
                        UIImageView* img1 = [_baseImage viewWithTag:100+i];
                        img1.hidden = NO;
                        [img1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[i][@"photo"]] tempTmage:@"icon_Default_Product"];
                        [img1 mas_remakeConstraints:^(MASConstraintMaker* make) {
                            make.left.equalTo(_baseImage).offset(i % 3 * ((img_ScreenW - cellImageHeight * 2) / 3 + cellImageHeight));
                            make.top.equalTo(_baseImage).offset(i / 3 * ((img_ScreenW - cellImageHeight * 2) / 3 + cellImageHeight));
                            make.width.mas_equalTo((img_ScreenW - cellImageHeight * 2) / 3);
                            make.height.mas_equalTo((img_ScreenW - cellImageHeight * 2) / 3);
                        }];
                        imgLast = img1;
                    }
                    height+=((img_ScreenW - cellImageHeight * 2) / 3 + cellImageHeight);
                }
                    break;
                case 6:
                {
                    
                }
                    break;
                case 7:
                {
                    UIImageView* imgLast = nil;
                    for (int i=0; i<imgArr.count; i++){
                        UIImageView* img1 = [_baseImage viewWithTag:100+i];
                        img1.hidden = NO;
                        if (i==imgArr.count-1) {
                            [img1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!2b1",imgArr[i][@"photo"]] tempTmage:@"icon_Default_Product"];
                            CGFloat imgWidthFloat = ((img_ScreenW - cellImageHeight * 2) / 3 );
                            
                            [img1 mas_remakeConstraints:^(MASConstraintMaker* make) {
                                make.left.equalTo(_baseImage).offset(i % 3 * (imgWidthFloat + cellImageHeight));
                                make.top.equalTo(_baseImage).offset(i / 3 * (imgWidthFloat + cellImageHeight));
                                make.width.mas_equalTo(imgWidthFloat*2);
                                make.height.mas_equalTo(imgWidthFloat);
                            }];
                            imgLast = img1;
 
                        }else{
                        [img1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[i][@"photo"]] tempTmage:@"icon_Default_Product"];
                        CGFloat imgWidthFloat = ((img_ScreenW - cellImageHeight * 2) / 3 );
                        
                        [img1 mas_remakeConstraints:^(MASConstraintMaker* make) {
                            make.left.equalTo(_baseImage).offset(i % 3 * (imgWidthFloat + cellImageHeight));
                            make.top.equalTo(_baseImage).offset(i / 3 * (imgWidthFloat + cellImageHeight));
                            make.width.mas_equalTo(imgWidthFloat);
                            make.height.mas_equalTo(imgWidthFloat);
                        }];
                        imgLast = img1;
                        }
                    }
                    height+=3*((img_ScreenW - cellImageHeight * 2) / 3) + cellImageHeight*2;
                }
                    break;
                case 8:
                {
                    UIImageView* imgLast = nil;
                    for (int i=0; i<imgArr.count; i++){
                        UIImageView* img1 = [_baseImage viewWithTag:100+i];
                        img1.hidden = NO;
            [img1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[i][@"photo"]] tempTmage:@"icon_Default_Product"];
                        CGFloat imgWidthFloat = ((img_ScreenW - cellImageHeight * 2) / 3 );
                        
                        [img1 mas_remakeConstraints:^(MASConstraintMaker* make) {
                            make.left.equalTo(_baseImage).offset(i % 3 * (imgWidthFloat + cellImageHeight));
                            make.top.equalTo(_baseImage).offset(i / 3 * (imgWidthFloat + cellImageHeight));
                            make.width.mas_equalTo(imgWidthFloat);
                            make.height.mas_equalTo(imgWidthFloat);
                        }];
                        imgLast = img1;
                    }
                    height+=3*((img_ScreenW - cellImageHeight * 2) / 3) + cellImageHeight*2;
                }
                    break;
                    
                    
                default:
                    break;
            }
          
           }
        }
   
    return  height;
}
@end
