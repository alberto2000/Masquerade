//
// MasqLogoView.m
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

#import "MasqLogoView.h"
#import "MasqAppDelegate.h"

@implementation MasqLogoView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init
        _originalFrame = frame;
        [self setAutoresizesSubviews:YES];
    }
    return self;
}

- (NSView *)hitTest:(NSPoint)aPoint
{
    return nil;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // add background image
    NSRect rect = NSMakeRect(_originalFrame.size.width / 2 - _originalFrame.size.height / 2 * 0.75, _originalFrame.size.height / 2 - _originalFrame.size.height / 2 * 0.75, _originalFrame.size.height * 0.75, _originalFrame.size.height * 0.75);
    [[NSImage imageNamed:@"icon_1024x1024"] drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void)animateLogo
{
    [self setAlphaValue:1.0];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.5];
    [[self animator] setAlphaValue:0.0];
    [NSAnimationContext endGrouping];

}

@end
