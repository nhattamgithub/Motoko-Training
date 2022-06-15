import Types "Types";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Text "mo:base/Text";

module {
  private type Map<K,V> = TrieMap.TrieMap<K,V>;
  public type State = {
    users : Map<Text,Types.User>;
    posts: Map<Nat, Types.Post>;
  };

  public func empty() : State {
    {
      users = TrieMap.TrieMap<Text,Types.User>(Text.equal, Text.hash);
      posts = TrieMap.TrieMap<Nat,Types.Post>(Nat.equal, Hash.hash);
    }
  };
}