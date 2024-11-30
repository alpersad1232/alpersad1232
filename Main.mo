import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor class CareerAdvisor() {
    private type UserProfile = {
        id: Text;
        name: Text;
        age: Nat;
        skills: [Text];
        interests: [Text];
    };

    private type Career = {
        id: Text;
        name: Text;
        description: Text;
        skills: [Text];
        education: Text;
    };

    // Kullanıcı ve kariyer verilerini saklayacak stabil değişkenler
    private stable var users: [UserProfile] = [];
    private stable var careers: [Career] = [];

    // Başlangıç verisini oluştur
    private func initializeCareers() {
        careers := [{
            id = "software_dev";
            name = "Yazılım Geliştirici";
            description = "Yazılım ve uygulama geliştirme";
            skills = ["programlama", "problem çözme"];
            education = "Bilgisayar Mühendisliği";
        }];
    };

    // Yeni kullanıcı oluştur
    public func createUser(
        userId: Text,
        userName: Text, 
        userAge: Nat,
        userSkills: [Text],
        userInterests: [Text]
    ) : async Bool {
        let newUser: UserProfile = {
            id = userId;
            name = userName;
            age = userAge;
            skills = userSkills;
            interests = userInterests;
        };
        users := Array.append(users, [newUser]);
        true
    };

    // Kullanıcı için kariyer önerilerini al
    public query func getRecommendations(userId: Text) : async Text {
        var response = "Kariyer Önerileri\n\n";
        
        let userOpt = Array.find<UserProfile>(users, func(u) = u.id == userId);
        
        switch (userOpt) {
            case (null) { return "Kullanıcı bulunamadı"; };
            case (?user) {
                for (career in careers.vals()) {
                    response #= "\nKariyer: " # career.name;
                    response #= "\nAçıklama: " # career.description;
                    response #= "\nEğitim: " # career.education;
                    response #= "\n-----------------\n";
                };
            };
        };
        
        response
    };

    // Sistemi başlat
    system func preupgrade() {
        initializeCareers();
    };
}
