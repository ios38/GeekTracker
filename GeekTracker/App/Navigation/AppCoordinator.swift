//
//  ApplicationCoordinator.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 07.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//


import Foundation

final class AppCoordinator: Coordinator {
    
    override func start() {
        if UserDefaults.standard.bool(forKey: "isLogin") {
            toMain()
        } else {
            toAuth()
        }
    }
    
    private func toMain() {
        // Создаём координатор главного сценария
        let coordinator = MainCoordinator()
        // Устанавливаем ему поведение на завершение
       coordinator.onFinishFlow = { [weak self, weak coordinator] in
            // Так как подсценарий завершился, держать его в памяти больше не нужно
            self?.removeDependency(coordinator)
            // Заново запустим главный координатор, чтобы выбрать следующий сценарий
            self?.start()
        }
        // Сохраним ссылку на дочерний координатор, чтобы он не выгружался из памяти
        addDependency(coordinator)
        // Запустим сценарий дочернего координатора
        coordinator.start()
    }
    
    private func toAuth() {
        let coordinator = AuthCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
