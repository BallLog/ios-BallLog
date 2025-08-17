//
//  NicknameViewModel.swift
//  balllog
//
//  Created by 전은혜 on 7/8/25.
//

import Foundation
import Combine

@MainActor
class NicknameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var nickname: String = ""
    @Published var nicknameChecked: Bool = false
    @Published var nicknameValid: Bool = false
    @Published var shouldNavigate: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var validationMessage: String = ""
    
    // MARK: - Computed Properties
    var canCheckNickname: Bool {
        !nickname.trimmingCharacters(in: .whitespaces).isEmpty && !isLoading
    }
    
    var canProceed: Bool {
        nicknameValid && nicknameChecked
    }
    
    var isCurrentNickname: Bool {
        let currentNickname = getSavedNickname() ?? ""
        return nickname.trimmingCharacters(in: .whitespaces) == currentNickname
    }
    
    // MARK: - Private Properties
    private let nicknameService: NicknameServiceProtocol
    private let isUpdateMode: Bool
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(nicknameService: NicknameServiceProtocol = NicknameService(), isUpdateMode: Bool = false) {
        self.nicknameService = nicknameService
        self.isUpdateMode = isUpdateMode
        setupBindings()
        loadSavedNickname()
    }
    
    // MARK: - Public Methods
    func checkNickname() async {
        print("=== 닉네임 중복 확인 시작 ===")
        
        // 로컬 유효성 검사
        let validation = NicknameValidation.validate(nickname)
        
        guard validation.isValid else {
            validationMessage = validation.message
            nicknameChecked = true
            nicknameValid = false
            print("❌ 로컬 유효성 검사 실패: \(validation.message)")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
//            let response = try await nicknameService.checkNicknameAvailability(nickname.trimmingCharacters(in: .whitespaces))
//            
            nicknameChecked = true
            
//            if response.code == "OK" && response.data.isAvailable {
                nicknameValid = true
                validationMessage = "사용가능한 닉네임입니다."
                print("✅ 닉네임 사용 가능")
//            } else {
//                nicknameValid = false
//                validationMessage = response.data.message
//                print("❌ 닉네임 사용 불가: \(response.data.message)")
//            }
            
        }
//        catch {
//            print("❌ 닉네임 확인 오류: \(error)")
//            nicknameChecked = true
//            nicknameValid = false
//            
//            if let nicknameError = error as? NicknameError {
//                validationMessage = nicknameError.localizedDescription
//            } else {
//                validationMessage = "닉네임 확인 중 오류가 발생했습니다."
//            }
//        }
        
        isLoading = false
    }
    
    func proceedToNext() async {
        guard !nickname.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "닉네임을 입력해주세요."
            return
        }
        
        // 로컬 유효성 검사
        let validation = NicknameValidation.validate(nickname)
        guard validation.isValid else {
            validationMessage = validation.message
            nicknameValid = false
            return
        }
        
        print("=== 닉네임 설정 완료 후 다음 단계 진행 ===")
        
        if isUpdateMode {
            await updateNickname()
        } else {
            await createNickname()
        }
    }
    
    func createNickname() async {
        guard !nickname.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "닉네임을 입력해주세요."
            return
        }
        
        // 로컬 유효성 검사
        let validation = NicknameValidation.validate(nickname)
        guard validation.isValid else {
            validationMessage = validation.message
            nicknameValid = false
            return
        }
        
        print("=== 닉네임 생성 시작 ===")
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await nicknameService.updateNickname(nickname.trimmingCharacters(in: .whitespaces))
            
            if response.code == "OK" {
                print("✅ 닉네임 생성 성공")
                shouldNavigate = true
            } else {
                print("❌ 닉네임 생성 실패: \(response.message)")
                errorMessage = response.message
            }
            
        } catch {
            print("❌ 닉네임 생성 오류: \(error)")
            
            if let nicknameError = error as? NicknameError {
                // 중복 닉네임 오류인 경우 validationMessage만 설정하고 errorMessage는 설정하지 않음
                if case .duplicateNickname(let message) = nicknameError {
                    nicknameValid = false
                    validationMessage = message
                    print("🔄 중복 닉네임으로 인해 nicknameValid를 false로 변경: \(message)")
                } else {
                    errorMessage = nicknameError.localizedDescription
                }
            } else {
                errorMessage = "닉네임 생성 중 오류가 발생했습니다."
            }
        }
        
        isLoading = false
    }
    
    func updateNickname() async {
        guard !nickname.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "닉네임을 입력해주세요."
            return
        }
        
        // 로컬 유효성 검사
        let validation = NicknameValidation.validate(nickname)
        guard validation.isValid else {
            validationMessage = validation.message
            nicknameValid = false
            return
        }
        
        print("=== 닉네임 업데이트 시작 ===")
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await nicknameService.updateNickname(nickname.trimmingCharacters(in: .whitespaces))
            
            if response.code == "OK" {
                print("✅ 닉네임 업데이트 성공")
                shouldNavigate = true
            } else {
                print("❌ 닉네임 업데이트 실패: \(response.message)")
                errorMessage = response.message
            }
            
        } catch {
            print("❌ 닉네임 업데이트 오류: \(error)")
            
            if let nicknameError = error as? NicknameError {
                // 중복 닉네임 오류인 경우 validationMessage만 설정하고 errorMessage는 설정하지 않음
                if case .duplicateNickname(let message) = nicknameError {
                    nicknameValid = false
                    validationMessage = message
                    print("🔄 중복 닉네임으로 인해 nicknameValid를 false로 변경: \(message)")
                } else {
                    errorMessage = nicknameError.localizedDescription
                }
            } else {
                errorMessage = "닉네임 업데이트 중 오류가 발생했습니다."
            }
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // 닉네임 입력 시 검사 상태 초기화
        $nickname
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.nicknameChecked = false
                self.nicknameValid = false
                self.validationMessage = ""
            }
            .store(in: &cancellables)
    }
    
    private func loadSavedNickname() {
        if isUpdateMode {
            // 업데이트 모드에서는 저장된 닉네임 로드
            if let savedNickname = nicknameService.getSavedNickname() {
                nickname = savedNickname
                print("📝 저장된 닉네임 로드: \(savedNickname)")
            }
        }
    }
    
    private func getSavedNickname() -> String? {
        return nicknameService.getSavedNickname()
    }
}
