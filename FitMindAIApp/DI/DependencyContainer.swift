//
//  DependencyContainer.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

import Swinject

class DependencyContainer {
    static let shared = DependencyContainer()
    let assembler: Assembler

    private init() {
        assembler = Assembler([
            AppModule(),
            ViewModelModule()
        ])
    }

    var container: Container {
        assembler.resolver as! Container
    }
}
