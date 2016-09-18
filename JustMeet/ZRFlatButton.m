//
//  ZRFlatButton.m
//  zarabotai-rekomenduya
//
//  Created by Артур Сагидулин on 24.05.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "ZRFlatButton.h"
#import <DGActivityIndicatorView.h>

@interface ZRFlatButton()
@property (nonatomic, assign) FlatButtonType flatBtype;
@property (nonatomic, weak) DGActivityIndicatorView *activityIndicatorView;
@end

@implementation ZRFlatButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initCustom{
    if (self = [super init]) {
        [self setClipsToBounds:YES];
        [self setupApperance];
        
    }
    return self;
}


- (void)awakeFromNib {
    [self setClipsToBounds:YES];
    [self setupApperance];
    
}

-(void)setupApperance{
    
    UIColor *lightBlue = [UIColor colorWithRed:0 green:131./255. blue:237./255. alpha:1];
    UIColor *backgroundColor;
    UIColor *overlayColor;
    if (_flatBtype==FlatButtonFilled) {
        backgroundColor = lightBlue;
        overlayColor = [UIColor whiteColor];
        [self setTitleColor:overlayColor forState:UIControlStateNormal];
        self.layer.borderWidth = 0;
    } else if (_flatBtype == FlatButtonBackgroundWhite ) {
        backgroundColor = [UIColor whiteColor];
        
    } else {
        backgroundColor = [UIColor clearColor];
        overlayColor = lightBlue;
        [self setTitleColor:overlayColor forState:UIControlStateNormal];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        if (_flatBtype==FlatButtonTransparent){
            self.layer.borderColor = [lightBlue CGColor];
        }
    }
    self.backgroundColor = backgroundColor;
    [self setOverlayColor:overlayColor];
    
    self.layer.cornerRadius = self.frame.size.height/2;
    [self setClipsToBounds:YES];
}

-(void)setOverlayColor:(UIColor *)overlayColor{
    _overlayColor = overlayColor;
    self.tintColor = overlayColor;
}

-(void)setFbuttonType:(NSInteger)fbuttonType {
    self.flatBtype = (FlatButtonType)fbuttonType;
    [self setupApperance];
}

-(void)showActivityIndicator{
    [self setEnabled:NO];
//    [self setUserInteractionEnabled:NO];
    self.titleLabel.layer.opacity = 0.0f;

    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor whiteColor] size:self.bounds.size.height];
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _activityIndicatorView = activityIndicatorView;
    [self addSubview:_activityIndicatorView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:100]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-100]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
//                                                             attribute:NSLayoutAttributeCenterX
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self
//                                                             attribute:NSLayoutAttributeCenterX
//                                                            multiplier:1
//                                                              constant:0]];
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    
    [activityIndicatorView startAnimating];
}

-(void)hideActivityIndicator{
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    _activityIndicatorView = nil;
    self.titleLabel.layer.opacity = 1.0f;
    [self setEnabled:YES];
}


#define initialSize 20

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = [anim valueForKey:@"animationLayer"];
    if (layer) {
        [layer removeAnimationForKey:@"scale"];
        [layer removeFromSuperlayer];
        layer = nil;
        anim = nil;
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    UITouch *aTouch = touch;
    
    CGPoint aPntTapLocation = [aTouch locationInView:self];
    
    CALayer *aLayer = [CALayer layer];
    aLayer.backgroundColor = self.tintColor
    ? self.tintColor.CGColor
    : [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    aLayer.frame = CGRectMake(0, 0, initialSize, initialSize);
    aLayer.cornerRadius = initialSize / 2;
    aLayer.masksToBounds = YES;
    aLayer.position = aPntTapLocation;
    [self.layer insertSublayer:aLayer below:self.titleLabel.layer];
    
    // Create a basic animation changing the transform.scale value
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // Set the initial and the final values
    [animation
     setToValue:[NSNumber numberWithFloat:(2.5 * MAX(self.frame.size.height,
                                                     self.frame.size.width)) /
                 initialSize]];
    // Set duration
    [animation setDuration:0.6f];
    
    // Set animation to be consistent on completion
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    // Add animation to the view's layer
    
    CAKeyframeAnimation *fade =
    [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fade.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],
                   [NSNumber numberWithFloat:1.0],
                   [NSNumber numberWithFloat:1.0],
                   [NSNumber numberWithFloat:0.5],
                   [NSNumber numberWithFloat:0.0], nil];
    fade.duration = 0.5;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 0.5f;
    animGroup.delegate = self;
    animGroup.animations = [NSArray arrayWithObjects:animation, fade, nil];
    [animGroup setValue:aLayer forKey:@"animationLayer"];
    [aLayer addAnimation:animGroup forKey:@"scale"];
    
    return YES;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end
