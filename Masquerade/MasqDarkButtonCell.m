//
// MasqDarkButtonCell.m
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

#import "MasqDarkButtonCell.h"

@implementation MasqDarkButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    
    CGFloat roundedRadius = 3.0f;
    
    // Outer stroke (drawn as gradient)
    
    [ctx saveGraphicsState];
    NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame
                                                              xRadius:roundedRadius
                                                              yRadius:roundedRadius];
    [outerClip setClip];
    
    NSGradient *outerGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                 [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f,
                                 [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f,
                                 nil];
    
    [outerGradient drawInRect:[outerClip bounds] angle:90.0f];
    [ctx restoreGraphicsState];
    
    // Background gradient
    
    [ctx saveGraphicsState];
    NSBezierPath *backgroundPath =
    [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f)
                                    xRadius:roundedRadius
                                    yRadius:roundedRadius];
    [backgroundPath setClip];
    
    NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                      [NSColor colorWithDeviceWhite:0.17f alpha:1.0f], 0.0f,
                                      [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.12f,
                                      [NSColor colorWithDeviceWhite:0.27f alpha:1.0f], 0.5f,
                                      [NSColor colorWithDeviceWhite:0.30f alpha:1.0f], 0.5f,
                                      [NSColor colorWithDeviceWhite:0.42f alpha:1.0f], 0.98f,
                                      [NSColor colorWithDeviceWhite:0.50f alpha:1.0f], 1.0f,
                                      nil];
    
    [backgroundGradient drawInRect:[backgroundPath bounds] angle:270.0f];
    [ctx restoreGraphicsState];
    
    // Dark stroke
    
    [ctx saveGraphicsState];
    [[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.5f, 1.5f)
                                     xRadius:roundedRadius
                                     yRadius:roundedRadius] stroke];
    [ctx restoreGraphicsState];
    
    // Inner light stroke
    
    [ctx saveGraphicsState];
    [[NSColor colorWithDeviceWhite:1.0f alpha:0.05f] setStroke];
    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.5f, 2.5f)
                                     xRadius:roundedRadius
                                     yRadius:roundedRadius] stroke];
    [ctx restoreGraphicsState];
    
    // Draw darker overlay if button is pressed
    
    if([self isHighlighted]) {
        [ctx saveGraphicsState];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f)
                                         xRadius:roundedRadius
                                         yRadius:roundedRadius] setClip];
        [[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] setFill];
        NSRectFillUsingOperation(frame, NSCompositeSourceOver);
        [ctx restoreGraphicsState];
    }
}

- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    CGContextRef contextRef = [ctx graphicsPort];
    
    NSData *data = [image TIFFRepresentation]; // open for suggestions
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)CFBridgingRetain(data), NULL);
    
    if(source) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CFRelease(source);
        
        // Draw shadow 1px below image
        
        CGContextSaveGState(contextRef);
        {
            NSRect rect = NSOffsetRect(frame, 0.0f, 1.0f);
            CGFloat white = [self isHighlighted] ? 0.2f : 0.35f;
            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
            [[NSColor colorWithDeviceWhite:white alpha:1.0f] setFill];
            NSRectFill(rect);
        }
        CGContextRestoreGState(contextRef);
        
        // Draw image
        
        CGContextSaveGState(contextRef);
        {
            NSRect rect = frame;
            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
            [[NSColor colorWithDeviceWhite:0.1f alpha:1.0f] setFill];
            NSRectFill(rect);
        } 
        CGContextRestoreGState(contextRef);        
        
        CFRelease(imageRef);
    }
}

@end
