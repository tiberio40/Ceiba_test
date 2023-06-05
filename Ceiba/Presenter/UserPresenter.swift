//
//  UserPresentar.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 4/06/23.
//

import Foundation

protocol UserViewPresenter: AnyObject  {
    func loadInfoTable(users: [UserDTO])
    func showErrorService(status: MenssageEnum)
}

class UserPresenter {
    
    weak var view: UserViewPresenter?
    
    init(viewPresenter: UserViewPresenter) {
        self.view = viewPresenter
        self.getUser()
    }
    
    func checkIfExistUserInDb(){
        
    }
    
    func getUser() {
        let userEntity = UserEntity()
        
        do{
            let result: Result<[User], Error> = try userEntity.getAll()
            switch result {
            case .success(let usersDB):
                if usersDB.count == 0 {
                    self.loadDataFromAPI()
                }else{
                    let users = usersDB.map{(item) -> UserDTO in
                        return UserDTO(
                            id: Int(item.id),
                            name: item.name!,
                            username: item.username!,
                            email: item.email!,
                            phone: item.phone!
                        )
                    }
                    self.view?.loadInfoTable(users: users)
                }
                break
                
            case .failure(let error):
                // Aquí manejas el error en caso de que ocurra
                print("Error: \(error)")
            }
        } catch {
            // Aquí manejas cualquier otro error
            print("Error: \(error)")
        }
    }
    
    func loadDataFromAPI(){
        let _userServices = UserServices(urlSubDominio: "/users")
        
        Task{
            
            let (response, _) = await _userServices.get()
            
            guard let data = response else {
                self.view?.showErrorService(status: MenssageEnum.withoutConnection)
                return
            }
            let dataParser = DataParser<[UserDTO]>()
            let result = dataParser.parse(data: data)
            
            switch result{
            case .success(let users):
                do{
                    let userEntity = UserEntity()

                    for user in users {
                        try userEntity.create(todo: user)
                    }
                }catch{

                }
                self.view?.loadInfoTable(users: users)
            case .failure(_):
                print("Error")
            }
            
        }
    }
}
