//
//  AnimalAddPostView.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/16/12.
//
//

#import <UIKit/UIKit.h>
#import "Animal.h"
@interface AnimalAddPostView : UIView<UITextViewDelegate,UITextFieldDelegate>

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal;
    @property (nonatomic,strong) UITextField *userName;
    @property (nonatomic,strong) UITextField *cityField;
    @property (nonatomic,strong) UITextView *postView;
    @property (nonatomic,strong) Animal *animal;

@end
