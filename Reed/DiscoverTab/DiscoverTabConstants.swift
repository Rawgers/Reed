//
//  DiscoverTabConstants.swift
//  Reed
//
//  Created by Roger Luo on 11/2/20.
//  Copyright © 2020 Roger Luo. All rights reserved.
//

import Foundation

enum FetchNarouConstants: Int {
    /* Must be a number large enough to make the screen scroll,
     or else the pagination will fail because the Spacer
     won't be able to move below new entries to "appear" again. */
    case LOAD_INCREMENT = 20
    case MAX_RESULT_INDEX = 2000
}
