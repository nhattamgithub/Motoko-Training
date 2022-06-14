import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Types "../train_models/Types";
import State "../train_models/State";

actor {

    var state : State.State = State.empty();
    stable var next_user : Nat = 1;
    stable var next_post : Nat = 1;

    //USER
    type Bio = Types.Bio;
    type User = Types.User;
    type Error = Types.Error;

    //POST
    type PostInfo = Types.PostInfo;
    type Post = Types.Post;

    public shared(msg) func createUser(b: Bio) : async Result.Result<(), Error> {
        let callerid = msg.caller;

        // if (Principal.toText(callerid) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let userid = next_user;
        next_user += 1;

        let result = findUser(b);

        switch(result) {
            case null {
                let newUser : User = {
                    id = callerid;
                    bio = b;
                    created_at = Time.now();
                    updated_at = ?Time.now();
                };
                let createdUser = state.users.put(userid, newUser);
                #ok(());
            };
            case (? v) {
                return #err(#UserAlreadyExists);
            }
        };
    };

    public shared(msg) func readUser(userid : Nat) : async Result.Result<User, Error> {
        // if (Principal.toText(callerid) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let result = state.users.get(userid);
        Result.fromOption(result, #UserNotFound);       
    };

    public shared(msg) func updateUser(userid: Nat, b: Bio) : async Result.Result<(), Error> {
        let callerid = msg.caller;
        // if (Principal.toText(callerid) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let result = state.users.get(userid);

        let find_user = findUser(b);

        switch(result) {
            case null {
              return #err(#UserNotFound);
            };
            case (?v) {
              if (v.id != callerid) {
                return #err(#NotAuthorized);
              };

              if (find_user != null and v.bio.username != b.username) {
                return #err(#UserAlreadyExists);
              };

              let u : User = {
                  id = v.id;
                  bio = b;
                  created_at = v.created_at;
                  updated_at = ?Time.now();
              };

              let updatedUser = state.users.replace(userid, u);
              #ok(());
            }
        };
    };

    public shared(msg) func deleteUser(userid: Nat) : async Result.Result<(), Error> {
        let callerid = msg.caller;
        // if (Principal.toText(callerid) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let result = state.users.get(userid);

        switch(result) {
            case null {
                return #err(#UserNotFound);
            };
            case (?v) {
                if (v.id != callerid) {
                  return #err(#NotAuthorized);
                };

                let deletedUser = state.users.remove(userid);
                #ok(());
            }
        };
    };

    public shared(msg) func createPost(author: Nat, p: PostInfo) : async Result.Result<(), Error> {
        let callerid = msg.caller;
        // if (Principal.toText(callerid) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let author_post = state.users.get(author);

        switch(author_post) {
          case null {
            return #err(#UserNotFound);
          };
          case (? a) {
            let postid = next_post;
            next_post += 1;

            let result = state.posts.get(postid);

            switch(result) {
                case null {
                  if (a.id != callerid) {
                    return #err(#NotAuthorized);
                  };

                  let post : Post = {
                    author = author;
                    active = false;
                    post_info = p;
                    created_at = Time.now();
                    updated_at = Time.now();
                  };
                  let createdPost = state.posts.put(postid, post);
                  #ok(());
                };
                case (? v) {
                  return #err(#PostAlreadyExists);
                };
            };
          };
        };            
    };

    public func readPost(postid: Nat) : async Result.Result<Post, Error> {
        let result = state.posts.get(postid);
        Result.fromOption(result, #PostNotFound);
    };

    public shared(msg) func updatePost(postid: Nat, p: PostInfo) : async Result.Result<(), Error> {
      let callerid = msg.caller;
      // if (Principal.toText(callerid) == "2vxsx-fae") {
      //     return #err(#NotAuthorized);
      // };

      let result = state.posts.get(postid);

      switch(result) {
        case null {
          #err(#PostNotFound);
        };

        case (? v) {
          let user = state.users.get(v.author);
          switch(user) {
            case null {
              return #err(#UserNotFound);
            };
            case (?u) {
              if (u.id != callerid) {
                return #err(#NotAuthorized);
              };
            };
          };

          let post : Post = {
            author = v.author;
            active = v.active;
            post_info = p;
            created_at = v.created_at;
            updated_at = Time.now();
          };
          let updatedPost = state.posts.replace(postid, post);
          #ok(());
        };
      };
    };

    public shared(msg) func deletePost(postid: Nat) : async Result.Result<(), Error> {
        let callerid = msg.caller;
        // if (Principal.toText(callerid) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let result = state.posts.get(postid);

        switch(result) {
          case null {
            #err(#PostNotFound);
          };
          case (? v) {
            // Xet nguoi dung co quyen xoa khong 
            let author_post = state.users.get(v.author);
            switch(author_post) {
              case null {
                return #err(#UserNotFound);
              };

              case (? a) {
                if (a.id != callerid) {
                  return #err(#NotAuthorized);
                };
              };
            };
            
            let deletedPost = state.posts.remove(postid);
            #ok(());
          };
        };
    };

    //Ative Post
    public shared(msg) func activePost(postid: Nat) : async Result.Result<(), Error> {
        let callerid = msg.caller;
        // if (Principal.toText(callerid) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };
        
        let result = state.posts.get(postid);

        switch(result) {
            case null {
                #err(#PostNotFound);
            };
            case (? v) {
              let user = state.users.get(v.author);
              switch(user) {
                case null {
                  return #err(#UserNotFound);
                };

                case (?u) {
                  if (u.id != callerid) {
                    return #err(#NotAuthorized);
                  };
                };
              };

              let post : Post = {
                  author = v.author;
                  active = true;
                  post_info = v.post_info;
                  created_at = v. created_at;
                  updated_at = v.updated_at;
              };
              let activePosts = state.posts.replace(postid, post);

              for (otherposts in state.posts.entries()) {
                  let id = otherposts.0;
                  let p_info = otherposts.1;
                  
                  if (id != postid) {
                      let p : Post = {
                          author = p_info.author;
                          active = false;
                          post_info = p_info.post_info;
                          created_at = p_info. created_at;
                          updated_at = p_info.updated_at;
                      };
                      let activePosts = state.posts.replace(id, p); 
                  };
              };
              #ok(());
            }
        };
    };

    //check active post
    public func checkActivePost(postid: Nat) : async Result.Result<Bool, Error> {
        let result = state.posts.get(postid);

        switch(result) {
            case null {
                #err(#PostNotFound);
            };
            case (?v) {
                #ok(v.active);
            }
        };
    };

    //list users
    public func listUsers() : async [User] {
        var list_users : [User] = [];

        for (user in state.users.vals()) {
            list_users := Array.append(list_users, [user]);
        };
        list_users;
    };

    //list post
    public func listPost() : async [Post] {
        var list_posts : [Post] = [];

        for (post in state.posts.vals()) {
            list_posts := Array.append(list_posts, [post]);
        };
        list_posts;
    };

    private func findUser(b: Bio) : ?User {
      for (user in state.users.vals()) {
        if (b.username == user.bio.username) {
          return ?user;
        };
      };
      null;
    };
    
}
