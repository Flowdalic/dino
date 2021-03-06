using Gee;
using Gtk;

using Dino.Entities;

namespace Dino.Ui.AddConversation {

[GtkTemplate (ui = "/org/dino-im/add_conversation/list_row.ui")]
public class ListRow : ListBoxRow {

    [GtkChild] public Image image;
    [GtkChild] public Label name_label;
    [GtkChild] public Label via_label;

    public Jid? jid;
    public Account? account;

    public ListRow() {}

    public ListRow.from_jid(StreamInteractor stream_interactor, Jid jid, Account account) {
        this.jid = jid;
        this.account = account;

        string display_name = Util.get_display_name(stream_interactor, jid, account);
        if (stream_interactor.get_accounts().size > 1) {
            via_label.label = @"via $(account.bare_jid)";
            this.has_tooltip = true;
            set_tooltip_text(jid.to_string());
        } else if (display_name != jid.bare_jid.to_string()){
            via_label.label = jid.bare_jid.to_string();
        } else {
            via_label.visible = false;
        }
        name_label.label = display_name;
        image.set_from_pixbuf((new AvatarGenerator(35, 35)).draw_jid(stream_interactor, jid, account));
    }
}

}