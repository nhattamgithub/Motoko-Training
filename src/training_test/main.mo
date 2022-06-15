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
import Char "mo:base/Char";

actor {
  var state : State.State = State.empty();

  // User
  //Create user
  public shared(msg) func createUser(user: Types.User): async Result.Result<(), Types.Error> {
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae"){
      return #err(#NotAuthorized);
    };
    if (check_space_text(user.username) == false) {
      let id = user.username;
      let readUser = state.users.get(id);
      switch (readUser) {
        case (? v){ 
          #err(#AlreadyExisting);
        };
        case null {
          let check : Result.Result<(), Types.Error> = check_user(user);
          switch (check) {
            case (#ok()){
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
            case (_){
              return check;
            }
          };
        };
      };
    }
    else {
      #err(#UsernameNotSpace);
    }
  };

  //Read user
  public shared(msg) func readUser(id: Text) : async Result.Result<Types.User, Types.Error> {
    let callerID = msg.caller;
    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };
    if (check_space_text(id) == false){
      let result = state.users.get(id);
      return Result.fromOption(result, #NotFound);
    }
    else {
      #err(#IdNotVailid);
    }
  };

  // Update user
  public shared(msg) func updateUser(id : Text, user: Type.User) : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    if (check_space_text(id) == false){
      let result = state.users.get(id);

      switch (result) {
        case (null){ 
          #err(#NotFound);
        };
        case (?value) {
          let deleted = state.users.remove(id);
          let check : Result.Result<(), Types.Error> = check_user(user);
          switch (check) {
            case (#ok()){
              let updateUser : Types.User = {
                username = user.username;
                email = user.email;
                phone_number = user.phone_number;
                created_at : ?Int = Option.get(null, ?Time.now());
                updated_at : ?Int = Option.get(null, ?Time.now());
              };
                let result_update = state.users.put(user.username, updateUser);
                #ok();
            };
            case (_){
              let result_update = state.users.put(id, value);
              return check;
            }
          };
        };
      };
    }
    else {
      #err(#IdNotVailid);
    }
  };

  // Delete user
  public shared(msg) func deleteUser(id: Text) : async Result.Result<(), Types.Error> {
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

    if (check_space_text(id) == false){
      let result = state.users.remove(id);

      switch (result) {
        case (null) {
          #err(#NotFound);
        };
        case (?value) {
          #ok();
        };
      };
    }
    else {
      #err(#IdNotVailid);
    };
  };

  //Create ID post
  private func create_id_post() : Nat {
    var id : Nat = 0;
    while (state.posts.get(id) != null){
      id += 1;
    };
    return id;
  };
  // Post
  // Create post
  public shared(msg) func createPost(post: Type.Post) : async Result.Result<(),Type.Error>{
    let callerID = msg.caller;

    if (Principal.toText(callerID) == "2vxsx-fae"){
      return #err(#NotAuthorized);
    };

    let find_user = state.users.get(post.author);

    if (find_user != null){
      let id = create_id_post();
      let readPost = state.posts.get(id);
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
    }
    else {
      #err(#UserNotFound);
    }
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
    
    let find_user = state.users.get(post.author);

    let result = state.posts.get(id);

    switch (result) {
      case null {
        #err(#PostNotFound);
      };
      case (?value) {
        let find_user = state.users.get(post.author);
        if (find_user != null) {
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
        }
        else {
          #err(#UserNotFound);
        };
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
           //Deactive another post
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
    if (Principal.toText(callerID) == "2vxsx-fae") {
      return #err(#NotAuthorized);
    };

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
      email = null;
      phone_number = null;
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
    let post_null : Types.Post = {
      title = null;
      body = null;
      author = "";
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

  private func check_space_text(username: Text) : Bool {
    let check : Bool = (Text.contains(username, #char ' '));
    return check;
  };

  private func check_user(user: Types.User) : Result.Result<(), Types.Error> {
    let email : ?Text = user.email;
    let phone_number : ?Text = user.phone_number;
    var m = check_email(email);
    var p = check_phone_number(phone_number);
    if (m != #ok()){
      return m;
    }
    else if (p != #ok()){
      return p;
    };
    for (value in state.users.vals()){
      if (email != null and value.email == email){
        return #err(#EmailAlreadyExisting);
      };
      if (phone_number != null and value.phone_number == phone_number){
        return #err(#PhoneNumberAlreadyExisting);
      };
    };   
    return #ok();
  };

  private func check_email(mail : ?Text) : Result.Result<(), Types.Error> {
    switch (mail) {
      case null #ok();
      case (?mail) {
        var at = -1;
        var count_at = 0;
        var dot = -1;
        let array : [Char] = Iter.toArray(mail.chars());
        var size : Nat = mail.size();
        if (size < 6){
          return #err(#EmailNotValid);
        };
        for (i in Iter.range(1, size-1)){
          if (array[i] == '@'){
            at := i;
            count_at += 1;
          };
          if ((array[i] == '.' and count_at == 0)) {
            return #err(#EmailNotValid);
          };
          if (array[i] == '.'){
            dot := i;
          };
        };
        if (at > dot 
          or Char.isAlphabetic(array[0]) == false 
          or count_at != 1
          or Text.contains(mail, #text "@.")
          or Text.endsWith(mail, #char '.')){
          #err(#EmailNotValid);
        }
        else {
          #ok();
        };
      };
    };
  };

  private func check_phone_number (phone: ?Text) : Result.Result<(), Types.Error> {
    switch (phone) {
      case null return #ok;
      case (?phone) {
        let array_phone : [Char] = Iter.toArray(phone.chars());
        var size : Nat = array_phone.size();
        if (size != 10){
          return #err(#PhoneNumberNotValid);
        };
        for (i in Iter.range(0, size -1)){
          if (Char.isDigit(array_phone[i]) == false){
            return #err(#PhoneNumberNotValid);
          };
        };
      };
    };
    #ok();
  };
}