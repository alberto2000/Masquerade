//
// MasqMaskingView.m
// Masquerade
//
// Created by Riccardo Lardi on 28/07/14.
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

#import "MasqMaskingView.h"
#import "MasqAppDelegate.h"

@implementation MasqMaskingView

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
    
    // black background color
    [[NSColor blackColor] setFill];
    
    NSRectFill(dirtyRect);
}

- (void)resetTrackingArea
{
    if (_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
    }
    
    int trackingAreaOptions = (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow);
    _trackingArea = [[NSTrackingArea alloc] initWithRect:[self getTrackingAreaFrame] options:trackingAreaOptions owner:self userInfo:nil];
    
    [self addTrackingArea:_trackingArea];
}

- (NSRect)getTrackingAreaFrame
{
    NSRect rect;

    if ([_sideId isEqualToString:@"top"]) {
        rect = NSMakeRect(0, 0, self.frame.size.width, 20);
    } else if ([_sideId isEqualToString:@"left"]) {
        rect = NSMakeRect(self.frame.size.width - 20, 0, 20, self.frame.size.height);
    } else if ([_sideId isEqualToString:@"right"]) {
        rect = NSMakeRect(0, 0, 20, self.frame.size.height);
    } else if ([_sideId isEqualToString:@"bottom"]) {
        rect = NSMakeRect(0, self.frame.size.height - 20, self.frame.size.width, 20);
    } else if ([_sideId isEqualToString:@"topleft"]) {
        rect = NSMakeRect(self.frame.size.width - 20, 0, 20, 20);
    } else if ([_sideId isEqualToString:@"topright"]) {
        rect = NSMakeRect(0, 0, 20, 20);
    } else if ([_sideId isEqualToString:@"bottomleft"]) {
        rect = NSMakeRect(self.frame.size.width - 20, self.frame.size.height - 20, 20, 20);
    } else if ([_sideId isEqualToString:@"bottomright"]) {
        rect = NSMakeRect(0, self.frame.size.height - 20, 20, 20);
    }

    return rect;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [_mainController mouseDown:theEvent fromId:_sideId];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [_mainController mouseDragged:theEvent fromId:_sideId];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [_mainController mouseUp:theEvent fromId:_sideId];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [_mainController trackingMouseEntered:theEvent fromId:_sideId];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [_mainController trackingMouseMoved:theEvent fromId:_sideId];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [_mainController trackingMouseExited:theEvent fromId:_sideId];
}

@end
