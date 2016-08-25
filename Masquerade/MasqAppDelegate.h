//
// MasqAppDelegate.h
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

#import <Cocoa/Cocoa.h>
#import "MasqMaskingView.h"
#import "MasqClearView.h"
#import "MasqButton.h"
#import "MasqLogoView.h"

@interface MasqAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) NSWindow *titlebarBackgroundWindow;

@property (strong, nonatomic) MasqClearView *view;
@property (strong, nonatomic) NSView *titlebarView;
@property (strong, nonatomic) MasqLogoView *logoView;

@property (strong, nonatomic) MasqMaskingView *topMaskingView;
@property (strong, nonatomic) MasqMaskingView *leftMaskingView;
@property (strong, nonatomic) MasqMaskingView *rightMaskingView;
@property (strong, nonatomic) MasqMaskingView *bottomMaskingView;

@property (strong, nonatomic) MasqMaskingView *topLeftMaskingView;
@property (strong, nonatomic) MasqMaskingView *topRightMaskingView;
@property (strong, nonatomic) MasqMaskingView *bottomLeftMaskingView;
@property (strong, nonatomic) MasqMaskingView *bottomRightMaskingView;

@property (strong, nonatomic) NSCursor *cursorEastWest;
@property (strong, nonatomic) NSCursor *cursorNorthSouth;
@property (strong, nonatomic) NSCursor *cursorNorthEastSouthWest;
@property (strong, nonatomic) NSCursor *cursorNorthWestSouthEast;

@property (strong, nonatomic) MasqButton* aboutButton;
@property (strong, nonatomic) MasqButton* optionsButton;

@property (strong, nonatomic) NSSound *crashSound;
@property (strong, nonatomic) NSColor *backgroundColor;

@property BOOL cursorInTopMaskingView;
@property BOOL cursorInLeftMaskingView;
@property BOOL cursorInRightMaskingView;
@property BOOL cursorInBottomMaskingView;

@property BOOL cursorInTopLeftMaskingView;
@property BOOL cursorInTopRightMaskingView;
@property BOOL cursorInBottomLeftMaskingView;
@property BOOL cursorInBottomRightMaskingView;

@property BOOL dragging;
@property NSString *draggingArea;

@property int innerWidth;
@property int innerHeight;
@property float appTransparency;
@property float dragTransparency;

@property NSTimer *mouseHideTimer;
@property NSArray *maskAreas;

@property (strong) IBOutlet NSPanel *aboutPanel;
@property (strong) IBOutlet NSPanel *optionsPanel;

@property (strong) IBOutlet NSSliderCell *transparencySlider;
@property (strong) IBOutlet NSButton *colorButton;
@property NSColorPanel *colorPanel;

-(IBAction)onMenuAboutClick:(id)sender;
-(IBAction)onMenuOptionsClick:(id)sender;

-(IBAction)openLinkStephan:(id)sender;
-(IBAction)openLinkRiccardo:(id)sender;

-(IBAction)opacitySliderChanged:(id)sender;
- (IBAction)colorButtonClicked:(id)sender;

-(void)mouseDown:(NSEvent *)theEvent fromId:(NSString *)fromId;
-(void)mouseDragged:(NSEvent *)theEvent fromId:(NSString *)fromId;
-(void)mouseUp:(NSEvent *)theEvent fromId:(NSString *)fromId;

-(void)trackingMouseEntered:(NSEvent *)theEvent fromId:(NSString *)fromId;
-(void)trackingMouseMoved:(NSEvent *)theEvent fromId:(NSString *)fromId;
-(void)trackingMouseExited:(NSEvent *)theEvent fromId:(NSString *)fromId;

-(void)clearViewMouseMoved:(NSEvent *)theEvent fromId:(NSString *)fromId;

-(void)invalidateMouseHideTimer;

@end
