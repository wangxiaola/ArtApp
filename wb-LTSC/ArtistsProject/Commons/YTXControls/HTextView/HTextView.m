//
//  HTextView.m
//  HUIKitLib
//
//  Created by HeLiulin on 15/11/5.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HTextView.h"

@implementation HTextView

#pragma mark - Accessors

@synthesize attributedPlaceholder = _attributedPlaceholder;

- (void)setText:(NSString *)string {
	[super setText:string];
	[self setNeedsDisplay];
}


- (void)insertText:(NSString *)string {
	[super insertText:string];
	[self setNeedsDisplay];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
	[super setAttributedText:attributedText];
	[self setNeedsDisplay];
}


- (void)setPlaceholder:(NSString *)string {
	if ([string isEqualToString:self.attributedPlaceholder.string]) {
		return;
	}

	NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
	if ([self isFirstResponder] && self.typingAttributes) {
		[attributes addEntriesFromDictionary:self.typingAttributes];
	} else {
		attributes[NSFontAttributeName] = self.font;
		attributes[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.702f alpha:1.0f];
        
		if (self.textAlignment != NSTextAlignmentLeft) {
			NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
			paragraph.alignment = self.textAlignment;
			attributes[NSParagraphStyleAttributeName] = paragraph;
		}
	}

	self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:attributes];
}


- (NSString *)placeholder {
	return self.attributedPlaceholder.string;
}


- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
	if ([_attributedPlaceholder isEqualToAttributedString:attributedPlaceholder]) {
		return;
	}

	_attributedPlaceholder = attributedPlaceholder;

	[self setNeedsDisplay];
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
	[super setContentInset:contentInset];
	[self setNeedsDisplay];
}


- (void)setFont:(UIFont *)font {
	[super setFont:font];
	[self setNeedsDisplay];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	[super setTextAlignment:textAlignment];
	[self setNeedsDisplay];
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self initialize];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	// Draw placeholder if necessary
	if (self.text.length == 0 && self.attributedPlaceholder) {
		CGRect placeholderRect = [self placeholderRectForBounds:self.bounds];
		[self.attributedPlaceholder drawInRect:placeholderRect];
	}
    HBorderDraw *draw=[HBorderDraw new];
    [draw drawBorder:rect andViewBorderWidth:self.borderWidth andViewBorderColor:self.borderColor];
}


- (void)layoutSubviews {
	[super layoutSubviews];

	// Redraw placeholder text when the layout changes if necessary
	if (self.attributedPlaceholder && self.text.length == 0) {
		[self setNeedsDisplay];
	}
}


#pragma mark - Placeholder

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);

	if ([self respondsToSelector:@selector(textContainer)]) {
		rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
		CGFloat padding = self.textContainer.lineFragmentPadding;
		rect.origin.x += padding;
		rect.size.width -= padding * 2.0f;
	} else {
		if (self.contentInset.left == 0.0f) {
			rect.origin.x += 8.0f;
		}
		rect.origin.y += 8.0f;
	}

	return rect;
}


#pragma mark - Private

- (void)initialize {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    self.borderWidth = HViewBorderWidthMake(0, 0, 0, 0);
    self.borderColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.font=[UIFont systemFontOfSize:15];
}


- (void)textChanged:(NSNotification *)notification {
	[self setNeedsDisplay];
}

@end
