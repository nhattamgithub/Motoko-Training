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

actor Main {
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
        //Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let readuserid = findUserwithBio(b);
        switch (readuserid)
        {
            case null {
                let userid = state.user_counter;
                 let u : User = {
                    bio = b;
                    created_at = Time.now();
                    updated_at = Time.now();
                    callerid = callerid;
                };
                let createduser = state.users.put(userid,u);
                state := State.increase_userCounter(state);
                #ok(());
            };
            case (? v)
            {
                #err(#UserAlreadyExists);
            };
        };

    };

    public shared(msg) func readUser(id: Nat) : async Result.Result<User,Error> {
        let callerid = msg.caller;

        let result = state.users.get(id);
        return Result.fromOption(result,#UserNotFound);
    };

    public shared(msg) func updateUser(id: Nat,b: Bio) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		//Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };


        let result = state.users.get(id);
        switch (result)
        {
            case null {
                #err(#UserNotFound);
            };
            case (? v) {
                if (v.callerid != callerid)
                {
                    return #err(#NotAuthorized);
                };
                let readuserid = findUserwithBio(b);
                if (readuserid != null and v.bio.username != b.username)
                {
                    return #err(#UserAlreadyExists);
                };
                let u : User = {
                    bio = b;
                    created_at = v.created_at;
                    updated_at = Time.now();
                    callerid = v.callerid;
                };
                let updateduser = state.users.replace(id,u);
                #ok(());
            };
        };
    };

    public shared(msg) func deleteUser(id: Nat) : async Result.Result<(),Error> {
        let callerid = msg.caller;
        //Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.users.get(id);
        switch (result)
        {
            case null {
                #err(#UserNotFound);
            };
            case (? v) {
                if (v.callerid != callerid)
                {
                    return #err(#NotAuthorized);
                };
                let deletedduser = state.users.remove(id);
                #ok(());
            };
        };
    };

    // Posts functions____________________________________________________________________________
    public shared(msg) func createPost(author: Nat,i: Post_Info) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		//Reject Anonymous Identity 
        if (Principal.toText(callerid) == "2vxsx-fae")
        {
            return #err(#NotAuthorized);
        };

        let result = state.users.get(author);
        switch (result)
        {
            // if user havent created, throw error
            case null {
                #err(#UserNotFound);
            };
            case (? u) {
                let id = state.post_id_counter;
                let readpost = state.posts.get(id);
                switch (readpost)
                {
                    //create a post only if the caller is the owner of the user id.
                    case null 
                    {
                        if (u.callerid != callerid)
                        {
                            return #err(#NotAuthorized);
                        };
                        let p : Post = {
                            info = i;
                            active = false;
                            author = author;
                            created_at = Time.now();
                            updated_at = Time.now();
                        };
                        state := State.increase_postCounter(state);
                        let createpost = state.posts.put(id,p);
                        #ok(());
                    };
                    case (? v)
                    {
                        #err(#PostAlreadyExists);
                    };
                };
            };
        };
    };

    public shared(msg) func readPost(id : Nat) : async Result.Result<Post,Error> {
        let callerid = msg.caller;

        let result = state.posts.get(id);
        return Result.fromOption(result,#PostNotFound);
    };

    public shared(msg) func updatePost(id: Nat,i: Post_Info) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		//Reject Anonymous Identity 
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
                let readuser = state.users.get(v.author);
                switch (readuser)
                {
                    case (? u)
                    {
                        if (u.callerid != callerid)
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
                    case null {
                        #err(#UserNotFound);
                    };
                };
            };
        };
    
    };


    public shared(msg) func deletePost(id: Nat) : async Result.Result<(),Error> {
        let callerid = msg.caller;
		//Reject Anonymous Identity 
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
                let readuser = state.users.get(v.author);
                switch (readuser)
                {
                    case (? u)
                    {
                        if (u.callerid != callerid)
                        {
                            return #err(#NotAuthorized);
                        };
                        let updatedpost = state.posts.remove(id);
                        #ok(());
                    };
                    case null {
                        #err(#UserNotFound);
                    };
                };
            };
        };
    };
   
//     // // Other functions____________________________________________________________________________
    private func findUserwithBio(b: Bio) : ?Nat {
        for (e in state.users.entries())
        {
            let k = e.0;
            let u= e.1;
            if (u.bio.username == b.username)
            {
                return ?k;
            };
        };
        null;
    };

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
                let readuser = state.users.get(v.author);
                switch (readuser)
                {
                    case (? u) {
                        if (u.callerid != callerid)
                        {
                            return #err(#NotAuthorized);
                        };
                        for (x in state.posts.keys())
                        {
                            if (x == id)
                            {
                                let p: Post = {
                                    info = v.info;
                                    active = true;
                                    author = v.author;
                                    created_at = v.created_at;
                                    updated_at = v.updated_at;
                                };
                                let updatedpost = state.posts.replace(id,p);
                            } else
                            {
                                let p: Post = {
                                    info = v.info;
                                    active = false;
                                    author = v.author;
                                    created_at = v.created_at;
                                    updated_at = v.updated_at;
                                };
                                let updatedpost = state.posts.replace(x,p);
                            };
                            
                        };
                        
                        #ok(());
                    };
                    case null {
                        #err(#UserNotFound);
                    }
                }
                
            };
        };
    };

    public shared(msg) func checkActivePost(id: Nat) : async Result.Result<Bool,Error> {
        let result = state.posts.get(id);
        switch (result)
        {
            case null {
                #err(#PostNotFound);
            };
            case (? v) {
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