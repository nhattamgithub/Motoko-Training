import Array "mo:base/Array";
import TrieMap "mo:base/TrieMap";
import Result "mo:base/Result";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";

import Types "../Test_models/Types";
import State "../Test_models/State";

actor Users {
    type Bio = Types.Bio;
    type User = Types.User;
    type Post_Info = Types.Post_Info;
    type Post = Types.Post;
    type Error = Types.Error;
    

    // state____________________________________________________________________________
    var state : State.State = State.empty();

    // Users functions____________________________________________________________________________
    public shared(msg) func createUser(b: Bio) : async Result.Result<(),Error> {
        let callerid = msg.caller;
        // Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let readuser = state.users.get(callerid);
        switch (readuser)
        {
            case null {
                 let u : User = {
                    bio = b;
                    created_at = Time.now();
                    updated_at = Time.now();
                    id = callerid;
                };
                let createduser = state.users.put(callerid,u); 
                #ok(());
            };
            case (? v)
            {
                #err(#UserAlreadyExists);
            };
        };

    };

    public shared(msg) func readUser() : async Result.Result<User,Error> {
        let callerid = msg.caller;
		// Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.users.get(callerid);
        return Result.fromOption(result,#UserNotFound);
    };

    public shared(msg) func updateUser(b: Bio) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		// Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.users.get(callerid);
        switch (result)
        {
            case null {
                #err(#UserNotFound);
            };
            case (? v) {
                let u : User = {
                    bio = b;
                    created_at = v.created_at;
                    updated_at = Time.now();
                    id = v.id;
                };
                let updateduser = state.users.replace(callerid,u);
                #ok(());
            };
        };
    };

    public shared(msg) func deleteUser() : async Result.Result<(),Error> {
        let callerid = msg.caller;
        // Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };


        let result = state.users.get(callerid);
        switch (result)
        {
            case null {
                #err(#UserNotFound);
            };
            case (? v) {
                 let deletedduser = state.users.remove(callerid);
                #ok(());
            };
        };
    };

    // // Posts functions____________________________________________________________________________
    public shared(msg) func createPost(i: Post_Info) : async Result.Result<(),Error> {
        // if user havent created, throw error
        let callerid = msg.caller;
		// Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

		
        let result = state.users.get(callerid);
        if (result == null)
        {
            return #err(#UserNotFound);
        };

        //create a post
        let id = state.post_id_counter;
        state := State.increase_postCounter(state);

        let readpost = state.posts.get(id);
        switch (readpost)
        {
            case null 
            {
                let p : Post = {
                    info = i;
                    active = false;
                    author = callerid;
                    created_at = Time.now();
                    updated_at = Time.now();
                };
                let createpost = state.posts.put(id,p);
                #ok(());
            };
            case (? v)
            {
                #err(#PostAlreadyExists);
            };
        };

    };

    public shared(msg) func readPost(id : Nat) : async Result.Result<Post,Error> {
        let result = state.posts.get(id);
        switch (result)
        {
            case null 
            {
                #err(#PostNotFound);
            };
            case (? v)
            {
                // if post is unactive (active == False) and current user isn't the author of the post, throw error
                if (v.active == false and msg.caller != v.author)
                {
                    return #err(#NotAuthorized);
                }; 
                #ok(v);
            };
        }
    };

    public shared(msg) func updatePost(id: Nat,i: Post_Info) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		// Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.posts.get(id);

        switch (result)
        {
            case null {
                #err(#PostNotFound);
            };
            case (? v) {
                // if current user isnt the author of this post, throw error
                if (v.author != callerid)
                {
                    return #err(#NotAuthorized);
                };
                let p : Post = {
                    info = i;
                    active = v.active;
                    author = v.author;
                    created_at = v.created_at;
                    updated_at = Time.now();
                };
                let updatedpost = state.posts.replace(id,p);
                #ok(());
            };
        };
    };


    public shared(msg) func deletePost(id: Nat) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		// Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.posts.get(id);

        switch (result)
        {
            case null {
                #err(#PostNotFound);
            };
            case (? v) {
                // if current user isnt the author of this post, throw error
                if (v.author != callerid)
                {
                    return #err(#NotAuthorized);
                };
                let updatepost = state.posts.remove(id);
                #ok(());
            };
        };
    };
   
    // // Other functions____________________________________________________________________________

    public shared(msg) func activePost(id: Nat) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		// Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.posts.get(id);

        switch (result)
        {
            case null {
                #err(#PostNotFound);
            };
            case (? v) {
                // if current user isnt the author of this post, throw error
                if (v.author != callerid)
                {
                    return #err(#NotAuthorized);
                };
                for (x in state.posts.entries())
                {
                    let postid = x.0;
                    let post = x.1;
                    if (postid == id)
                    {
                        let p: Post = {
                            info = post.info;
                            active = true;
                            author = post.author;
                            created_at = post.created_at;
                            updated_at = post.updated_at;
                        };
                        let updatedpost = state.posts.replace(id,p);
                    } else
                    {
                        let p: Post = {
                            info = post.info;
                            active = false;
                            author = post.author;
                            created_at = post.created_at;
                            updated_at = post.updated_at;
                        };
                        let updatedpost = state.posts.replace(postid,p);
                    };
                    
                };
                
                #ok(());
            };
        };
    };

    public shared(msg) func checkActivePost(id: Nat) : async Result.Result<Bool,Error> {
        let callerid = msg.caller;
		// Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.posts.get(id);

        switch (result)
        {
            case null {
                #err(#PostNotFound);
            };
            case (? v) {
                // if current user isnt the author of this post, throw error
                if (v.author != callerid)
                {
                    return #err(#NotAuthorized);
                };
                #ok(v.active);
            };
        };
    };
 

    public func listUsers() : async [User] {
        var U : [User] = [];
        for (u in state.users.vals())
        {
            U := Array.append(U,[u]);
        };
        U;
    };

    public func listPosts() : async [Post] {
        var P : [Post] = [];
        for (p in state.posts.vals())
        {
            P := Array.append(P,[p]);
        };
        P;
    };

} 