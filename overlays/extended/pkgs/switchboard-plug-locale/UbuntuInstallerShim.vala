namespace SwitchboardPlugLocale.Installer {
  public class UbuntuInstaller : Object {
    public bool install_cancellable;
    public TransactionMode transaction_mode;
    public string transaction_language_code;
    
    public signal void install_finished(string langcode);
    public signal void install_failed();
    public signal void remove_finished(string langcode);
    public signal void check_missing_finished(string [] missing);
    public signal void progress_changed(int progress);

    public enum TransactionMode {
      INSTALL,
      REMOVE,
      INSTALL_MISSING,
    }

    public UbuntuInstaller () {}
    public void install(string langage) {}
    public void instal_packages (string [] packages) {}
    public async void check_missing_languages() {
      string [] dummy = {};
      check_missing_finished (dummy);
    }
    public void install_missing_languages() {}
    public void remove (string languagecode) {}
    public void cancel_install(){}
  }
}
