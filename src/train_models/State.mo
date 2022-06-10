import Types "Types";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";


module {
    private type Map<K,V> = TrieMap.TrieMap<K,V>;

    public type State = {
        users : Map<Principal, Types.User>;
        posts : Map<Nat, Types.Post>;
    };

    public func empty(): State {
        {
        users = TrieMap.TrieMap<Principal, Types.User>(Principal.equal, Principal.hash);
        posts = TrieMap.TrieMap<Nat, Types.Post>(Nat.equal, Hash.hash);
        }
    };

}