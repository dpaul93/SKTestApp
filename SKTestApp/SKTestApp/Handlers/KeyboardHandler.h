//
//  KeyboardHandler.h
//
//  Created by Paul Deynega on 4/5/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardHandlerDelegate;

@interface KeyboardHandler : NSObject

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UIView *sender;
@property (assign, nonatomic) CGPoint centerPosition;
@property (assign, nonatomic) NSInteger offset;
@property (assign, nonatomic) id<KeyboardHandlerDelegate> delegate;

-(instancetype)initWithScrollView:(UIScrollView *)scrollView;

-(void)addTapGestureRecognizer;
-(void)removeTapGestureRecognizer;

@end

@protocol KeyboardHandlerDelegate <NSObject>

@optional
-(BOOL)keyboardHandler:(KeyboardHandler*)keyboardHandler shouldLiftViewByHeight:(CGFloat)keyboardHeight;
-(CGFloat)keyboardHanlderShouldLiftViewByHeight:(KeyboardHandler*)keyboardHandler;

@end