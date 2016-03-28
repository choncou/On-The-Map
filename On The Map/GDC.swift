//
//  GDC.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation

func performUpdateOnMain(updates: () -> Void){
    dispatch_async(dispatch_get_main_queue()){
        updates()
    }
}