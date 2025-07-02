import Swinject

class ViewModelModule: Assembly {
    func assemble(container: Container) {
        container.register(DashboardViewModel.self) { r in
            DashboardViewModel(
                healthRepo: r.resolve(HealthRepositoryProtocol.self)!,
                aiRepo: r.resolve(AIRepository.self)!
            )
        }

        // Extend here: e.g. OnboardingViewModel
    }
}