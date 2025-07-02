import Swinject

//class PresenterModule: Assembly {
//    func assemble(container: Container) {
//        container.register(DashboardPresenter.self) { r in
//            DashboardPresenter(
//                healthRepository: r.resolve(HealthRepositoryProtocol.self)!,
//                aiRepository: r.resolve(AIRepository.self)!
//            )
//        }
//
//        // Extend with other presenters
//        // container.register(OnboardingPresenter.self) { r in
//        //     OnboardingPresenter(repository: r.resolve(HealthRepositoryProtocol.self)!)
//        // }
//    }
//}
