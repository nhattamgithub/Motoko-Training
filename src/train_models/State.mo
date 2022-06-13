import Types "Types";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import TrieMap "mo:base/TrieMap";

module {
    private type Map<K,V> = TrieMap.TrieMap<K,V>;

    public type State = {
        users : Map<Nat, Types.User>;
        posts : Map<Nat, Types.Post>;
    };

    public func empty(): State {
        {
        users = TrieMap.TrieMap<Nat, Types.User>(Nat.equal, Hash.hash);
        posts = TrieMap.TrieMap<Nat, Types.Post>(Nat.equal, Hash.hash);
        }
    };

}