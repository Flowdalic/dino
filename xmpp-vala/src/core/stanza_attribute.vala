namespace Xmpp.Core {
public class StanzaAttribute : StanzaEntry {

    public StanzaAttribute() {}

    public StanzaAttribute.build(string ns_uri, string name, string val) {
        this.ns_uri = ns_uri;
        this.name = name;
        this.val = val;
    }

    public string to_string() {
        if (ns_uri == null) {
            return @"$name='$val'";
        } else {
            return @"{$ns_uri}:$name='$val'";
        }
    }

    public string to_xml(NamespaceState? state_) throws XmlError {
        NamespaceState state = state_ ?? new NamespaceState();
        if (ns_uri == state.current_ns_uri || (ns_uri == XMLNS_URI && name == "xmlns")) {
            return @"$name='$val'";
        } else {
            return "%s:%s='%s'".printf (state.find_name (ns_uri), name, val);
        }
    }
}
}
