module {
    public type Bio = {
        username: ?Text;
        email: ?Text;
        phone_number: ?Text;
    };

    public type User = {
        bio: Bio;
        created_at: Int;
        updated_at: Int;
        id: Principal;
    };

    public type Post_Info = {
        title: ?Text;
        body: Text;
    };

    public type Post = {
        info: Post_Info;
        active: Bool;
        author: Principal; // use Username ID
        created_at: Int;
        updated_at: Int;
    };

    public type Error = {
        #UserNotFound;
        #UserAlreadyExists;
        #PostNotFound;
        #PostAlreadyExists;
        #NotAuthorized;
    };
}