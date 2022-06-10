import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import State "../training_test_models/State";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/AssocList";
import TrieMap "mo:base/TrieMap";
import Type "../training_test_models/Types";
import Types "../training_test_models/Types";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Array "mo:base/Array";

actor {
  var state : State.State = State.empty();

  //Create ID users
  private func create_id_user() : Nat {
    var id : Nat = 0;
    while (true){
      let readUser = state.users.get(id);
      if (readUser == null){
        return id;
      };
      id += 1;
    };
    return 0;
  };

  
  // User
  //Create user
  public shared(msg) func createUser(user: Types.User): async Result.Result<(), Types.Error> {
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae"){
      return #err(#NotAuthorized);
    };

    let id = create_id_user();

    let readUser = state.users.get(id);
    switch (readUser) {
      case (? v){ 
        #err(#AlreadyExisting);
      };
      case null {
        let newUser : Types.User = {
          username = user.username;
          email = user.email;
          phone_number = user.phone_number;
          created_at : ?Int = Option.get(null, ?Time.now());
          updated_at : ?Int = Option.get(null, ?Time.now());
        };
        let createdUser = state.users.put(id, newUser);
        #ok(());
      };
    };
  };

  //Read user
  public shared(msg) func readUser(id: Nat) : async Result.Result<Types.User, Types.Error> {
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.users.get(id);
    return Result.fromOption(result, #NotFound);
  };

  public func check_key() {
    for (k in state.users.keys()){
      Debug.print(debug_show(k));
    };
  };

  // Update user
  public shared(msg) func updateUser(id : Nat, user: Type.User) : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.users.get(id);

    switch (result) {
      case null {
        #err(#NotFound);
      };
      case(?value) {
        let updateUser : Types.User = {
        username = user.username;
        email = user.email;
        phone_number = user.phone_number;
        created_at : ?Int = Option.get(null, ?Time.now());
        updated_at : ?Int = Option.get(null, ?Time.now());
      };
        let result_update = state.users.replace(id, updateUser);
        #ok();
      };
    };
  };

  // Delete user
  public shared(msg) func deleteUser(id: Nat) : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.users.remove(id);

    switch (result) {
      case (null) {
        #err(#NotFound);
      };
      case (?value) {
        #ok();
      };
    };
  };

  //Create ID post
  private func create_id_post() : Nat {
    var id : Nat = 0;
    while (true){
      let readUser = state.posts.get(id);
      if (readUser == null){
        return id;
      };
      id += 1;
    };
    return 0;
  };
  // Post
  // Create post
  public shared(msg) func createPost(post: Type.Post) : async Result.Result<(),Type.Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae"){
      return #err(#NotAuthorized);
    };

    let id = create_id_post();
    let readPost = state.posts.get(id);
    switch (readPost) {
      case (?value){
        #err(#AlreadyExisting);
      };
      case (nulll) {
        let newPost : Type.Post = {
          title = post.title;
          body = post.body;
          author = post.author;
          active = post.active;
          created_at : ?Int = Option.get(null, ?Time.now());
          updated_at : ?Int = Option.get(null, ?Time.now());
        };
        let createPost = state.posts.put(id, newPost);
        #ok();
      };
    };
  };

  //Read post
  public shared(msg) func readPost(id: Nat) : async Result.Result<Types.Post, Types.Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.posts.get(id);
    return Result.fromOption(result, #NotFound);
  };

  // Update post
  public shared(msg) func updatePost(id: Nat, post: Types.Post) : async Result.Result<(), Types.Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.posts.get(id);

    switch (result) {
      case null {
        #err(#NotFound);
      };
      case (?value) {
         let updatePost : Type.Post = {
          title = post.title;
          body = post.body;
          author = post.author;
          active = post.active;
          created_at : ?Int = Option.get(null, ?Time.now());
          updated_at : ?Int = Option.get(null, ?Time.now());
        };
        let result_update = state.posts.replace(id, updatePost);
        #ok();
      };
    };
  };

  //Delete post 
  public shared(msg) func deletePost(id: Nat) : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let result = state.posts.remove(id);

    switch (result) {
      case (null){
        #err(#NotFound);
      };
      case(?value){
        #ok();
      };
    }; 
  };

  //Active post
  //Dang hoat dong len active --> true
  public shared(msg) func activePost(id : Nat) : async Result.Result<(), Types.Error>{
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let readPost = state.posts.get(id);

    switch (readPost) {
      case (null) {
        #err(#NotFound);
      };
      case (?v) { //post exist

        let check_active = v.active;

        if (check_active == true){
          #err(#AlreadyActivePost);
        }
        else {
           //Deactive all post
          for ((key, value) in state.posts.entries()){
            if (key == id){
              let updatePost : Type.Post = {
              title = value.title;
              body = value.body;
              author = value.author;
              active = true;
              created_at : ?Int = Option.get(null, ?Time.now());
              updated_at : ?Int = Option.get(null, ?Time.now());
              };
              let result_update = state.posts.replace(id, updatePost);
            }
            else {
              let updatePost : Type.Post = {
              title = value.title;
              body = value.body;
              author = value.author;
              active = false;
              created_at : ?Int = Option.get(null, ?Time.now());
              updated_at : ?Int = Option.get(null, ?Time.now());
              };
              let result_update = state.posts.replace(key, updatePost);
            }
          };
          #ok();
        };
      };
    };
  };

  // check active 
  // kiem tra bai dang co hoat dong
  public shared(msg) func checkActivePost(id_post: Nat) : async Result.Result<Bool, Type.Error>{
    let callerID = msg.caller;

    let result = state.posts.get(id_post);
    switch (result){
      case(null){
        #err(#NotFound);
      };
      case(?value){
        #ok(value.active == true);
      };
    };
  };

  //List user -> [users]
  public shared(msg) func listUser() : async Result.Result<[Types.User], Types.Error>{
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let user_null : Types.User = {
      username = "";
      email = "";
      phone_number = "";
      created_at = null;
      updated_at = null;
    };

    let list_user : [var Types.User] = Array.init<Types.User>(state.users.size(), user_null);

    var index : Nat = 0;
    for (value in state.users.vals()){ 
      list_user[index] := value;
      index += 1;
    };
    #ok(Array.freeze<Types.User>(list_user));
  };

  //List post -> [posts]
  public shared(msg) func listPost() : async Result.Result<[Types.Post], Types.Error>{
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    let user_null : Types.User = {
      username = "";
      email = "";
      phone_number = "";
      created_at = null;
      updated_at = null;
    };

    let post_null : Types.Post = {
      title = ?"toi la KhA";
      body = null;
      author = user_null;
      active = false;
      created_at = null;
      updated_at = null;
    };

    let list_post : [var Types.Post] = Array.init<Types.Post>(state.posts.size(), post_null);

    var index : Nat = 0;
    for (value in state.posts.vals()){ 
      list_post[index] := value;
      index += 1;
    };
    #ok(Array.freeze<Types.Post>(list_post));
  };
};