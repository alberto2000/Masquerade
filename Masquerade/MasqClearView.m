//
// MasqClearView.m
// Masquerade
//
// Created by Riccardo Lardi on 07/08/14.
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Riccardo Lardi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MasqClearView.h"
#import "MasqAppDelegate.h"

@implementation MasqClearView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init
        [self resetTrackingArea];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSView *)hitTest:(NSPoint)aPoint
{
    NSView * clickedView = [super hitTest:aPoint];
    if (clickedView == nil)
    {
        clickedView = self;
    }
    
    return clickedView;
}

- (void)resetTrackingArea
{
    if (_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
    }
    
    int trackingAreaOptions = (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow);
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:trackingAreaOptions owner:self userInfo:nil];
    
    [self addTrackingArea:_trackingArea];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [_mainController clearViewMouseMoved:theEvent fromId:@"clearview"];
}

@end
