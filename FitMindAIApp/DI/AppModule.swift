import Swinject

class AppModule: Assembly {
    func assemble(container: Container) {
        // Services
        container.register(HealthKitServiceProtocol.self) { _ in HealthKitService() }
        container.register(GPTServiceProtocol.self) { _ in GPTService() }

        // Repositories
        container.register(HealthRepositoryProtocol.self) { r in
            HealthRepositoryImpl(healthKit: r.resolve(HealthKitServiceProtocol.self)!)
        }
        container.register(AIRepository.self) { r in
            AIRepositoryImpl(gptService: r.resolve(GPTServiceProtocol.self)!)
        }
    }
}