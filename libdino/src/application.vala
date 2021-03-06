using Gtk;

using Dino.Entities;

public class Dino.Application : Gtk.Application {

    public Database db;
    public StreamInteractor stream_interaction;
    public Plugins.Registry plugin_registry = new Plugins.Registry();

    public Application() throws Error {
        if (DirUtils.create_with_parents(get_storage_dir(), 0700) == -1) {
            throw new Error(-1, 0, @"Could not create storage dir \"$(get_storage_dir())\": $(FileUtils.error_from_errno(errno))");
        }

        // FIXME: Legacy import
        if (FileUtils.test("store.sqlite3", FileTest.IS_REGULAR)) {
            FileUtils.rename("store.sqlite3", Path.build_filename(get_storage_dir(), "dino.db"));
        }

        this.db = new Database(Path.build_filename(get_storage_dir(), "dino.db"));
        this.stream_interaction = new StreamInteractor(db);

        AvatarManager.start(stream_interaction, db);
        MessageManager.start(stream_interaction, db);
        CounterpartInteractionManager.start(stream_interaction);
        PresenceManager.start(stream_interaction);
        MucManager.start(stream_interaction);
        RosterManager.start(stream_interaction);
        ConversationManager.start(stream_interaction, db);
        ChatInteraction.start(stream_interaction);

        activate.connect(() => {
            restore();
        });
    }

    public static string get_storage_dir() {
        return Path.build_filename(Environment.get_user_data_dir(), "dino");
    }

    protected void add_connection(Account account) {
        stream_interaction.connect(account);
    }

    protected void remove_connection(Account account) {
        stream_interaction.disconnect(account);
    }

    private void restore() {
        foreach (Account account in db.get_accounts()) {
            if (account.enabled) add_connection(account);
        }
    }
}

