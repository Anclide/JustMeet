//
//  ZRFlatButton.h
//  zarabotai-rekomenduya
//
//  Created by Артур Сагидулин on 24.05.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, FlatButtonType) {
    FlatButtonFilled = 0,
    FlatButtonTransparent = 1,
    FlatButtonTransparentNoBorder = 2,
};

IB_DESIGNABLE
@interface ZRFlatButton : UIButton{
    CAShapeLayer *aMaterialLayer;
}
- (id)initCustom;

-(void)showActivityIndicator;
-(void)hideActivityIndicator;

@property(nonatomic,strong) IBInspectable UIColor *overlayColor;
@property(nonatomic) IBInspectable NSInteger fbuttonType;

@end
