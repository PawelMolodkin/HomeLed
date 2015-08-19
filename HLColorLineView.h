//
//  HLColorLineView.h
//  HomeLed
//
//  Created by Pavel Molodkin on 14.08.15.
//  Copyright © 2015 Voevoda's Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLColorLineView : UIView

- (id)initWithColor:(UIColor *)color didChangeColorBlock:(void (^)(UIColor *color, BOOL finished))didChangeColorBlock;

@end
