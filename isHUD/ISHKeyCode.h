//
//  ISHKeyCode.h
//  isHUD
//
//  Created by ghawkgu on 11/19/11.
//  Copyright (c) 2011 ghawkgu.
//

#ifndef isHUD_ISHKeyCode_h
#define isHUD_ISHKeyCode_h

// Copied from https://github.com/tekezo/KeyRemap4MacBook/blob/master/src/core/bridge/keycode/data/ModifierFlag.data
enum {
    CAPSLOCK    = 0x10000,

    SHIFT_L     = 0x20002,
    SHIFT_R     = 0x20004,

    CONTROL_L   = 0x40001,
    CONTROL_R   = 0x42000,

    OPTION_L    = 0x80020,
    OPTION_R    = 0x80040,

    COMMAND_L   = 0x100008,
    COMMAND_R   = 0x100010,

    CURSOR      = 0x200000,
    KEYPAD      = 0x200000,
    FN          = 0x800000,

    EXTRA1      = 0x1000000,
    EXTRA2      = 0x2000000,
    EXTRA3      = 0x4000000,
    EXTRA4      = 0x8000000,
    EXTRA5      = 0x10000000,
    NONE        = 0x20000000,
};

#endif
