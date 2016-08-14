//
//  KeyboardHandler.m
//
//  Created by Paul Deynega on 4/5/16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "KeyboardHandler.h"

@interface KeyboardHandler()

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, assign) BOOL keyboardUp;
@property (nonatomic, assign) CGFloat bottomScrollViewInset;
@property (nonatomic, assign) CGFloat topScrollViewInsets;

@end

@implementation KeyboardHandler

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        [self registerForKeyboardNotifications];
        
        _scrollView = scrollView;
        self.bottomScrollViewInset = self.scrollView.contentInset.bottom;
        self.topScrollViewInsets = self.scrollView.contentInset.top;
        
        self.offset = 0;
    }
    return self;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    if (self.scrollView) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.topScrollViewInsets, 0.0f, self.bottomScrollViewInset, 0.0f)];
        
        [self.scrollView setContentOffset:CGPointMake(0, -self.topScrollViewInsets) animated:YES];
        self.keyboardUp = NO;
    }
}

- (void)keyboardWillBeShown:(NSNotification *)notification {
    // This one is called every time in iOS 9 (maybe higher also) when text field is tapped and is called once in iOS 8.4
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(self.topScrollViewInsets, 0.0f, keyboardEndFrame.size.height, 0.0f)];
    
    self.keyboardUp = YES;
    
    [self liftView];
    
    CGPoint offset = CGPointZero;
    if([self.delegate respondsToSelector:@selector(keyboardHandler:shouldLiftViewByHeight:)]) {
        if([self.delegate keyboardHandler:self shouldLiftViewByHeight:CGRectGetHeight(keyboardEndFrame)]) {
            offset = CGPointMake(0.0f, CGRectGetHeight(keyboardEndFrame));
        }
    }
    
    if([self.delegate respondsToSelector:@selector(keyboardHanlderShouldLiftViewByHeight:)]) {
        CGFloat height = [self.delegate keyboardHanlderShouldLiftViewByHeight:self];
        offset.y = height;
    }
    
    if(!CGPointEqualToPoint(offset, self.scrollView.contentOffset) && !CGPointEqualToPoint(CGPointZero, offset)) {
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

-(void)dealloc {
    NSLog(@"%@ deallocated", NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [self removeTapGestureRecognizer];
}

#pragma mark - Setters

-(void)setSender:(UIView *)sender {
    _sender = sender;
    
    if(!self.keyboardUp)
        return;
    
    [self liftView];
}


#pragma mark - Gesture recognzier methods

-(void)addTapGestureRecognizer {
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    if(self.scrollView) {
        [self.scrollView addGestureRecognizer:self.tapRecognizer];
    }
}

-(void)removeTapGestureRecognizer {
    if(self.tapRecognizer) {
        [self.scrollView removeGestureRecognizer:self.tapRecognizer];
        self.tapRecognizer = nil;
    }
}

-(void)didTap:(UITapGestureRecognizer*)tapRecognizer {
    [self.scrollView endEditing:YES];
}

-(void)liftView {
    if(self.scrollView && self.sender) {
        CGFloat yOffset = self.centerPosition.y - self.sender.frame.origin.y;
        yOffset = fabsf((float)yOffset);
        
        [self.scrollView setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
}

@end
